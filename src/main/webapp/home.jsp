<%--
  Created by IntelliJ IDEA.
  User: Admin
  Date: Dec 14 2021
  Time: 17:07
  To change this template use File | Settings | File Templates.
--%>
<!DOCTYPE html>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<c:set var="username" scope="session" value="${pageContext.session.getAttribute('username')}"/>
<html>
<head>
    <title>Rental House Management System</title>
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
<header class="bg-dark py-5">
    <div class="container px-5">
        <div class="row gx-5 align-items-center justify-content-center">
            <div class="col-lg-8 col-xl-7 col-xxl-6">
                <div class="my-5 text-center text-xl-start">
                    <h1 class="display-5 fw-bolder text-white mb-2">FIND YOUR NEW HOME</h1>
                    <p class="lead fw-normal text-white-50 mb-4">Welcome to the Rental House Management System, a new,
                        free hub where fully established rental agencies or individual agents
                        can freely advertise their houses. Potential clients can then choose their new house according
                        to their needs, tastes, budget
                        and convenience. Renters and agencies are free to list as many houses as they want so long as
                        they are registered.</p>
                    <div class="d-grid gap-3 d-sm-flex justify-content-sm-center justify-content-xl-start">
                        <a class="btn btn-primary btn-lg px-4 me-sm-3"
                           href="${username != null ? "addHouse.jsp" : "login.jsp"}">Get Started</a>
                    </div>
                </div>
            </div>
            <div class="col-xl-5 col-xxl-6 d-none d-xl-block text-center">
                <img class="img-fluid rounded-3 my-5" src="${pageContext.request.contextPath}/images/pic03.jpg">
            </div>
        </div>
    </div>
</header>

<section class="py-5" id="features">
    <div class="container px-5 my-5">
        <div class="row gx-5">
            <div class="col-lg-4 mb-5 mb-lg-0"><h2 class="fw-bolder mb-0">Your new home is just a click away.</h2></div>
            <div class="col-lg-8">
                <div class="row gx-5 row-cols-1 row-cols-md-2">
                    <div class="col mb-5 h-100">
                        <div class="feature bg-primary bg-gradient text-white rounded-3 mb-3"><i
                                class="bi bi-collection"></i></div>
                        <h2 class="h5">The Struggle is over.</h2>
                        <p class="mb-0">Find a new home stress-free.</p>
                    </div>
                    <div class="col mb-5 h-100">
                        <div class="feature bg-primary bg-gradient text-white rounded-3 mb-3"><i
                                class="bi bi-building"></i></div>
                        <h2 class="h5">Easy Search</h2>
                        <p class="mb-0">You only need to ask. Start by pressing the <kbd>/</kbd> key.</p>
                    </div>
                    <div class="col mb-5 mb-md-0 h-100">
                        <div class="feature bg-primary bg-gradient text-white rounded-3 mb-3"><i
                                class="bi bi-toggles2"></i></div>
                        <h2 class="h5">Efficiency</h2>
                        <p class="mb-0">Listing your house has never been easier.</p>
                    </div>
                    <div class="col h-100">
                        <div class="feature bg-primary bg-gradient text-white rounded-3 mb-3"><i
                                class="bi bi-toggles2"></i></div>
                        <h2 class="h5">You are covered</h2>
                        <p class="mb-0">Get spoilt for choice with our variety.</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<div class="py-5 bg-light">
    <div class="container px-5 my-5">
        <div class="row gx-5 justify-content-center">
            <div class="col-lg-10 col-xl-7">
                <div class="text-center">
                    <div class="fs-4 mb-4 fst-italic">"Why spend fortunes on marketing expenses? There's something for
                        everyone.
                        Renting my house has become so cheap and easy."
                    </div>
                    <div class="d-flex align-items-center justify-content-center">
                        <%--<img class="rounded-circle me-3" src="https://dummyimage.com/40x40/ced4da/6c757d" alt="...">--%>
                        <div class="fw-bold">
                            Satisfied customer
                            <span class="fw-bold text-primary mx-1">/</span>
                            <i class="fa fa-star"></i><i class="fa fa-star"></i><i class="fa fa-star"></i><i
                                class="fa fa-star"></i><i class="fa fa-star"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<sql:setDataSource var="base" url="jdbc:mysql://localhost:3306/projects"
                   user="root" driver="com.mysql.cj.jdbc.Driver" password=""/>
<sql:query var="rs" dataSource="${base}"
           sql="SELECT building, location, rent, houseno, username, image FROM houses WHERE state <> 'Sold' LIMIT 10;"/>
<div id="carousel" class="carousel slide gallery" data-ride="carousel" <%--data-interval="false"--%>>
    <ol class="carousel-indicators">
        <c:forEach items="${rs.rows}" varStatus="dot">
            <li data-target="#carousel" data-slide-to="${dot.index}" ${dot.first ? 'class="active"' : ''}></li>
        </c:forEach>
    </ol>
    <div class="carousel-inner">
        <c:forEach var="column" items="${rs.rows}" varStatus="status">
            <div data-slide-number="${status.index}" data-toggle="lightbox" data-remote="uploadedpics/${column.houseno}"
                 data-gallery="gallery" ${status.first ? 'class="carousel-item active"' : 'class="carousel-item"'}>
                <img src="uploadedpics/${column.houseno}" onerror="this.onerror=null;this.src='images/home(2).png';"
                     alt="${column.building} located in ${column.location} priced at ${column.rent} by ${column.username}"
                     class="d-block w-100">
                <div class="carousel-caption">
                    <h4>${column.building}
                        <br><small>${column.location}</small>
                        <br><small>${column.rent}</small></h4>
                    <p>${column.username}</p>
                </div>
            </div>
        </c:forEach>
    </div>
    <a class="carousel-control-prev" href="#carousel" role="button" data-slide="prev">
        <span class="carousel-control-prev-icon" aria-hidden="true"></span>
        <span class="sr-only">Previous</span>
    </a>
    <a class="carousel-control-next" href="#carousel" role="button" data-slide="next">
        <span class="carousel-control-next-icon" aria-hidden="true"></span>
        <span class="sr-only">Next</span>
    </a>
</div>


<section class="py-5">
    <div class="container px-5 my-5">
        <div class="row gx-5 justify-content-center">
            <div class="col-lg-8 col-xl-6">
                <div class="text-center">
                    <h2 class="fw-bolder">THE LEADING SITE FOR RENTERS</h2>
                    <p class="lead fw-normal text-muted mb-5">A hub for both agencies and clients alike.</p>
                </div>
            </div>
        </div>
        <div class="row gx-5">
            <div class="col-lg-4 mb-5">
                <div class="card h-100 shadow border-0">
                    <img class="card-img-top" src="${pageContext.request.contextPath}/images/pic02.jpg" alt="...">
                    <div class="card-body p-4">
                        <div class="badge bg-primary bg-gradient rounded-pill mb-2">Anywhere. Anytime</div>
                        <a class="text-decoration-none link-dark stretched-link" href="#"><h5 class="card-title mb-3">
                            Convenience</h5></a>
                        <p class="card-text mb-0">Find a home from wherever you are.</p>
                    </div>
                    <%--<div class="card-footer p-4 pt-0 bg-transparent border-top-0">
                        <div class="d-flex align-items-end justify-content-between">
                            <div class="d-flex align-items-center">
                                <img class="rounded-circle me-3" src="https://dummyimage.com/40x40/ced4da/6c757d"
                                     alt="...">
                                <div class="small">
                                    <div class="fw-bold">Kelly Rowan</div>
                                    <div class="text-muted">March 12, 2021 · 6 min read</div>
                                </div>
                            </div>
                        </div>
                    </div>--%>
                </div>
            </div>
            <div class="col-lg-4 mb-5">
                <div class="card h-100 shadow border-0">
                    <img class="card-img-top" src="${pageContext.request.contextPath}/images/pic01.jpg" alt="...">
                    <div class="card-body p-4">
                        <div class="badge bg-primary bg-gradient rounded-pill mb-2">To the rescue</div>
                        <a class="text-decoration-none link-dark stretched-link" href="#"><h5 class="card-title mb-3">
                            Hassle-Free</h5></a>
                        <p class="card-text mb-0">Here to help you not get overwhelmed with selection.</p>
                    </div>
                    <%--<div class="card-footer p-4 pt-0 bg-transparent border-top-0">
                        <div class="d-flex align-items-end justify-content-between">
                            <div class="d-flex align-items-center">
                                <img class="rounded-circle me-3" src="https://dummyimage.com/40x40/ced4da/6c757d"
                                     alt="...">
                                <div class="small">
                                    <div class="fw-bold">Josiah Barclay</div>
                                    <div class="text-muted">March 23, 2021 · 4 min read</div>
                                </div>
                            </div>
                        </div>
                    </div>--%>
                </div>
            </div>
            <div class="col-lg-4 mb-5">
                <div class="card h-100 shadow border-0">
                    <img class="card-img-top" src="${pageContext.request.contextPath}/images/banner1.jpg" alt="...">
                    <div class="card-body p-4">
                        <div class="badge bg-primary bg-gradient rounded-pill mb-2">Satisfaction</div>
                        <a class="text-decoration-none link-dark stretched-link" href="#!"><h5 class="card-title mb-3">
                            Find the house that's perfect for you.</h5></a>
                        <p class="card-text mb-0">No need to make compromises.</p>
                    </div>
                    <%--<div class="card-footer p-4 pt-0 bg-transparent border-top-0">
                        <div class="d-flex align-items-end justify-content-between">
                            <div class="d-flex align-items-center">
                                <img class="rounded-circle me-3" src="https://dummyimage.com/40x40/ced4da/6c757d"
                                     alt="...">
                                <div class="small">
                                    <div class="fw-bold">Evelyn Martinez</div>
                                    <div class="text-muted">April 2, 2021 · 10 min read</div>
                                </div>
                            </div>
                        </div>
                    </div>--%>
                </div>
            </div>
        </div>
        <!-- Call to action-->
        <aside class="bg-primary bg-gradient rounded-3 p-4 p-sm-5 mt-5">
            <div class="d-flex align-items-center justify-content-between flex-column flex-xl-row text-center text-xl-start">
                <div class="mb-4 mb-xl-0">
                    <div class="fs-3 fw-bold">What are you waiting for?</div>
                    <div>Get started today. Your comfort, security and happiness are in your hands.</div>
                </div>
                <div class="ms-xl-4">
                    <div class="input-group mb-2">
                        <%--<input class="form-control" type="text" placeholder="Email address..."
                               aria-label="Email address..." aria-describedby="button-newsletter">--%>
                        <c:choose>
                            <c:when test="${username != null}">
                                <a class="btn btn-outline-light" id="button-newsletter" href="addHouse.jsp">Get
                                    Started</a>
                            </c:when>
                            <c:otherwise>
                                <a class="btn btn-outline-light" id="button-newsletter" href="login.jsp">Get Started</a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="small">We care about privacy, and will never share your data.</div>
                </div>
            </div>
        </aside>
    </div>
</section>

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
    document.addEventListener("keypress", search);
</script>
</html>
