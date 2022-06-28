<!DOCTYPE html>
<%--
  Created by IntelliJ IDEA.
  User: Admin
  Date: Jan 2 2022
  Time: 13:53
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Available Listings</title>
    <link rel="icon" href="${pageContext.request.contextPath}/images/icon.png">
    <link rel="stylesheet" href="../src/main/webapp/assets/style.scss"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">

    <script src='https://kit.fontawesome.com/a076d05399.js' crossorigin='anonymous'></script>
    <script src="../src/main/webapp/assets/index.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <%--<link rel="stylesheet" href="assets/bootstrap_4.5.2.css">--%>

    <!-- Bootstrap CSS -->
    <!-- Inform modern browsers that this page supports both dark and light color schemes,
      and the page author prefers light. -->
    <meta name="color-scheme" content="light dark">
    <!-- Load the alternate CSS first ... -->
    <link id="css-dark" rel="stylesheet" href="../src/main/webapp/assets/bootstrap-night.css" media="(prefers-color-scheme: dark)">
    <!-- ... and then the primary CSS last for a fallback on very old browsers that don't support media filtering -->
    <link id="css-light" rel="stylesheet" href="../src/main/webapp/assets/bootstrap_4.5.2.css"
          media="(prefers-color-scheme: no-preference), (prefers-color-scheme: light)">
</head>
<body>
<div class="container">
    <%!
        int toInteger(String str) {
            int convrtr = 0;
            if (str == null) {
                str = "0";
            } else if ((str.trim()).equals("null")) {
                str = "0";
            } else if (str.equals("")) {
                str = "0";
            }
            try {
                convrtr = Integer.parseInt(str);
            } catch (Exception e) {
                e.printStackTrace();
            }
            return convrtr;
        }
    %>
    <%
        Connection con = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/world", "root", "");

            ResultSet rsPgin;
            ResultSet rsRwCn;
            PreparedStatement psPgintn;
            PreparedStatement psRwCn;

            // Number of records displayed on each page
            int iSwRws = 15;
            // Number of pages index displayed
            int iTotSrhRcrds = 10;

            int iTotRslts = toInteger(request.getParameter("iTotRslts"));
            int iTotPags = toInteger(request.getParameter("iTotPags"));
            int iPagNo = toInteger(request.getParameter("iPagNo"));
            int cPagNo = toInteger(request.getParameter("cPagNo"));

            int iStRsNo = 0;
            int iEnRsNo = 0;

            if (iPagNo != 0) {
                iPagNo = Math.abs((iPagNo - 1) * iSwRws);
            }
            String sqlPgintn = "SELECT SQL_CALC_FOUND_ROWS * FROM city limit " + iPagNo + "," + iSwRws + "";
            psPgintn = con.prepareStatement(sqlPgintn);
            rsPgin = psPgintn.executeQuery();
            // Count total number of fetched rows
            String sqlRwCnt = "SELECT FOUND_ROWS() as cnt";
            psRwCn = con.prepareStatement(sqlRwCnt);
            rsRwCn = psRwCn.executeQuery();

            if (rsRwCn.next()) {
                iTotRslts = rsRwCn.getInt("cnt");
            }
    %>

    <div class="container">
        <form name="frm">
            <h2 class="font-weight-lighter">City records</h2>
            <input type="hidden" name="iPagNo" value="<%=iPagNo%>">
            <input type="hidden" name="cPagNo" value="<%=cPagNo%>">
            <input type="hidden" name="iSwRws" value="<%=iSwRws%>">
            <div class='table-responsive'>
                <table class="table table-striped table-hover">
                    <th>ID</th>
                    <th>Name</th>
                    <th>Country Code</th>
                    <th>District</th>
                    <th>Population</th>
                    <%
                        while (rsPgin.next()) {
                    %>
                    <tr>
                        <td>
                            <%=rsPgin.getString("ID") %><br>
                        </td>
                        <td>
                            <%=rsPgin.getString("Name") %><br>
                        </td>
                        <td>
                            <%=rsPgin.getString("CountryCode") %><br>
                        </td>
                        <td>
                            <%=rsPgin.getString("District") %><br>
                        </td>
                        <td>
                            <%=rsPgin.getString("Population") %><br>
                        </td>

                    </tr>
                    <%
                        }

                        // Calculate next record start and end position
                        try {
                            iEnRsNo = Math.min(iTotRslts, (iPagNo + iSwRws));

                            iStRsNo = (iPagNo + 1);
                            iTotPags = ((int) (Math.ceil((double) iTotRslts / iSwRws)));
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    %>
                </table>
            </div>
            <div class="text-right">
                <ul class="pagination justify-content-end"><p style="margin-right: 1em"><b>Page</b></p>
                    <%
                        // Create index of pages
                        int i = 0;
                        int cPge = 0;
                        if (iTotRslts != 0) {
                            cPge = ((int) (Math.ceil((double) iEnRsNo / (iTotSrhRcrds * iSwRws))));
                            int prePageNo = (cPge * iTotSrhRcrds) - ((iTotSrhRcrds - 1) + iTotSrhRcrds);
                            if ((cPge * iTotSrhRcrds) - (iTotSrhRcrds) > 0) {
                    %>
                    <li class="page-item">
                        <a class="page-link"
                           href="records.jsp?iPagNo=<%=prePageNo%>&cPagNo=<%=prePageNo%>"><<
                            Previous</a></li>
                    <%
                        }
                        for (i = ((cPge * iTotSrhRcrds) - (iTotSrhRcrds - 1)); i <= (cPge * iTotSrhRcrds); i++) {
                            if (i == ((iPagNo / iSwRws) + 1)) {
                    %>
                    <li class="page-item active"><a class="page-link"
                                                    href="records.jsp?iPagNo=<%=i%>"><b><%=i%>
                    </b></a></li>

                    <%
                    } else if (i <= iTotPags) {
                    %>
                    <li class="page-item"><a class="page-link" href="records.jsp?iPagNo=<%=i%>"><%=i%>
                    </a></li>
                    <%
                            }
                        }
                        if (iTotPags > iTotSrhRcrds && i < iTotPags) {
                    %>
                    <li class="page-item"><a class="page-link"
                                             href="records.jsp?iPagNo=<%=i%>&cPagNo=<%=i%>">>>
                        Next</a></li>
                    <%
                            }
                        }
                    %><br>
                </ul>
                <div><b>Rows <%=iStRsNo%> - <%=iEnRsNo%> <br>Total Results:  <%=iTotRslts%>
                </b></div>
            </div>
        </form>
    </div>
    <%
            try {
                psPgintn.close();
                rsPgin.close();
                psRwCn.close();
                rsRwCn.close();
                con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (con != null && !con.isClosed()) {
                    con.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    %>

</div>
</body>
</html>
