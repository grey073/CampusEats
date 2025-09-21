package com.campuseats;

import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/checkNewOrdersPlain")
public class CheckNewOrdersServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Only staff/admin should access
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");
        if (role == null || (!role.equals("staff") && !role.equals("admin"))) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.getWriter().write("");
            return;
        }

        response.setContentType("text/plain");
        try (Connection con = DBConnection.getConnection();
             Statement stmt = con.createStatement()) {

            // Count new/unseen orders
            ResultSet rs = stmt.executeQuery("SELECT COUNT(*) AS cnt FROM orders WHERE is_notified=0");

            if (rs.next() && rs.getInt("cnt") > 0) {
                response.getWriter().write("New order(s) received!");

                // Mark them as notified
                stmt.executeUpdate("UPDATE orders SET is_notified=1 WHERE is_notified=0");
            } else {
                response.getWriter().write(""); // no new orders
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().write("");
        }
    }
}
