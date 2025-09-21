package com.campuseats;

import java.io.IOException;
import java.sql.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/PaymentDemoServlet")
public class PaymentDemoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @SuppressWarnings("unchecked")
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

        if (cart == null || cart.isEmpty()) {
            response.sendRedirect("cart.jsp");
            return;
        }

        String paymentMethod = request.getParameter("paymentMethod"); // COD or UPI
        String paymentStatus = "Pending";
        if ("UPI".equalsIgnoreCase(paymentMethod)) paymentStatus = "Paid";

        // Use studentId, NOT staffId
        Integer studentId = (Integer) session.getAttribute("studentId");
        if (studentId == null) {
            response.sendRedirect("index.jsp?error=login");
            return;
        }

        double totalAmount = cart.stream().mapToDouble(CartItem::getTotalPrice).sum();

        try (Connection con = DBConnection.getConnection()) {

            // Insert into orders table
            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO orders(user_id, total_amount, payment_status, status, order_date) VALUES(?,?,?,?,?)",
                Statement.RETURN_GENERATED_KEYS
            );
            ps.setInt(1, studentId);
            ps.setDouble(2, totalAmount);
            ps.setString(3, paymentStatus);
            ps.setString(4, "Pending"); // order status
            ps.setTimestamp(5, new Timestamp(System.currentTimeMillis()));
            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            int orderId = 0;
            if (rs.next()) orderId = rs.getInt(1);

            // Insert order_items
            PreparedStatement psItem = con.prepareStatement(
                "INSERT INTO order_items(order_id, item_id, name, price, quantity) VALUES(?,?,?,?,?)"
            );
            for (CartItem c : cart) {
                psItem.setInt(1, orderId);
                psItem.setInt(2, c.getId());
                psItem.setString(3, c.getName());
                psItem.setDouble(4, c.getPrice());
                psItem.setInt(5, c.getQuantity());
                psItem.addBatch();
            }
            psItem.executeBatch();

            // Save order info in session
            session.setAttribute("lastOrderId", orderId);
            session.setAttribute("lastOrderTotal", totalAmount);
            session.setAttribute("lastPaymentStatus", paymentStatus);

            cart.clear();
            session.setAttribute("cart", cart);

            response.sendRedirect("paymentSuccess.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("cart.jsp");
    }
}
