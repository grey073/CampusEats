package com.campuseats;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/manageItemsServlet")
public class ManageItemsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");
        if (role == null || (!role.equals("staff") && !role.equals("admin"))) {
            response.sendRedirect("index.jsp");
            return;
        }

        List<MenuItem> items = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pst = con.prepareStatement("SELECT * FROM menu ORDER BY category, item_name")) {

            ResultSet rs = pst.executeQuery();
            while (rs.next()) {
                items.add(new MenuItem(
                    rs.getInt("id"),
                    rs.getString("item_name"),
                    rs.getString("category"),
                    rs.getDouble("price"),
                    rs.getInt("availability") == 1,
                    rs.getString("images")
                ));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("items", items);
        request.getRequestDispatcher("manageItems.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int itemId = Integer.parseInt(request.getParameter("itemId"));
        boolean available = Boolean.parseBoolean(request.getParameter("available"));

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pst = con.prepareStatement("UPDATE menu SET availability=? WHERE id=?")) {

            pst.setInt(1, available ? 1 : 0);
            pst.setInt(2, itemId);
            pst.executeUpdate();

            response.sendRedirect("manageItemsServlet");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
