package com.rhms;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Arrays;

@WebServlet(name = "DeleteHouse", value = "/DeleteHouse")
public class DeleteHouse extends HttpServlet {
    PrintWriter out;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        out = response.getWriter();
        try {
            String houseNumberToDelete = request.getParameter("houseNumberToDelete");
            String username = (String) request.getSession().getAttribute("username");
            String deleteAs = username.equalsIgnoreCase("admin") || username.equalsIgnoreCase("administrator") ?
                    request.getParameter("deleteAs") : username;

            House house=new House();
            house.setHouseNo(houseNumberToDelete);
            house.setUsername(deleteAs);

            int deleteCount = RHMSDAO.delete(house);
            if (deleteCount > 0) {
                request.setAttribute("msg", "<div class='alert alert-success'><strong>Success!</strong> Successful data deletion.</div>");
            } else if (deleteCount == 0) {
                request.setAttribute("msg", "<div class='alert alert-danger'>No such data exists to be deleted.</div>");
            } else if (deleteCount == -1) {
                request.setAttribute("msg", "<div class='alert alert-danger'>Something went wrong during deleting data. Please try again later.</div>");
            }
            request.getRequestDispatcher("update.jsp").forward(request, response);
        } catch (Exception e) {
            out.println(Arrays.toString(e.getStackTrace()));
            e.printStackTrace();
        }

    }
}
