package com.campuseats;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/order")
public class OrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            response.sendRedirect("index.jsp?error=login");
            return;
        }

        List<Order> orders = new ArrayList<>();

        try (Connection con = DBConnection.getConnection()) {
            String query = "SELECT * FROM orders WHERE user_id = ? ORDER BY order_date DESC";
            PreparedStatement pst = con.prepareStatement(query);
            pst.setInt(1, userId);
            ResultSet rs = pst.executeQuery();

            while (rs.next()) {
                Order order = new Order(
                    rs.getInt("order_id"),
                    rs.getInt("user_id"),
                    rs.getDouble("total_amount"),
                    rs.getString("payment_status"),
                    rs.getTimestamp("order_date")
                );
                orders.add(order);
            }

            request.setAttribute("orders", orders);
            RequestDispatcher rd = request.getRequestDispatcher("orders.jsp");
            rd.forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().println("Database error: " + e.getMessage());
        }
    }
}
