<%--
  Created by IntelliJ IDEA.
  User: Admin
  Date: Jan 28 2022
  Time: 14:23
  To change this template use File | Settings | File Templates.
--%>
<!DOCTYPE html>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<c:set var="username" scope="session" value="${pageContext.session.getAttribute('username')}"/>
<c:set var="gen" value="${pageContext.session.getAttribute('gen')}"/>
<c:set var="msg" value="${pageContext.request.getAttribute('msg')}"/>
<html>
<head>
    <title>Reset Password</title>
    <link rel="icon" href="${pageContext.request.contextPath}/images/icon.png">
    <link rel="stylesheet" href="assets/style.scss"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <link rel="stylesheet" href="https://material-icons.github.io/material-icons-font/css/all.css">
    <link href="assets/bootstrap-responsive.min.css" rel="stylesheet">

    <script src='https://kit.fontawesome.com/a076d05399.js' crossorigin='anonymous'></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
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
                <a class="nav-link font-weight-bold px-3"
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
            </li>
        </ul>
    </div>
</nav>

<div class="container">
    <c:if test="${msg != null}">
        <c:out value="${msg}" escapeXml="false"/>
    </c:if>
    <div id="validate" class="alert alert-danger" style="display: none;"></div>
    <%-- <c:out value="GEN:${gen}<br>TOK:${param.tok}"/> --%>
    <c:choose>
        <c:when test="${param.tok != null && gen != null && param.tok.equals(gen)}">
            <form action="ResetPassword" method="post">
                <h2 class="miniForm-heading font-weight-light">Reset Password.</h2>
                <label for="newPassword1">New Password</label>
                <input class="form-control" name="newPassword1" id="newPassword1" type="password" required/>
                <label for="newPassword2">Retype New Password</label>
                <input class="form-control" name="newPassword2" id="newPassword2" type="password" required/><br>
                <input type="submit" name="submit" class="btn btn-primary" id="submit" value="Submit"/>
            </form>
        </c:when>
        <c:otherwise>
            <form action="AuthEmail" method="post">
                <h2 class="miniForm-heading font-weight-light">Enter your e-mail address.</h2>
                <label for="email">E-mail Address</label>
                <input class="form-control" name="email" id="email" type="email" placeholder="E-mail Address" required/><br>
                <input type="submit" name="submit" class="btn btn-primary" id="emailSubmit" value="Submit"/>
            </form>
        </c:otherwise>
    </c:choose>
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
            <!--<div class="col-auto">
                <a class="link-light small" href="#!">Privacy</a>
                <span class="text-white mx-1">·</span>
                <a class="link-light small" href="#!">Terms</a>
                <span class="text-white mx-1">·</span>
                <a class="link-light small" href="#!">Contact</a>
            </div>-->
        </div>
    </div>
</footer>

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
<script src="assets/index.js"></script>

</body>
<script>
    window.addEventListener("resize", onLoad);
    window.addEventListener("load", onLoad);
    darkTheme();
    $(document).ready(setTheme);
    document.addEventListener("keypress", search);
    document.forms[0].addEventListener("submit", (e) => {
        let email = document.forms[0].elements["email"].value;
        if (!/^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}])|(([a-zA-Z\-\d]+\.)+[a-zA-Z]{2,}))$/
            .test(email)) {
            let validate = document.getElementById("validate");
            validate.style.display = "block";
            validate.innerHTML = "Invalid email address provided.";
            e.preventDefault();
            return false;
        }
    });
</script>
<script src="assets/index.js"></script>

</html>
