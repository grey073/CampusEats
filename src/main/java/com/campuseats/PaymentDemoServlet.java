package com.campuseats;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.UUID;

@WebServlet("/PaymentDemoServlet")
public class PaymentDemoServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String paymentMethod = request.getParameter("paymentMethod");
        String amount = request.getParameter("amount");

        if(paymentMethod == null || amount == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Payment info missing");
            return;
        }

        // Format amount
        try { amount = String.format("%.2f", Double.parseDouble(amount)); }
        catch(NumberFormatException e) { amount = "0.00"; }

        HttpSession session = request.getSession();
        session.removeAttribute("cart"); // clear cart

        // Generate fake order ID
        String orderId = (paymentMethod.equalsIgnoreCase("Cash") ? "COD-" : "PAY-") +
                          UUID.randomUUID().toString().substring(0, 8).toUpperCase();

        // Store in session for JSP
        session.setAttribute("paymentMethod", paymentMethod);
        session.setAttribute("amountPaid", amount);
        session.setAttribute("orderId", orderId);

        // Forward to payment.jsp
        request.getRequestDispatcher("payment.jsp").forward(request, response);
    }
}
