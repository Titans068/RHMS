package com.rhms;

import org.apache.commons.validator.routines.EmailValidator;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Arrays;

@WebServlet(name = "Register", value = "/Register")
public class Register extends HttpServlet {
    PrintWriter out;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        out = response.getWriter();
        try {
            String username = request.getParameter("registerUsername");
            String email = request.getParameter("registerEmail");
            String password = request.getParameter("registerPassword");
            if (EmailValidator.getInstance().isValid(email)) {
                if (RHMSDAO.insert(username, email, RHMSDAO.encrypt(password))) {
                    Utils.authenticate(email, null);
                    request.setAttribute("msg",
                            "<div class='alert alert-success'><strong>Success!</strong> Successful registration. Now login with provided credentials.</div>");
                } else
                    request.setAttribute("msg",
                            "<div class='alert alert-danger'>Something went wrong during registration. Perhaps this username is taken. Please try again later.</div>");
            } else request.setAttribute("msg",
                    "<div class='alert alert-danger'>The provided email address is invalid.</div>");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } catch (Exception e) {
            out.println(Arrays.toString(e.getStackTrace()));
            e.printStackTrace();
        }
    }
}
