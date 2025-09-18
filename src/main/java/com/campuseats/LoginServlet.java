package com.campuseats;

import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try {
            // 1. Load driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // 2. Connect to DB
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/campuseats", "root", "password");

            // 3. Prepare query
            PreparedStatement pst = con.prepareStatement(
                "SELECT * FROM users WHERE username=? AND password=?");
            pst.setString(1, username);
            pst.setString(2, password);

            ResultSet rs = pst.executeQuery();

            if (rs.next()) {
                // --- Store user details in session ---
                HttpSession session = request.getSession();
                session.setAttribute("userId", rs.getInt("id"));   // assuming your users table has 'id'
                session.setAttribute("username", rs.getString("username"));
                session.setAttribute("role", rs.getString("role")); // if you have roles

                // Redirect to menu
                response.sendRedirect("menu");
            } else {
                // Login failed → back to login page
                response.sendRedirect("index.jsp?error=1");
            }

            con.close();
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Database error: " + e.getMessage());
        }
    }
}
