package com.campuseats;

import java.io.IOException;
import java.sql.*;
import java.util.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import javax.servlet.*;

@WebServlet("/place-order")
public class PlaceOrderServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect("index.jsp");
            return;
        }
        Integer userId = (Integer) session.getAttribute("userId");
        Map<Integer,Integer> cart = (Map<Integer,Integer>) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) { resp.sendRedirect("menu"); return; }

        try (Connection con = DBConnection.getConnection()) {
            con.setAutoCommit(false);
            // compute total price and insert order
            double total = 0.0;
            StringBuilder sb = new StringBuilder();
            for (Integer id : cart.keySet()) { if (sb.length()>0) sb.append(","); sb.append(id); }
            String sqlItems = "SELECT id, price FROM menu WHERE id IN (" + sb.toString() + ")";
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery(sqlItems);
            Map<Integer,Double> priceMap = new HashMap<>();
            while (rs.next()) priceMap.put(rs.getInt("id"), rs.getDouble("price"));
            for (Map.Entry<Integer,Integer> e : cart.entrySet()) {
                total += priceMap.get(e.getKey()) * e.getValue();
            }

            String insertOrder = "INSERT INTO orders (user_id, total_price, status) VALUES (?, ?, 'Pending')";
            PreparedStatement psOrder = con.prepareStatement(insertOrder, Statement.RETURN_GENERATED_KEYS);
            psOrder.setInt(1, userId);
            psOrder.setDouble(2, total);
            psOrder.executeUpdate();
            ResultSet keys = psOrder.getGeneratedKeys();
            keys.next();
            int orderId = keys.getInt(1);

            String insertItem = "INSERT INTO order_items (order_id, item_id, quantity, price) VALUES (?, ?, ?, ?)";
            PreparedStatement psItem = con.prepareStatement(insertItem);
            for (Map.Entry<Integer,Integer> e : cart.entrySet()) {
                int itemId = e.getKey(), qty = e.getValue();
                double price = priceMap.get(itemId);
                psItem.setInt(1, orderId);
                psItem.setInt(2, itemId);
                psItem.setInt(3, qty);
                psItem.setDouble(4, price);
                psItem.addBatch();
            }
            psItem.executeBatch();
            con.commit();

            // clear cart
            session.removeAttribute("cart");

            // redirect to an order-confirm page or orders list
            resp.sendRedirect("orders.jsp?placed=1&orderId=" + orderId);
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("cart.jsp?error=1");
        }
    }
}
