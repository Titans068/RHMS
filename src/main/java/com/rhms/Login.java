package com.rhms;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;

@WebServlet(name = "Login", value = "/Login")
public class Login extends HttpServlet {
    PrintWriter out;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        out = response.getWriter();
        try {
            if (RHMSDAO.login(request.getParameter("loginUsername"),
                    request.getParameter("loginPassword"),false) != null) {
                request.getSession().setAttribute("username", request.getParameter("loginUsername"));
                request.getRequestDispatcher("home.jsp").forward(request, response);
            } else {
                request.setAttribute("msg", "<div class='alert alert-danger'>Incorrect username or password.</div>");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
