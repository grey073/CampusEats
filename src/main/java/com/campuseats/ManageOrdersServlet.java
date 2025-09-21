package com.campuseats;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/manageOrdersServlet")
public class ManageOrdersServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");
        if (role == null || (!role.equals("staff") && !role.equals("admin"))) {
            response.sendRedirect("index.jsp");
            return;
        }

        List<Order> orders = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pst = con.prepareStatement("SELECT * FROM orders ORDER BY order_date DESC")) {

            ResultSet rs = pst.executeQuery();
            while (rs.next()) {
                int orderId = rs.getInt("order_id");
                int userId = rs.getInt("user_id");
                double total = rs.getDouble("total_amount");
                String paymentStatus = rs.getString("payment_status");
                String status = rs.getString("status");
                Timestamp orderDate = rs.getTimestamp("order_date");

                List<OrderItem> items = new ArrayList<>();
                try (PreparedStatement pstItems = con.prepareStatement(
                        "SELECT * FROM order_items WHERE order_id=?")) {
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
                }

                orders.add(new Order(orderId, userId, total, paymentStatus, status, orderDate, items));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("orders", orders);
        request.getRequestDispatcher("staffOrders.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int orderId = Integer.parseInt(request.getParameter("orderId"));
        String status = request.getParameter("status");

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pst = con.prepareStatement("UPDATE orders SET status=? WHERE order_id=?")) {
            pst.setString(1, status);
            pst.setInt(2, orderId);
            pst.executeUpdate();
            response.sendRedirect("manageOrdersServlet");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
