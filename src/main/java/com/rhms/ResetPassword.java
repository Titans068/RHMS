package com.rhms;

import org.apache.commons.validator.routines.EmailValidator;

import javax.mail.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Arrays;
import java.util.Objects;

@WebServlet(name = "ResetPassword", value = "/ResetPassword")
public class ResetPassword extends HttpServlet {
    PrintWriter out;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        out = response.getWriter();
        String newPassword1 = request.getParameter("newPassword1"),
                newPassword2 = request.getParameter("newPassword2"),
                getPass, email = String.valueOf(request.getSession().getAttribute("email"));

        try {
            if (EmailValidator.getInstance().isValid(email)) {
                getPass = RHMSDAO.getPasswd(email);
                //System.out.println(getPass);
                if (newPassword1.equals(newPassword2)) {
                    if (getPass != null) {
                        if (Objects.equals(Objects.requireNonNull(RHMSDAO.login(email, getPass, true))[0], email)) {
                            int updateCount = RHMSDAO.update(email, RHMSDAO.encrypt(getPass), RHMSDAO.encrypt(newPassword2), true);
                            if (updateCount > 0) {
                                request.setAttribute("msg", "<div class='alert alert-success'><strong>Success!</strong> Successful password reset. Now login with the new credentials.</div>");
                                request.getRequestDispatcher("login.jsp").forward(request, response);
                                return;
                            } else if (updateCount == 0) {
                                request.setAttribute("msg", "<div class='alert alert-danger'>No such user exists to be modified.</div>");
                            } else if (updateCount == -1) {
                                request.setAttribute("msg", "<div class='alert alert-danger'>Something went wrong during your password reset. Please try again later.</div>");
                            }
                        } else request.setAttribute("msg", "<div class='alert alert-danger'>Invalid password.</div>");
                    } else
                        request.setAttribute("msg", "<div class='alert alert-danger'>No such user exists with provided credentials.</div>");
                } else request.setAttribute("msg", "<div class='alert alert-danger'>Passwords do not match.</div>");
            } else request.setAttribute("msg",
                    "<div class='alert alert-danger'>The provided email address is invalid.</div>");
            request.getRequestDispatcher("resetPassword.jsp").forward(request, response);
        } catch (Exception e) {
            out.println(Arrays.toString(e.getStackTrace()));
            e.printStackTrace();
            if (e instanceof MessagingException) return;
        }
    }
}
