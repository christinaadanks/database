package servlets;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

@WebServlet(name = "SelectServlet", value = "/SelectServlet")
public class SelectServlet extends HttpServlet {

    private Connection connection = null;
    String url = "jdbc:mysql://localhost:3306/hospital"; // database connection url
    String password = "horseliu"; // database password
    String username = "root"; // database username

    // doGet method on servlet. If the submitted from has method = "get", this will be called.
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // we call doPost() to avoid duplicate code
        doPost(request, response);
    }

    // doPost method on servlet. If the submitted from has method = "post", this will be called.
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int treatment = -1;
        if (!request.getParameter("treatment_id").isEmpty()) {
            treatment = Integer.parseInt(request.getParameter("treatment_id"));
        }
        String startDate = request.getParameter("start_date");
        String endDate = request.getParameter("end_date");
        String employee = request.getParameter("employee_lastname");
        String patient = request.getParameter("patient_lastname");

        // here you put your queries
        ArrayList<String> outbound = new ArrayList<>();
        ArrayList<String> queries = new ArrayList<>();
        ArrayList<String> titles = new ArrayList<>();
        queries.add(0, "SELECT p.room_number, CONCAT (p.firstname, \" \", p.lastname), ap.arrival_date " +
                "FROM patients p NATURAL JOIN admitted_patients ap " +
                "WHERE ap.discharge_date IS NULL");
        queries.add(1, "SELECT DISTINCT p.room_number " +
                "FROM patients p JOIN admitted_patients ap " +
                "WHERE ap.discharge_date IS NOT NULL AND p.room_number NOT IN (" +
                "SELECT d.room_number FROM patients d " +
                "INNER JOIN admitted_patients da ON d.patient_id = da.patient_id " +
                "WHERE da.discharge_date IS NULL)");
        queries.add(2, "SELECT p.room_number, CONCAT (p.firstname, \" \", p.lastname), ap.arrival_date " +
                "FROM patients p " +
                "JOIN admitted_patients ap ON p.patient_id = ap.patient_id " +
                "WHERE ap.discharge_date IS NULL " +
                "UNION SELECT r.room_number, null, null " +
                "FROM patients r JOIN admitted_patients ra ON r.patient_id = ra.patient_id " +
                "WHERE ra.discharge_date IS NOT NULL AND r.room_number NOT IN (" +
                "SELECT d.room_number FROM patients d " +
                "JOIN admitted_patients da ON d.patient_id = da.patient_id " +
                "WHERE da.discharge_date IS NULL)");
        queries.add(3, "SELECT p.patient_id, CONCAT (p.firstname, \" \", p.lastname), p.room_number, ec.contact_name, ec.contact_phone, " +
                "i.insurance_policy, i.insurance_company, CONCAT (e.firstname, \" \", e.lastname) " +
                "FROM patients p INNER JOIN emergency_contacts ec ON ec.emergency_contact_id = p.emergency_contact_id " +
                "INNER JOIN insurance i ON i.insurance_id = p.insurance_id " +
                "INNER JOIN employees e ON e.employee_id = p.employee_id");
        queries.add(4, "SELECT p.patient_id, CONCAT (p.firstname, \" \", p.lastname) " +
                "FROM patients p NATURAL JOIN admitted_patients ap " +
                "WHERE ap.discharge_date IS NULL");
        queries.add(5, "SELECT p.patient_id, CONCAT (p.firstname, \" \", p.lastname) " +
                "FROM patients p NATURAL JOIN admitted_patients ap " +
                "WHERE ap.discharge_date BETWEEN " +  "\"" + startDate + "\" AND " + "\"" + endDate + "\"");
        queries.add(6, "SELECT p.patient_id, CONCAT (p.firstname, \" \", p.lastname)" +
                "FROM patients p NATURAL JOIN admitted_patients ap " +
                "WHERE ap.arrival_date BETWEEN " +  "\"" + startDate + "\" AND " + "\"" + endDate + "\"");
        queries.add(7, "SELECT p.patient_id, CONCAT (p.firstname, \" \", p.lastname), ap.arrival_date, ap.initial_diagnosis " +
                "FROM admitted_patients ap " +
                "NATURAL JOIN patients p " +
                "WHERE p.lastname =" +
                "\"" + patient + "\"");
        queries.add(8, "SELECT ap.arrival_date, t.treatment_name, t.timestamp " +
                "FROM admitted_patients ap JOIN patients p ON p.patient_id = ap.patient_id " +
                "JOIN treatments t ON t.patient_id = ap.patient_id WHERE p.lastname =" + "\"" + patient + "\" " +
                "AND t.timestamp BETWEEN ap.arrival_date AND ap.discharge_date " +
                "GROUP BY ap.arrival_date, t.timestamp ORDER BY ap.arrival_date DESC, t.timestamp ASC");
        queries.add(9,"SELECT p.patient_id, CONCAT (p.firstname, \" \", p.lastname), initial_diagnosis, CONCAT (e.firstname, \" \", e.lastname) " +
                "FROM patients p INNER JOIN admitted_patients ap ON ap.patient_id = p.patient_id " +
                "INNER JOIN employees e ON p.employee_id = e.employee_id " +
                "INNER JOIN (SELECT patient_id, MAX(admit_id) AD, MAX(arrival_date) A, MAX(discharge_date) D " +
                "FROM admitted_patients GROUP BY patient_id " +
                "HAVING MAX(arrival_date) < MAX(discharge_date) + INTERVAL 30 DAY AND A > D) B " +
                "ON p.patient_id = B.patient_id AND ap.admit_id = B.AD GROUP BY p.patient_id");
        queries.add(10, "SELECT p.patient_id, CONCAT (p.firstname, \" \", p.lastname), " +
                "COUNT(A.patient_id), AVG(DATEDIFF(A.discharge_date, A.arrival_date)), MAX(DATEDIFF(A.arrival_date, discharge)), " +
                "MIN(DATEDIFF(A.arrival_date, discharge)), AVG(DATEDIFF(A.arrival_date, discharge)) " +
                "FROM patients p INNER JOIN (SELECT admit_id, patient_id, arrival_date, discharge_date, " +
                "LAG(discharge_date, 1, null) OVER (PARTITION BY patient_id ORDER BY arrival_date, discharge_date) discharge " +
                "FROM admitted_patients) A ON A.patient_id = p.patient_id GROUP BY p.patient_id");
        queries.add(11, "SELECT initial_diagnosis, count(*) " +
                "FROM admitted_patients " +
                "GROUP BY initial_diagnosis " +
                "ORDER BY count(*) DESC");
        queries.add(12, "SELECT initial_diagnosis, count(*) " +
                "FROM admitted_patients " +
                "WHERE discharge_date IS NULL " +
                "GROUP BY initial_diagnosis " +
                "ORDER BY count(*) DESC");
        queries.add(13, "SELECT treatment_name, count(*) " +
                "FROM treatments " +
                "GROUP BY treatment_name " +
                "ORDER BY count(*) DESC");
        queries.add(14, "SELECT ap.patient_id, CONCAT (p.firstname, \" \", p.lastname), ap.initial_diagnosis, ap.arrival_date, A.admissions " +
                "FROM patients p " +
                "NATURAL JOIN admitted_patients ap " +
                "JOIN (SELECT patient_id, initial_diagnosis, arrival_date, COUNT(patient_id) AS admissions " +
                "FROM admitted_patients " +
                "GROUP BY patient_id " +
                "HAVING COUNT(patient_id) = (SELECT MAX(D.admissions) " +
                "FROM (SELECT COUNT(patient_id) admissions " +
                "FROM admitted_patients " +
                "GROUP BY patient_id) D)) A ON A.patient_id = p.patient_id " +
                "GROUP BY ap.patient_id, ap.initial_diagnosis, ap.arrival_date " +
                "ORDER BY ap.arrival_date ASC");
        queries.add(15, "SELECT t.treatment_id, CONCAT (p.firstname, \" \", p.lastname), CONCAT (e.firstname, \" \", e.lastname) " +
                "FROM treatments t " +
                "INNER JOIN patients p ON t.patient_id = p.patient_id " +
                "INNER JOIN employees e ON t.employee_id = e.employee_id " +
                "WHERE treatment_id =" + treatment);
        queries.add(16, "SELECT lastname, firstname, category " +
                "FROM employees " +
                "ORDER BY lastname ASC");
        queries.add(17, "SELECT DISTINCT CONCAT (e.firstname, \" \", e.lastname), CONCAT (p.firstname, \" \", p.lastname) " +
                "FROM employees e INNER JOIN patients p ON e.employee_id = p.employee_id " +
                "INNER JOIN admitted_patients ap ON p.patient_id = ap.patient_id " +
                "WHERE ap.arrival_date > now() - INTERVAL 1 YEAR " +
                "GROUP BY e.lastname, p.lastname " +
                "HAVING count(arrival_date) >= 4");
        queries.add(18, "SELECT CONCAT (e.firstname, \" \", e.lastname), ap.initial_diagnosis, COUNT(ap.initial_diagnosis) occurrences " +
                "FROM admitted_patients ap INNER JOIN patients p ON p.patient_id = ap.patient_id " +
                "INNER JOIN employees e ON e.employee_id = p.employee_id " +
                "WHERE e.lastname =" + "\"" + employee + "\" " +
                "GROUP BY ap.initial_diagnosis " +
                "ORDER BY occurrences DESC");

        queries.add(19, "SELECT CONCAT (e.firstname, \" \", e.lastname), t.treatment_name, COUNT(t.treatment_name) " +
                "FROM treatments t INNER JOIN patients p ON p.patient_id = t.patient_id " +
                "INNER JOIN employees e ON e.employee_id = p.employee_id " +
                "WHERE e.lastname =" + "\"" + employee + "\" " +
                "GROUP BY t.treatment_name " +
                "ORDER BY COUNT(t.treatment_name) DESC");
        queries.add(20, "SELECT t.employee_id, CONCAT (e.firstname, \" \", e.lastname) " +
                "FROM employees e NATURAL JOIN treatments t " +
                "GROUP BY t.employee_id HAVING COUNT(DISTINCT patient_id) = (SELECT COUNT(DISTINCT p.patient_id) " +
                "FROM treatments p)");

        // get values from form, focus on the name of select field -> name="select_sql"
        int value_from_form = Integer.parseInt(request.getParameter("select_sql"));

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection(url, username, password);
            PrintWriter out = response.getWriter();
            Statement statement = connection.createStatement();
            ResultSet resultSet = statement.executeQuery(queries.get(value_from_form));
            ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
            int columnCount = resultSetMetaData.getColumnCount();
            // first loop to get all tuples
            while(resultSet.next()) {
                // second loop to get all columns in each tuple
                for(int i=1; i<=columnCount; i++) {
                    String column_title = resultSetMetaData.getColumnName(i).trim();
                    // Data type object since the columns can be int, string, or datetime
                    Object column_value = resultSet.getObject(column_title);
                    out.print(column_value + " ");
                    if (column_value == null)   {
                        outbound.add("N/A");
                    }
                    else    {
                        outbound.add(column_value.toString());
                    }
                    if (titles.size() < columnCount) {
                        if (column_title.toLowerCase().contains("count")) {
                            titles.add("occurrences");
                        }
                        else if ((column_title.contains("CONCAT") && column_title.contains("p.firstname")))   {
                            titles.add("patient name");
                        }
                        else if (column_title.contains("CONCAT") && column_title.contains("e.firstname"))    {
                            titles.add("doctor name");
                        }
                        else if(column_title.contains("AVG(DATEDIFF(A.discharge"))  {
                            titles.add("avgerage duration of stay (days)");
                        }
                        else if(column_title.contains("MAX(DATEDIFF"))  {
                            titles.add("max span between admissions");
                        }
                        else if(column_title.contains("MIN(DATEDIFF"))  {
                            titles.add("min span between admissions");
                        }
                        else if(column_title.contains("AVG(DATEDIFF(A.arrival"))    {
                            titles.add("avgerage span between admissions (days)");
                        }
                        else if(column_title.contains("_"))  {
                            titles.add(column_title.replace('_', ' '));
                        }

                        else    {
                            titles.add(column_title);
                        }
                    }
                }
            }
            request.setAttribute("employeeName", employee);
            request.setAttribute("treatment", treatment);
            request.setAttribute("patientName", patient);
            request.setAttribute("startDate", startDate);
            request.setAttribute("endDate", endDate);
            request.setAttribute("formValue", value_from_form);
            request.setAttribute("titles", titles);
            request.setAttribute("columnCount", columnCount);
            request.setAttribute("arraylist", outbound);
            RequestDispatcher requestDispatcher = getServletContext().getRequestDispatcher("/query.jsp");
            requestDispatcher.forward(request, response);

        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
    }
}