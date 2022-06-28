<%--
  Created by IntelliJ IDEA.
  User: Admin
  Date: Dec 12 2021
  Time: 19:23
  To change this template use File | Settings | File Templates.
--%>
<!DOCTYPE html>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<c:set var="username" scope="session" value="${pageContext.session.getAttribute('username')}"/>
<c:set var="msg" value="${pageContext.request.getAttribute('msg')}"/>
<html>
<head>
    <title>Make Changes</title>
    <link rel="icon" href="${pageContext.request.contextPath}/images/icon.png">
    <link rel="stylesheet" href="assets/style.scss"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <link rel="stylesheet" href="https://material-icons.github.io/material-icons-font/css/all.css">

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
            <li class="nav-item">
                <a class="nav-link" href="houses.jsp">Available Listings</a>
            </li>
            <c:if test="${username != null}">
                <li class="nav-item">
                    <a class="nav-link" href="addHouse.jsp">Add a Listing</a>
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
                            <a class="dropdown-item" id="logout" href="${pageContext.request.contextPath}/LogOut">Log
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
    <c:if test="${msg != null}">
        <c:out value="${msg}" escapeXml="false"/>
    </c:if>
    <div class="row">
        <div class="col-sm">
            <form method="post" action="UpdateHouse">
                <h2 class="miniForm-heading font-weight-light">Update a Listing</h2>
                <label for="houseNumber">House Number</label>
                <input class="form-control" id="houseNumber" name="houseNumber"
                       placeholder="House number." required/>
                <label for="rent">Rent</label>
                <input class="form-control" id="rent" name="rent" type="number" required>
                <label for="state">State</label>
                <select id="state" name="state" class="form-control" required>
                    <option value="">--Select state--</option>
                    <option value="Open">Open</option>
                    <option value="Processing">Processing</option>
                    <option value="Sold">Sold</option>
                </select>
                <c:if test="${username.equalsIgnoreCase('admin') || username.equalsIgnoreCase('administrator')}">
                    <label for="updateAs">Modify record as</label>
                    <input class="form-control" id="updateAs" name="updateAs" placeholder="User to update record as."
                           required>
                </c:if>
                <br>
                <input type="submit" name="updateSubmit" class="btn btn-primary" id="updateSubmit" value="Submit"/>
            </form>
        </div>

        <div class="col-sm">
            <form id="DeleteHouse" action="DeleteHouse" method="post"
                  onsubmit="return confirm('Are you sure you want to delete this record?')">
                <h2 class="miniForm-heading font-weight-light">Delete Listing</h2>
                <label for="houseNumberToDelete">House Number</label>
                <input class="form-control" id="houseNumberToDelete" name="houseNumberToDelete"
                       placeholder="House number to delete." required/>
                <c:if test="${username.equalsIgnoreCase('admin') || username.equalsIgnoreCase('administrator')}">
                    <label for="deleteAs">Delete record as</label>
                    <input class="form-control" id="deleteAs" name="deleteAs"
                           placeholder="User to delete record as." required>
                    <br>
                </c:if>
                <br>
                <input type="submit" name="deleteSubmit" class="btn btn-primary" id="deleteSubmit" value="Submit"/>
            </form>
        </div>
    </div>

    <div class="row">
        <div class="col-sm">
            <form action="ChangePassword" method="post"
                  onsubmit="return confirm('Are you sure you want to change your password?')">
                <h2 class="miniForm-heading font-weight-light">Alter Password</h2>
                <label for="oldPassword">Current Password</label>
                <input class="form-control" name="oldPassword" id="oldPassword" type="password" required/>
                <label for="newPassword1">New Password</label>
                <input class="form-control" name="newPassword1" id="newPassword1" type="password" required/>
                <label for="newPassword2">Retype New Password</label>
                <input class="form-control" name="newPassword2" id="newPassword2" type="password" required/>
                <c:if test="${username.equalsIgnoreCase('admin') || username.equalsIgnoreCase('administrator')}">
                    <label for="alterAs">Alter password as</label>
                    <input class="form-control" name="alterAs" id="alterAs"
                           placeholder="User to alter password as." required>
                    <br>
                </c:if>
                <br>
                <input type="submit" name="passwordSubmit" class="btn btn-primary" id="passwordSubmit" value="Submit"/>
            </form>
        </div>

        <c:if test="${username.equalsIgnoreCase('admin') || username.equalsIgnoreCase('administrator')}">
            <div class="col-sm">
                <form action="DeleteUser" method="post"
                      onsubmit="return confirm('Are you sure you want to delete this record?')">
                    <h2 class="miniForm-heading font-weight-light">Delete User</h2>
                    <label for="deleteUser">Username</label>
                    <input class="form-control" id="deleteUser" name="deleteUser"
                           placeholder="Enter username to delete." required/>
                    <br>
                    <input type="submit" name="userDelete" class="btn btn-primary" id="userDelete" value="Submit"/>
                </form>
            </div>
        </c:if>
    </div>
</div>

<footer class="bg-dark py-4 mt-auto">
    <div class="container px-5">
        <div class="row align-items-center justify-content-between flex-column flex-sm-row"
             style="margin-left: -1.5em;">
            <input type="checkbox" id="css-toggle-btn">
            <label id="toggle-lbl" for="css-toggle-btn" style="margin-left: 0.55em;">
                <div id="star">
                    <div class="star" id="star-1">★</div>
                    <div class="star" id="star-2">★</div>
                </div>
                <div id="moon"></div>
            </label>
            <div class="col-auto">
                <div class="small m-0 text-white">Copyright © 2019 - 2022. ALL RIGHTS RESERVED. | MARK MWIRIGI.</div>
            </div>
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
    fixLinkBugs();
    const tooltipTxt = "States indicate the stages of the house's rental procedure." +
        " Open state means that the house is currently unoccupied and ready for renting. " +
        "Processing state means that the house has a potential renter and processes are taking" +
        " place for the house to be fully occupied. Sold means that the rental procedure is " +
        "complete and the house already has an occupant. Records of occupied houses are not publicly displayed.";

    $('#state').tooltip({
        placement: 'top',
        trigger: 'focus',
        container: 'body',
        title: tooltipTxt,
        width: 'auto',
        display: 'table'
    });
    document.addEventListener("keypress", search);
</script>

</html>
