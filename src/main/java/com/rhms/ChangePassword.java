package com.rhms;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Arrays;
import java.util.Objects;

@WebServlet(name = "ChangePassword", value = "/ChangePassword")
public class ChangePassword extends HttpServlet {
    PrintWriter out;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        out = response.getWriter();
        try {
            String username = (String) request.getSession().getAttribute("username"),
                    oldPassword, newPassword1, newPassword2, alterAs;
            oldPassword = request.getParameter("oldPassword");
            newPassword1 = request.getParameter("newPassword1");
            newPassword2 = request.getParameter("newPassword2");
            alterAs = request.getParameter("alterAs");
            if (newPassword1.equals(newPassword2)) {
                String user = (username.equalsIgnoreCase("admin") ||
                        username.equalsIgnoreCase("administrator")) ? alterAs : username;
                String actPswd = Objects.requireNonNull(RHMSDAO.login(user, oldPassword,false))[1];
                if (actPswd != null) {
                    if (actPswd.equals(RHMSDAO.encrypt(newPassword1)) || actPswd.equals(RHMSDAO.encrypt(newPassword2))) {
                        request.setAttribute("msg", "<div class='alert alert-danger'>Old password matches new password.</div>");
                    } else if (actPswd.equals(RHMSDAO.encrypt(oldPassword))) {
                        int updateCount = RHMSDAO.update(user, RHMSDAO.encrypt(oldPassword),
                                RHMSDAO.encrypt(newPassword2),false);
                        if (updateCount > 0) {
                            request.setAttribute("msg", "<div class='alert alert-success'><strong>Success!</strong> Successful password change.</div>");
                        } else if (updateCount == 0) {
                            request.setAttribute("msg", "<div class='alert alert-danger'>No such user exists to be modified.</div>");
                        } else if (updateCount == -1) {
                            request.setAttribute("msg", "<div class='alert alert-danger'>Something went wrong while changing your password. Please try again later.</div>");
                        }
                    }
                } else {
                    request.setAttribute("msg", "<div class='alert alert-danger'>Invalid password.</div>");
                }
            } else {
                request.setAttribute("msg", "<div class='alert alert-danger'>Passwords do not match.</div>");
            }
            request.getRequestDispatcher("update.jsp").forward(request, response);
        } catch (Exception e) {
            out.println(Arrays.toString(e.getStackTrace()));
            e.printStackTrace();
        }
    }
}
