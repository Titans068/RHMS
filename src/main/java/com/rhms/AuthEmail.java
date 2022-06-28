package com.rhms;

import org.apache.commons.validator.routines.EmailValidator;

import javax.mail.MessagingException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.URL;
import java.util.Arrays;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

@WebServlet(name = "AuthEmail", value = "/AuthEmail")
public class AuthEmail extends HttpServlet {
    PrintWriter out;
    String gen;
    HttpSession session;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        out = response.getWriter();
        session = request.getSession();
        String email = request.getParameter("email");
        //System.out.printf("%s://%s%s/resetPassword.jsp?tok=%s.", url.getProtocol(), url.getAuthority(), request.getContextPath(), gen);
        gen = generate(10);
        URL url = new URL(request.getRequestURL().toString());
        try {
            if (EmailValidator.getInstance().isValid(email)) {
                Utils.authenticate(email, String.format("%s://%s%s/resetPassword.jsp?tok=%s", url.getProtocol(),
                        url.getAuthority(), request.getContextPath(), gen));
                session.setAttribute("email", email);
                session.setAttribute("gen", gen);
                request.setAttribute("msg",
                        "<div class='alert alert-info'>An email has been sent with further instructions.</div>");
            } else request.setAttribute("msg",
                    "<div class='alert alert-danger'>The provided email address is invalid.</div>");
            request.getRequestDispatcher("resetPassword.jsp").forward(request, response);
        } catch (MessagingException e) {
            out.println(Arrays.toString(e.getStackTrace()));
            e.printStackTrace();
        }
    }

    public String generate(int n) {
        String gen = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
        return IntStream.range(0, n).mapToObj(i -> String.valueOf(gen.charAt((int) (Math.random() * gen.length()))))
                .collect(Collectors.joining());
    }

}
