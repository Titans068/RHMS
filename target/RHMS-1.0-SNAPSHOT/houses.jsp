<%@ page import="com.rhms.Restrict" %><%--
  Created by IntelliJ IDEA.
  User: Admin
  Date: Dec 13 2021
  Time: 19:11
  To change this template use File | Settings | File Templates.
--%>
<!DOCTYPE html>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<c:set var="username" scope="session" value="${pageContext.session.getAttribute('username')}"/>
<html>
<head>
    <title>Available Listings</title>
    <link rel="icon" href="${pageContext.request.contextPath}/images/icon.png">
    <link rel="stylesheet" href="assets/style.scss"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
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
<nav class="navbar navbar-expand-md navbar-light bg-light fixed-top" id="navbar">
    <a class="navbar-brand" id="brand" href="home.jsp">RENTAL HOUSE MANAGEMENT SYSTEM</a>
    <button type="button" class="navbar-toggler bg-light" data-toggle="collapse" data-target="#nav">
        <span class="navbar-toggler-icon"></span>
    </button>
    <!--Left-->
    <div class="collapse navbar-collapse justify-content-between" id="nav">
        <ul class="navbar-nav ml-auto">
            <li class="nav-item">
                <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#myModal" id="searchBtn">
                    <i class="material-icons md-search"></i>
                </button>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="home.jsp">Home</a>
            </li>
            <c:if test="${username != null}">
                <li class="nav-item">
                    <a class="nav-link" href="addHouse.jsp">Add a Listing</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="houses.jsp">Available Listings</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="myHouses.jsp">My Listings</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="update.jsp">Make Changes</a>
                </li>
            </c:if>
            <li class="nav-item dropdown" data-toggle="dropdown">
                <a class="nav-link font-weight-bold px-3 dropdown-toggle"
                   href="#">
                    <c:choose>
                        <c:when test="${username != null}">
                            <c:out value="${username} "/>
                        </c:when>
                        <c:otherwise>
                            <c:out value="GUEST"/>
                            <%--TODO:<meta http-equiv="refresh" content="0;url=home.jsp">--%>
                        </c:otherwise>
                    </c:choose>
                </a>
                <div class="dropdown-menu">
                    <c:choose>
                        <c:when test="${username != null}">
                            <a class="dropdown-item" id="logout"
                               href="${pageContext.request.contextPath}/LogOut">Log
                                out</a>
                        </c:when>
                        <c:otherwise>
                            <a class="dropdown-item" id="login" href="login.jsp">Login</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </li>
        </ul>
    </div>
</nav>

<div class="container">
    <h2 class="font-weight-light">View Listings</h2>
    <sql:setDataSource var="base" url="jdbc:mysql://localhost:3306/projects"
                       user="root" driver="com.mysql.cj.jdbc.Driver" password=""/>
    <sql:query var="rent" dataSource="${base}"
               sql="SELECT max(rent) FROM houses WHERE state <> 'Sold';"/>
    <sql:query var="locations" dataSource="${base}"
               sql="SELECT DISTINCT location FROM houses WHERE state <> 'Sold';"/>
    <form class="form-inline">
        <label class="mb-2 mr-sm-2" for="min_rent">Rent:</label>
        <input class="form-control mb-2 mr-sm-2" type="number" id="min_rent" name="min_rent"
               value="${param.min_rent != null ? param.min_rent : 0}" min="0"/>
        <label class="mb-2 mr-sm-2" for="max_rent">to</label>
        <input class="form-control mb-2 mr-sm-2" type="number" id="max_rent" name="max_rent"
               value="${param.max_rent != null ? param.max_rent : rent.rowsByIndex[0][0]}"
               max="${rent.rowsByIndex[0][0]}"/>
        <label class="mb-2 mr-sm-2" for="location">Location:</label>
        <select class="form-control mb-2 mr-sm-2" name="location" id="location">
            <option value="All" ${param.location == 'All' ? 'selected' : ''}>All</option>
            <c:forEach var="locate" items="${locations.rows}">
                <option value="${locate.location}" ${param.location == locate.location ? 'selected' : ''}>${locate.location}</option>
            </c:forEach>
        </select>
        <input class="btn btn-primary mb-2" type="submit" name="submit" value="Filter"/>
    </form>
    <c:choose>
        <c:when test="${param.submit != null}">
            <%
                Restrict.setRestrict(Restrict.FILTER);
                Restrict.setSubRestrict(Restrict.USERS);
            %>
        </c:when>
        <c:otherwise>
            <%
                Object username = session.getAttribute("username");
                Restrict.setRestrict(username != null ?
                        (username.toString().equals("administrator")) || (username.toString().equals("admin")) ?
                                Restrict.ADMIN : Restrict.USERS : Restrict.GUEST);
            %>
        </c:otherwise>
    </c:choose>
    <jsp:include page="/Houses"/>
    <div id="myImageModal" class="imageModal">
        <span class="closable">&times;</span>
        <img class="imageModal-content" id="image01">
        <div id="caption01"></div>
    </div>
</div>

<footer class="bg-dark py-4 mt-auto">
    <div class="container px-5">
        <div class="row align-items-center justify-content-between flex-column flex-sm-row">
            <input type="checkbox" id="css-toggle-btn">
            <label id="toggle-lbl" for="css-toggle-btn">
                <div id="star">
                    <div class="star" id="star-1">★</div>
                    <div class="star" id="star-2">★</div>
                </div>
                <div id="moon"></div>
            </label>
            <div class="col-auto">
                <div class="small m-0 text-white">Copyright © 2019 - 2022. ALL RIGHTS RESERVED. | MARK MWIRIGI.</div>
            </div>
            <%--<div class="col-auto">
                <a class="link-light small" href="#!">Privacy</a>
                <span class="text-white mx-1">·</span>
                <a class="link-light small" href="#!">Terms</a>
                <span class="text-white mx-1">·</span>
                <a class="link-light small" href="#!">Contact</a>
            </div>--%>
        </div>
    </div>
</footer>

<%-- The Modal --%>
<div class="modal fade" id="myModal">
    <div class="modal-dialog modal-xl modal-dialog-scrollable modal-dialog-centered">
        <div class="modal-content">
            <%-- Modal Header --%>
            <div class="modal-header">
                <h4 class="modal-title font-weight-light">Search listings</h4>
                <button type="button" class="close" data-dismiss="modal">×</button>
            </div>
            <%-- Modal body --%>
            <div class="modal-body">
                <iframe src="search.jsp"></iframe>
            </div>
            <%-- Modal footer
            <div class="modal-footer">
                <button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
            </div> --%>
        </div>
    </div>
</div>
<script src="assets/index.js"></script>

</body>
<script>
    recordUtils();
    window.addEventListener("resize", onLoad);
    window.addEventListener("load", onLoad);
    darkTheme();
    $(document).ready(setTheme);
    fixLinkBugs();
    document.addEventListener("keypress", search);
</script>
</html>
