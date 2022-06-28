package com.rhms;

import org.apache.commons.validator.routines.EmailValidator;
import org.apache.commons.validator.routines.UrlValidator;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import static com.rhms.RHMSDAO.page;

@WebServlet(name = "Houses", value = "/Houses")
public class Houses extends HttpServlet {
    private static final UrlValidator validate = new UrlValidator(new String[]{"http", "https"});
    private PrintWriter out;

    private static String validateLink(String column) {
        return validate.isValid(column) ? String.format("<a href='%s' target='_blank'>Visit</a>", column) :
                String.format("%s<br>", column);
    }

    private static String validateEmail(String column) {
        return EmailValidator.getInstance().isValid(column) ?
                String.format("<a href='mailto:%s' target='_blank'>%s</a>", column, column) : String.format("%s<br>", column);
    }

    private int atoi(String str) {
        int convrtr = 0;
        if (str == null || str.trim().equals("null") || str.equals("")) str = "0";
        try {
            convrtr = Integer.parseInt(str);
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }
        return convrtr;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        out = response.getWriter();
        try {
            // Number of records displayed on each page
            int iSwRws = 10;
            // Number of pages navigable at a time
            int iTotSrhRcrds = 10, iTotRslts,
                    iTotPags, iPagNo = atoi(request.getParameter("iPagNo")),
                    cPagNo = atoi(request.getParameter("cPagNo")),
                    iStRsNo, iEnRsNo;

            if (iPagNo != 0) {
                iPagNo = Math.abs((iPagNo - 1) * iSwRws);
            }
            List<House> select;

            switch (Restrict.getRestrict()) {
                case ME:
                    select = RHMSDAO.select(iPagNo, iSwRws, request.getSession().getAttribute("username").toString());
                    break;
                case SEARCH:
                    select = RHMSDAO.select(iPagNo, iSwRws, request.getParameter("searchTerm"));
                    break;
                case FILTER:
                    select = RHMSDAO.select(iPagNo, iSwRws, String.join("|", request.getParameter("min_rent"),
                            request.getParameter("max_rent"), request.getParameter("location"),
                            request.getSession().getAttribute("username").toString(), request.getParameter("searchTerm")));
                    break;
                default:
                    select = RHMSDAO.select(iPagNo, iSwRws, null);
                    break;
            }
            iTotRslts = RHMSDAO.iTotRslts;

            if (iTotRslts == 0) {
                out.println("<div class='alert alert-danger'>No results matched</div>");
            } else {
                out.printf("<form name='frm'> <input type='hidden' name='iPagNo' value='%d'>" +
                        " <input type='hidden' name='cPagNo' value='%d'> <input type='hidden'" +
                        " name='iSwRws' value='%d'> <div class='card-deck'>%n", iPagNo, cPagNo, iSwRws);
                int k = 0;
                for (House house : select) {
                    out.printf("<div class='card'><img class='myImaging' id='imaging' src='%s' alt='%s<br>%s'\n" +
                                    "                       onError=\"this.onerror=null;this.src='images/home(2).png';\"><br>%n<span class='no-break'><i\n" +
                                    "        class='material-icons md-link'></i>&nbsp;&nbsp;&nbsp;%s</span>%n<span class='no-break'><i\n" +
                                    "        class='fa fa-user-circle'></i>&nbsp;&nbsp;&nbsp;%s</span>%n<span class='no-break'><i\n" +
                                    "        class='fa fa-envelope'></i>&nbsp;&nbsp;&nbsp;%s</span>" +
                                    "<span class='no-break'><i\n" +
                                    "        class='fa fa-building'></i>&nbsp;&nbsp;&nbsp;&nbsp;%s</span>%n<span class='no-break'><i\n" +
                                    "        class='material-icons md-pin_drop'></i>&nbsp;&nbsp;&nbsp;%s</span>%n<span class='no-break'><i\n" +
                                    "        class='material-icons md-attach_money'></i>&nbsp;&nbsp;&nbsp;%s</span>%n<span class='no-break'><i\n" +
                                    "        class='material-icons md-description'></i>&nbsp;&nbsp;&nbsp;%s</span>%n<span class='no-break'><i\n" +
                                    "        class='fa fa-home'></i>&nbsp;&nbsp;&nbsp;&nbsp;%s</span>%n<span class='no-break'><i\n" +
                                    "        class='material-icons md-contact_phone'></i>&nbsp;&nbsp;&nbsp;%s</span>%n<span class='no-break'><i\n" +
                                    "        class='fa fa-list'></i>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;%s</span>%n\n" +
                                    "</div>",
                            house.getImage(), house.getBuilding(), house.getDescr(), validateLink(house.getLink()), house.getUsername(),
                            validateEmail(house.getEmail()), house.getBuilding(), house.getLocation(), house.getRent(), house.getDescr(),
                            house.getHouseNo(), house.getPhoneNumber(), house.getState());
                    k++;
                    if (k % 3 == 0) out.println("</div><br><div class='card-deck'>");
                }
                iEnRsNo = Math.min(iTotRslts, (iPagNo + iSwRws));
                iStRsNo = (iPagNo + 1);
                iTotPags = ((int) (Math.ceil((double) iTotRslts / iSwRws)));
                out.println("</div><div><b>Page</b><ul class='pagination'>");
                int i;
                int cPge = ((int) (Math.ceil((double) iEnRsNo / (iTotSrhRcrds * iSwRws))));
                int prePageNo = (cPge * iTotSrhRcrds) - ((iTotSrhRcrds - 1) + iTotSrhRcrds);
                if ((cPge * iTotSrhRcrds) - (iTotSrhRcrds) > 0) {
                    out.printf("<li class='page-item'><a href='%s?iPagNo=%d&cPagNo=%d' class='page-link'>" +
                            "<< Previous</a></li>%n", page, prePageNo, prePageNo);
                }
                for (i = ((cPge * iTotSrhRcrds) - (iTotSrhRcrds - 1)); i <= (cPge * iTotSrhRcrds); i++) {
                    if (i == ((iPagNo / iSwRws) + 1)) {
                        out.printf("<li class='page-item active'><a href='%s?iPagNo=%d' class='page-link'>" +
                                "<b>%d</b></a></li>%n", page, i, i);
                    } else if (i <= iTotPags) {
                        out.printf("<li class='page-item'><a class='page-link' href='%s?iPagNo=%d'>%d</a><li>%n"
                                , page, i, i);
                    }
                }
                if (iTotPags > iTotSrhRcrds && i < iTotPags) {
                    out.printf("<li class='page-item'><a href='%s?iPagNo=%d&cPagNo=%d' class='page-link'>" +
                            ">> Next</a></li>%n", page, i, i);
                }
                out.printf("</ul><b>Rows %d - %d <br>Total Results:  %d</b></div></div></form>%n",
                        iStRsNo, iEnRsNo, iTotRslts);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
