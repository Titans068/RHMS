<%@ page import="com.rhms.Restrict" %><%--
  Created by IntelliJ IDEA.
  User: Admin
  Date: Dec 14 2021
  Time: 16:08
  To change this template use File | Settings | File Templates.
--%>
<!DOCTYPE html>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <link rel="stylesheet" href="assets/style.scss"/>
    <link rel="stylesheet" href="https://material-icons.github.io/material-icons-font/css/all.css">

    <script src='https://kit.fontawesome.com/a076d05399.js' crossorigin='anonymous'></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <!-- Bootstrap CSS -->
    <!-- Inform modern browsers that this page supports both dark and light color schemes,
      and the page author prefers light. -->
    <meta name="color-scheme" content="light dark">
    <!-- Load the alternate CSS first ... -->
    <link id="css-dark" rel="stylesheet" href="assets/bootstrap-night.css" media="(prefers-color-scheme: dark)">
    <!-- ... and then the primary CSS last for a fallback on very old browsers that don't support media filtering -->
    <link id="css-light" rel="stylesheet" href="assets/bootstrap_4.5.2.css"
          media="(prefers-color-scheme: no-preference), (prefers-color-scheme: light)">
</head>
<body class="d-flex flex-column min-vh-100">
<div class="container-fluid">
    <sql:setDataSource var="base" url="jdbc:mysql://localhost:3306/projects"
                       user="root" driver="com.mysql.cj.jdbc.Driver" password=""/>
    <sql:query var="rent" dataSource="${base}"
               sql="SELECT max(rent) FROM houses WHERE state <> 'Sold';"/>
    <sql:query var="locations" dataSource="${base}"
               sql="SELECT DISTINCT location FROM houses WHERE state <> 'Sold';"/>
    <form class="form-inline" name="search" action="search.jsp">
        <input class="form-control justify-content-center mr-sm-2 w-75"
               type="search" placeholder="Search" id="searchTerm" name="searchTerm"
               value="${(param.searchTerm != null) ? param.searchTerm : null}" required>
        <button class="btn btn-primary" type="submit" name="searchSubmit" id="searchSubmit" style="padding: .6em">
            <i class="material-icons md-search"></i>
        </button>
        <div class="form-group" id="filters">
            <label class="mb-2 mr-sm-2" for="min_rent">Rent:</label>
            <input class="form-control mb-2 mr-sm-2" type="number" id="min_rent" name="min_rent"
                   value="${param.min_rent != null ? param.min_rent : 0}" min="0" required/>
            <label class="mb-2 mr-sm-2" for="max_rent">to</label>
            <input class="form-control mb-2 mr-sm-2" type="number" id="max_rent" name="max_rent"
                   value="${param.max_rent != null ? param.max_rent : rent.rowsByIndex[0][0]}"
                   max="${rent.rowsByIndex[0][0]}" required/>
            <label class="mb-2 mr-sm-2" for="location">Location:</label>
            <select class="form-control mb-2 mr-sm-2" name="location" id="location">
                <option value="All" ${param.location == 'All' ? 'selected' : ''}>All</option>
                <c:forEach var="locate" items="${locations.rows}">
                    <option value="${locate.location}" ${param.location == "${locate.location}" ? 'selected' : ''}>${locate.location}</option>
                </c:forEach>
            </select>
            <input class="btn btn-primary mb-2" type="submit" name="submit" value="Filter"/>
        </div>
    </form>
    <c:choose>
        <c:when test="${param.submit != null}">
            <%
                Restrict.setRestrict(Restrict.FILTER);
                Restrict.setSubRestrict(Restrict.SEARCH);
            %>
            <jsp:include page="/Houses"/>
        </c:when>
        <c:when test="${param.searchSubmit != null}">
            <%
                Restrict.setRestrict(Restrict.SEARCH);
            %>
            <jsp:include page="/Houses"/>
        </c:when>
    </c:choose>
    <div id="myImageModal" class="imageModal">
        <span class="closable">&times;</span>
        <img class="imageModal-content" id="image01">
        <div id="caption01"></div>
    </div>
</div>
<!-- The Modal -->
<div class="modal fade" id="myModal">
    <div class="modal-dialog modal-xl modal-dialog-scrollable modal-dialog-centered">
        <div class="modal-content">
            <!-- Modal Header -->
            <div class="modal-header">
                <h4 class="modal-title font-weight-light">Search listings</h4>
                <button type="button" class="close" data-dismiss="modal">×</button>
            </div>
            <!-- Modal body -->
            <div class="modal-body">
                <iframe src="search.jsp"></iframe>
            </div>
            <!-- Modal footer
            <div class="modal-footer">
                <button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
            </div> -->
        </div>
    </div>
</div>
<input type="checkbox" id="css-toggle-btn">
<script src="assets/index.js"></script>
</body>
<script>
    recordUtils();
    darkTheme();
    $(document).ready(setTheme);
    document.addEventListener("DOMContentLoaded", function () {
        let searchTerm = document.forms["search"]["searchTerm"].value.trim();
        document.getElementById("filters").style.display =
            searchTerm === "" ? "none" : "inline-flex";
    });
    document.addEventListener("keypress", event => {
        if (event.code === "Slash") {
            event.preventDefault();
        }
        document.getElementById("searchTerm").focus();
    });
    document.addEventListener("keypress", search);
    if ((localStorage.getItem("theme") === "light" &&
            (window.matchMedia && window.matchMedia("(prefers-color-scheme: dark)").matches)) ||
        (localStorage.getItem("theme") === "dark" &&
            !(window.matchMedia && window.matchMedia("(prefers-color-scheme: dark)").matches)))
        document.getElementById("css-toggle-btn").click();
</script>
</html>
