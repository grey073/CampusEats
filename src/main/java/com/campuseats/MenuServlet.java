package com.campuseats;

import java.io.IOException;
import java.sql.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/menu")
public class MenuServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Map<String, List<MenuItem>> menuByCategory = new LinkedHashMap<>();
        String[] categories = {"breakfast", "lunch", "dinner", "snacks", "juices"};

        try (Connection con = DBConnection.getConnection()) {
            for (String category : categories) {
                List<MenuItem> list = new ArrayList<>();
                PreparedStatement pst = con.prepareStatement(
                        "SELECT * FROM menu WHERE category=? AND availability=1");
                pst.setString(1, category);
                ResultSet rs = pst.executeQuery();
                while (rs.next()) {
                    list.add(new MenuItem(
                            rs.getInt("id"),
                            rs.getString("item_name"),
                            rs.getString("category"),
                            rs.getDouble("price"),
                            rs.getBoolean("availability"),
                            rs.getString("images")
                    ));
                }
                if (!list.isEmpty()) {
                    menuByCategory.put(category, list);
                }
                rs.close();
                pst.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        request.setAttribute("menuByCategory", menuByCategory);
        RequestDispatcher rd = request.getRequestDispatcher("menu.jsp");
        rd.forward(request, response);
    }
}
