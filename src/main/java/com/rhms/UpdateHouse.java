package com.rhms;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Arrays;

@WebServlet(name = "UpdateHouse", value = "/UpdateHouse")
public class UpdateHouse extends HttpServlet {
    PrintWriter out;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        out = response.getWriter();
        try {
            String houseNumber = request.getParameter("houseNumber");
            String rent = request.getParameter("rent");
            String state = request.getParameter("state");
            String username = (String) request.getSession().getAttribute("username");
            String updateAs = request.getParameter("updateAs");
            House house = new House();
            house.setHouseNo(houseNumber);
            house.setRent(rent);
            house.setState(state);
            house.setUsername(username.equalsIgnoreCase("admin") || username.equalsIgnoreCase("administrator") ?
                    updateAs : username);

            int updateCount = RHMSDAO.update(house);
            if (updateCount > 0) {
                request.setAttribute("msg", "<div class='alert alert-success'><strong>Success!</strong> Successful data update.</div>");
            } else if (updateCount == 0) {
                request.setAttribute("msg", "<div class='alert alert-danger'>No such data exists to be updated.</div>");
            } else if (updateCount == -1) {
                request.setAttribute("msg", "<div class='alert alert-danger'>Something went wrong during updating data. Please try again later.</div>");
            }
            request.getRequestDispatcher("update.jsp").forward(request, response);
        } catch (Exception e) {
            out.println(Arrays.toString(e.getStackTrace()));
            e.printStackTrace();
        }
    }
}
