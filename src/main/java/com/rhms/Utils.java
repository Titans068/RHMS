package com.rhms;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import java.util.Properties;

public class Utils {
    protected static void authenticate(String email, String url) throws MessagingException {
        final String username = "mwimakat@yahoo.com";
        final String password = "gbvpkxuxkquljzqx";

        Properties props = new Properties();
        props.setProperty("mail.store.protocol", "imaps");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.host", "smtp.mail.yahoo.com");
        props.put("mail.smtp.port", "587");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(username, password);
            }
        });
        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(username));
        message.setRecipients(Message.RecipientType.TO,
                InternetAddress.parse(email));
        message.setSubject("Reset your password.");
        message.setText(url != null ? String.format("Dear %s,\n\n You have requested to reset your password. Visit %s.",
                email.split("@")[0], url) :
                String.format("Dear %s,\n\n Welcome to the Rental House Management System.", email.split("@")[0]));
        Transport.send(message);
        //System.out.println("Done");
    }
}
