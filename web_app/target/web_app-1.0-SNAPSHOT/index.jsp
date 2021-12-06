<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <title>hospital database</title>
</head>
<style>
    @import url('https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Lobster+Two:ital@1&display=swap');
    @import url('https://fonts.googleapis.com/css2?family=Montserrat&display=swap');
    @import url('https://fonts.googleapis.com/css2?family=Chivo:wght@300&family=Playfair+Display:ital,wght@1,600&display=swap');
    body{
        background-color: #54586C;
        color: white;
        margin: 50px;
        font-family: 'chivo', sans-serif;
    }
    i {
        font-style: italic;
        font-family: 'bebas neue', sans-serif;
    }
    h4  {
        font-size: 26px;
        font-family: 'Bebas Neue', sans-serif;
        color: #23242C;
        margin:0;
    }
    h2  {
        text-align: center;
        font-size: 38px;
        font-family: 'Bebas Neue', sans-serif;
        color: #23242C;
        margin:0;
    }
    h1  {
        text-align: center;
        font-size: 68px;
        font-family: 'Bebas Neue', sans-serif;
        color: #EAFF92;
    }
    div.a {
        margin: auto;
        width:80%;
        color: rgba(255,255,255,.6);
        font-size: 16px;
    }
    div.box {
        padding: 20px;
        margin: 50px auto;
        width: 80%;
        border: 2px solid #23242C;
        color: rgba(255,255,255,.6);
        font-size: 16px;
        box-shadow: 0 0 20px rgba(0,0,0,0.15);
    }
    div.c   {
        width: 50%;
        margin: auto;
        border-radius: 15px;
        background-color: rgba(255,255,255,.2);
        padding: 10px 20px 10px 20px;
        overflow:hidden;
        display: grid;
        box-shadow: 0 0 20px rgba(0,0,0,0.15);
        place-items: center;
    }
    input#go  {
        cursor: pointer;
        font-family: 'Bebas Neue', sans-serif;
        font-size: 28px;
        margin: 20px auto 5px auto;
        width: 100%;
        background-color: #54586C;
        background-image: linear-gradient(0, #23242C, #23242C);
        background-size:0;
        color: #23242C;
        padding: 14px 20px;
        border: none;
        border-radius: 30px;
        box-shadow: 0 0 20px rgba(0,0,0,0.15);
        transition:.8s;
        background-repeat: no-repeat;
    }
    input#go:hover   {
        background-size: 100%;
        color: rgba(255,255,255,.7);
    }
    #employee, #treatment, #patient,
    #start_date, #end_date{
        font-family: 'chivo', sans-serif;
        position: relative;
        width: 80%;
        margin: 5px auto;
        padding: 10px;
        font-size: 14px;
        background-color: #2E3140;
        opacity: 80%;
        color: rgba(255,255,255,.7);
        border:none;
    }
    #employee:focus::placeholder,
    #treatment:focus::placeholder,
    #patient:focus::placeholder,
    #start_date:focus::placeholder,
    #end_date:focus::placeholder{
        color: rgba(255,255,255,.7);
    }
    #employee::placeholder,
    #treatment::placeholder,
    #patient::placeholder,
    #start_date::placeholder,
    #end_date::placeholder{
        color: gray;
    }
    #query-form {
        margin: auto;
        font-size: 14px;
    }
    select  {
        font-family: 'chivo', sans-serif;
        width: 100%;
        font-size: 14px;
        padding: 15px 50px 15px 15px;
        background: #54586C;
        color:rgba(255,255,255,.7);
        border: none;
        box-shadow: 0 0 20px rgba(0,0,0,0.15);
    }
    .custom-select  {
        width: 100%;
        position: relative;
    }
    .custom-arrow   {
        position: absolute;
        top:0;
        right:0;
        display: block;
        background: #2E3140;
        height: 100%;
        width: 50px;
        pointer-events: none;
    }
    .custom-arrow::before,
    .custom-arrow::after{
        --size: .6em;
        content: '';
        position: absolute;
        width:0;
        height:0;
        left: 50%;
        top: 50%;
        transform: translate(-50%, -50%);
    }
    .custom-arrow::before{
        border-left: var(--size) solid transparent;
        border-right: var(--size) solid transparent;
        border-bottom: var(--size) solid rgba(255,255,255,.7);
        top: 35%;
    }
    .custom-arrow::after{
        border-left: var(--size) solid transparent;
        border-right: var(--size) solid transparent;
        border-top: var(--size) solid rgba(255,255,255,.7);
        top: 65%;
    }
</style>
<script>
    $(document).ready(function() {
        $("#select_sql").change(function() {
            if (($(this).val() == "19") || ($(this).val() == "18")) {
                $('#employee_entry').show();
            } else {
                $('#employee_entry').hide();
            }
            if ($(this).val() == "15")  {
                $('#treatment_entry').show();
            }   else    {
                $('#treatment_entry').hide();
            }
            if (($(this).val() == "7") || ($(this).val() == "8")) {
                $('#patient_entry').show();
            } else {
                $('#patient_entry').hide();
            }
            if (($(this).val() == "5") || ($(this).val() == "6")) {
                $('#date_entry').show();
            } else {
                $('#date_entry').hide();
            }
        });
        $("#select_sql").trigger("change");
    });
</script>
<body>
<h1>modern hospital database</h1>
<BR><BR>
<div class = "c">
    <h2>sql query request</h2>
    <BR>
    <form action="SelectServlet" method="post" id="query-form"> <%-- Notice, mathod = POST, doPost() method is called on form submit --%>
        <div class = "custom-select">
            <select name="select_sql" id="select_sql">
                <option value = "" disabled selected>select a query</option>
                <option value="0">1.1 occupied rooms</option>
                <option value="1">1.2 unoccupied rooms</option>
                <option value="2">1.3 all rooms +</option>
                <option value="3">2.1 all patients</option>
                <option value="4">2.2 patients in hospital</option>
                <option value="5">2.3 patients discharged between</option>
                <option value="6">2.4 patients admitted between</option>
                <option value="7">2.5 admission + diagnosis for</option>
                <option value="8">2.6 treatments for</option>
                <option value="9">2.7 patients admitted within 30 days</option>
                <option value="10">2.8 all patient admittance data</option>
                <option value="11">3.1 all patient diagnoses</option>
                <option value="12">3.2 current patient diagnoses</option>
                <option value="13">3.3 treatments</option>
                <option value="14">3.4 diagnoses for regular patients</option>
                <option value="15">3.5 treatment data for</option>
                <option value="16">4.1 all employees</option>
                <option value="17">4.2 doctor for regular patients</option>
                <option value="18">4.3 diagnoses data for</option>
                <option value="19">4.4 treatment data for</option>
                <option value="20">4.5 employee of the month</option>
            </select>
            <span class = "custom-arrow"></span>
        </div>
        <BR>
        <div class = "d_entries" id = "date_entry">
            <input type="date" id="start_date" name="start_date" />
            <input type="date" id="end_date" name="end_date"/>
        </div>
        <div class = "e_entries" id = "employee_entry">
            <input type = "text" id = "employee" name="employee_lastname" placeholder ="enter employee last name"/>
        </div>

        <div class = "t_entries" id = "treatment_entry">
            <input type = "text" id = "treatment" name="treatment_id" placeholder="enter treatment ID"/>
        </div>

        <div class = "p_entries" id = "patient_entry">
            <input type = "text" id = "patient" name="patient_lastname" placeholder="enter patient last name"/>
        </div>

        <input type="submit" id="go" value="submit"/>
    </form>
</div>

<div class ="box">
    <h2>queries list:</h2>
    <h4>1. room utilization</h4>
    &emsp;&emsp;<i>1.1</i>&emsp;list rooms that are occupied: patients names + admission dates<br>
    &emsp;&emsp;<i>1.2</i>&emsp;list currently unoccupied rooms<br>
    &emsp;&emsp;<i>1.3</i>&emsp;list all rooms: patient names + admission dates for occupied rooms
    <h4>2. patient information</h4>
    &emsp;&emsp;<i>2.1</i>&emsp;list all patients: full personal info<br>
    &emsp;&emsp;<i>2.2</i>&emsp;list all patients currently in hospital: id + name<br>
    &emsp;&emsp;<i>2.3</i>&emsp;list all patients discharged in a given date range: id + name:<br>
    &emsp;&emsp;<i>2.4</i>&emsp;list all patients admitted in a given date range: id + name:<br>
    &emsp;&emsp;<i>2.5</i>&emsp;for a given patient: all admissions + diagnosis each admission:<br>
    &emsp;&emsp;<i>2.6</i>&emsp;for a given patient: all treatments (ascending) grouped by admissions (descending):<br>
    &emsp;&emsp;<i>2.7</i>&emsp;list patients admitted within 30 days of last discharge: id + name + diagnosis + doctor<br>
    &emsp;&emsp;<i>2.8</i>&emsp;for each patient ever admitted: total # of admissions + average duration of each admission
    + longest span b/t admissions + shortest span b/t admissions + average span b/t admissions
    <h4>3. diagnosis + treatment information</h4>
    &emsp;&emsp;<i>3.1</i>&emsp;list diagnoses given to patients: diagnosis + occurrences (descending)<br>
    &emsp;&emsp;<i>3.2</i>&emsp;list diagnoses given to current patients: diagnosis + occurrences (descending)<br>
    &emsp;&emsp;<i>3.3</i>&emsp;list treatments performed on patients: treatment + occurrences (descending)<br>
    &emsp;&emsp;<i>3.4</i>&emsp;list diagnoses associated w/ patients who have the highest occurrence of admissions (ascending)<br>
    &emsp;&emsp;<i>3.5</i>&emsp;for a given treatment occurrence: patient + doctor:
    <h4>4. employee information</h4>
    &emsp;&emsp;<i>4.1</i>&emsp;list all employees at hospital: last name (ascending) + first name + job<BR>
    &emsp;&emsp;<i>4.2</i>&emsp;list primary doctor of patients with high admission rates (at least 4 admissions within 1 year)<BR>
    &emsp;&emsp;<i>4.3</i>&emsp;for a given doctor: all diagnoses + occurrences (descending):<BR>
    &emsp;&emsp;<i>4.4</i>&emsp;for a given doctor: all treatments + occurrences (descending):<BR>
    &emsp;&emsp;<i>4.5</i>&emsp;list employees who have been involved in the treatment of every admitted patient
<br/> <br><BR>
</div>
<%-- Before getting started, make sure to install Tomcat from https://tomcat.apache.org/ --%>
<%-- For windows, Tomcat will be installed at C:/->Program Files->Apache Software  Foundation -> Tomcat x.xx --%>
<%--Once installed, add Tomcat configuration in IntelliJ, follow https://learntocodetogether.com/configure-tomcat-server-on-intellij-idea/ --%>
<%-- A simple form that provides SQL options and redirects to SelectServlet --%>

</body>
</html>