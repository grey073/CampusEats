package com.campuseats;

import java.io.IOException;
import java.sql.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/OrderSummaryServlet")
public class OrderSummaryServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer studentId = (Integer) session.getAttribute("studentId"); // Use studentId

        if (studentId == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        List<Order> orders = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pst = con.prepareStatement(
                 "SELECT * FROM orders WHERE user_id=? ORDER BY order_date DESC")) {

            pst.setInt(1, studentId);
            ResultSet rs = pst.executeQuery();

            while (rs.next()) {
                int orderId = rs.getInt("order_id");

                // Fetch order items
                List<OrderItem> items = new ArrayList<>();
                PreparedStatement pstItems = con.prepareStatement(
                        "SELECT * FROM order_items WHERE order_id=?");
                pstItems.setInt(1, orderId);
                ResultSet rsItems = pstItems.executeQuery();
                while (rsItems.next()) {
                    items.add(new OrderItem(
                        rsItems.getInt("id"),
                        rsItems.getInt("order_id"),
                        rsItems.getInt("item_id"),
                        rsItems.getString("name"),
                        rsItems.getDouble("price"),
                        rsItems.getInt("quantity")
                    ));
                }

                orders.add(new Order(
                    orderId,
                    studentId,
                    rs.getDouble("total_amount"),
                    rs.getString("payment_status"),
                    rs.getString("status"),
                    rs.getTimestamp("order_date"),
                    items
                ));
            }

            request.setAttribute("orders", orders);
            request.getRequestDispatcher("orders.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Database error: " + e.getMessage());
        }
    }
}
