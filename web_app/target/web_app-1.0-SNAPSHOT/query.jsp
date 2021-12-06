<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.util.Iterator" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt" %>
<%--
  Created by IntelliJ IDEA.
  User: christinaadanks
  Date: 11/20/21
  Time: 6:10 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <title>query results</title>
</head>
<style>
    @import url('https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Lobster+Two:ital@1&display=swap');
    @import url('https://fonts.googleapis.com/css2?family=Chivo:wght@300&family=Playfair+Display:ital,wght@1,600&display=swap');
    body{
        background-color: #54586C;
        margin: 50px;
        font-size: 14px;
        color: rgba(255,255,255,.7);
    }
    p   {
        font-family: 'chivo', sans-serif;
        color: #23242C;
        font-size: 14px;
    }
    h1  {
        text-align: center;
        font-size: 68px;
        font-family: 'Bebas Neue', sans-serif;
        color: #EAFF92;
    }
    h4  {
        text-align: center;
        font-size: 22px;
        font-family: 'Bebas Neue', sans-serif;
        color: #23242C;
        margin:0;
    }
    input#go  {
        cursor: pointer;
        font-family: 'Bebas Neue', sans-serif;
        font-size: 28px;
        margin: 20px auto 5px auto;
        width: 50%;
        background-color: rgba(255,255,255,.5);
        background-image: linear-gradient(0, #23242C, #23242C);
        background-size:0;
        color: #2E3140;
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
    #home   {
        display: grid;
        place-items: center;
    }
    div.a   {
        text-align: center;
        width: 50%;
        margin: auto;
        background-color: rgba(255,255,255,.5);
        border-radius: 15px;
        overflow: hidden;
        color: #23242C;
        padding: 10px;
        box-shadow: 0 0 20px rgba(0,0,0,0.15);
    }
    .query-table {
        font-family: 'chivo', sans-serif;
        font-size: 14px;
        min_width: 400px;
        color: #23242C;
        margin: auto;
        border-collapse: collapse;
        border-radius: 15px 15px 0 0;
        background-color: rgba(255,255,255, .3);
        overflow: hidden;
        box-shadow: 0 0 20px rgba(0,0,0,0.15);
    }
    .query-table tbody tr   {
        border-bottom: 1px solid rgba(46,49,64,.2) ;
        text-align: left;
    }
    .query-table tbody tr:last-of-type  {
        border-bottom: 2px solid #EAFF92;
    }
    .query-table thead tr   {
        font-family: 'bebas neue', sans-serif;
        background-color: #23242C;
        text-align: left;
        padding: 26px;
        font-size:18px;
        color: rgba(255,255,255,.7)
    }
    .query-table th,
    .query-table td {
        text-align: left;
        padding: 12px 18px;
    }
    .query-table tbody tr:nth-of-type(even)   {
        background: rgba(255,255,255,.35);
    }
</style>
<%ArrayList<String> list = (ArrayList<String>)request.getAttribute("arraylist");
ArrayList<String> headers = (ArrayList<String>)request.getAttribute("titles");
int columnSize = (int)request.getAttribute("columnCount");
int valueForm = (int)request.getAttribute("formValue");
%>
<body>
<h1>
    query results
</h1>
<div class ="a">
<%switch (valueForm)    {
    case 0: %>
    <h4>query 1.1</h4>
    <p>table displays the rooms currently <b>occupied</b> in the
            hospital + which patient currently occupies the room + date patient was admitted</p>
        <%break;
    case 1:%>
    <h4>query 1.2</h4>
    <p>table displays the rooms currently <b>unoccupied</b> in the hospital</p>
        <%break;
    case 2:%>
    <h4>query 1.3</h4>
    <p>table displays <b>ALL rooms</b> in the hospital + patients & their admittance dates
            for those currently occupied</p>
        <%break;
    case 3:%>
    <h4>query 2.1</h4>
    <p>table displays <b>all patients</b> in the hospital database with full personal information</p>
        <%break;
    case 4:%>
    <h4>query 2.2</h4>
    <p>table displays patients <b>currently admitted</b> in the hospital</p>
        <%break;
    case 5:%>
    <h4>query 2.3</h4>
    <p>table displays all patients who were <b>discharged</b> between:</p>
    <c:out value="${startDate} & ${endDate}"/>
        <%break;
    case 6:%>
    <h4>query 2.4</h4>
    <p>table displays all patients who were <b>admitted</b> between:</p>
    <c:out value="${startDate} & ${endDate}"/>
        <%break;
    case 7:%>
    <h4>query 2.5</h4>
    <p>table displays all admissions for:</p>
    <c:out value="${patientName}"/>
    <p>along with the diagnosis for each admission</p>
        <%break;
    case 8:%>
    <h4>query 2.6</h4>
    <p>table displays all treatments for:</p>
    <c:out value="${patientName}"/>
        <%break;
    case 9:%>
    <h4>query 2.7</h4>
    <p>table displays patients who were admitted to the hospital within <b>30 days</b> of their last discharge date</p>
        <%break;
    case 10:%>
    <h4>query 2.8</h4>
    <p>table displays total number of admissions, average duration of each admission, longest span between admissions,
    shortest span between admissions, & average span between admissions for each patient</p>
        <%break;
    case 11:%>
    <h4>query 3.1</h4>
    <p>table displays the <b>diagnoses</b> given to patients</p>
        <%break;
    case 12:%>
    <h4>query 3.2</h4>
    <p>table displays the <b>diagnoses</b> given to patients <B>currently</B> in the hospital</p>
        <%break;
    case 13:%>
    <h4>query 3.3</h4>
    <p>table displays the <b>treatments</b> performed on patients</p>
        <%break;
    case 14:%>
    <h4>query 3.4</h4>
    <p>table displays the <b>diagnoses</b> associated with patients who have the highest occurrences of admissions</p>
        <%break;
    case 15:%>
    <h4>query 3.5</h4>
    <p>table displays the patient & doctor for treatment ID:</p>
    <c:out value="${treatment}"/>
        <%break;
    case 16:%>
    <h4>query 4.1</h4>
    <p>table displays all <b>employees</b></p>
        <%break;
    case 17:%>
    <h4>query 4.2</h4>
    <p>table displays primary doctors of patients with <b>high admission rates</b></p>
        <%break;
    case 18:%>
    <h4>query 4.3</h4>
    <p>table displays all <b>diagnoses</b> given by:</p>
    <c:out value="${employeeName}"/>
        <%break;
    case 19:%>
    <h4>query 4.4</h4>
    <p>table displays all <b>treatments</b> order & given by:</p>
    <c:out value="${employeeName}"/>
        <%break;
    case 20:%>
    <h4>query 4.5</h4>
    <p>table displays employees who have been involved in treating every patient</p>
        <%break;
}%>
</div>
<BR><BR>
<table class="query-table">
    <thead>
    <tr>
    <%for (int t = 0; t < headers.size(); t++)  {
        String titleAdd = headers.get(t);
        pageContext.setAttribute("headers", titleAdd);%>
        <th><c:out value="${headers}"/> </th>
    <%}%>
    </tr>
    </thead>
    <%for (int i = 0; i < list.size(); i += columnSize) {
        String firstAdd = list.get(i);
        pageContext.setAttribute("add", firstAdd);%>
        <tr>
            <th><c:out value="${add}"/></th>
        <%for (int j = i+1; j < i + columnSize; j++ ){
            String moreAdd = list.get(j);
            pageContext.setAttribute("more", moreAdd);%>
            <th><c:out value="${more}"/></th>
        <%}%>
    <%}%>
</table>
<form action ="index.jsp" method="get" id="home">
    <input type="submit" id="go" value="return to home page"/>
</form>
</body>

</html>
