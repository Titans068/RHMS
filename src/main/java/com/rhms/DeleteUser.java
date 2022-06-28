package com.rhms;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Arrays;

@WebServlet(name = "DeleteUser", value = "/DeleteUser")
public class DeleteUser extends HttpServlet {
    PrintWriter out;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        out = response.getWriter();
        try {
            int deleteCount = RHMSDAO.delete(request.getParameter("deleteUser"));
            if (deleteCount > 0) {
                request.setAttribute("msg", "<div class='alert alert-success'><strong>Success!</strong> Successful user deletion.</div>");
            } else if (deleteCount == 0) {
                request.setAttribute("msg", "<div class='alert alert-danger'>No such user exists to be deleted.</div>");
            } else if (deleteCount == -1) {
                request.setAttribute("msg", "<div class='alert alert-danger'>Something went wrong during deletion of this user. Please try again later.</div>");
            }
            request.getRequestDispatcher("update.jsp").forward(request, response);
        } catch (Exception e) {
            out.println(Arrays.toString(e.getStackTrace()));
            e.printStackTrace();
        }
    }
}
