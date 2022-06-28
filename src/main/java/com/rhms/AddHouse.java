package com.rhms;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.*;
import java.util.Arrays;

@MultipartConfig
@WebServlet(name = "AddHouse", value = "/AddHouse")
public class AddHouse extends HttpServlet {
    PrintWriter out;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        out = response.getWriter();
        OutputStream output = null;
        InputStream fileContent = null;
        try {
            String usern = (String) request.getSession().getAttribute("username"),
                    addAs = request.getParameter("addAs"),
                    building = request.getParameter("building"),
                    location = request.getParameter("location"),
                    rent = request.getParameter("rent"),
                    description = request.getParameter("description"),
                    houseNumber = request.getParameter("houseNumber"),
                    phoneNumber = request.getParameter("phoneNumber"),
                    link = request.getParameter("link"),
                    filePath = request.getServletContext().getRealPath("/") + "uploadedpics" + File.separator,
                    fileName = null;


            Part filePart = request.getPart("fileField");
            if (filePart.getSize() > 0) {
                fileName = Arrays.stream(filePart.getHeader("content-disposition").split(";"))
                        .filter(content -> content.trim().startsWith("filename")).findFirst()
                        .map(content -> content.substring(content.indexOf('=') + 1).trim()
                                .replace("\"", "")).orElse(null);

                output = new FileOutputStream(filePath + File.separator + fileName);
                fileContent = filePart.getInputStream();
                int read;
                byte[] bytes = new byte[1024];
                while ((read = fileContent.read(bytes)) != -1) {
                    output.write(bytes, 0, read);
                }
            }

            House house = new House();
            house.setBuilding(building);
            house.setLocation(location);
            house.setRent(rent);
            house.setDescr(description);
            house.setHouseNo(houseNumber);
            house.setPhoneNumber(phoneNumber);
            house.setLink(link);
            house.setState("Open");
            house.setUsername(usern.equalsIgnoreCase("admin") || usern.equalsIgnoreCase("administrator") ? addAs : usern);
            house.setImage(fileName == null ? fileName : "uploadedpics" + File.separator + fileName);
            if (RHMSDAO.insert(house)) {
                request.setAttribute("msg", "<div class='alert alert-success'><strong>Success!</strong> Successful data entry.</div>");
            } else {
                request.setAttribute("msg", "<div class='alert alert-danger'>Something went wrong during data entry. Please try again later.</div>");
            }
            request.getRequestDispatcher("addHouse.jsp").forward(request, response);
        } catch (FileNotFoundException ignored) {
        } catch (java.sql.SQLException e) {
            out.println(Arrays.toString(e.getStackTrace()));
            e.printStackTrace();
        } finally {
            if (output != null) output.close();
            if (fileContent != null) fileContent.close();
        }
    }
}
