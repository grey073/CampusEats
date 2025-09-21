package com.campuseats;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null) cart = new ArrayList<>();

        String action = request.getParameter("action");
        if (action == null) action = "add";

        try {
            if (action.startsWith("update_")) {
                // Extract item ID from action
                int id = Integer.parseInt(action.split("_")[1]);
                // Get quantity input value
                String qtyStr = request.getParameter("quantity_" + id);
                int quantity = Integer.parseInt(qtyStr);

                for (CartItem item : cart) {
                    if (item.getId() == id) {
                        item.setQuantity(quantity);
                        break;
                    }
                }
            } else if (action.startsWith("remove_")) {
                int id = Integer.parseInt(action.split("_")[1]);
                cart.removeIf(item -> item.getId() == id);
            } else if (action.equals("pay")) {
                // Payment method
                String paymentMethod = request.getParameter("paymentMethod");
                session.setAttribute("lastPaymentStatus", paymentMethod.equals("COD") ? "Pending" : "Paid");

                double totalAmount = cart.stream().mapToDouble(CartItem::getTotalPrice).sum();
                session.setAttribute("lastOrderTotal", totalAmount);
                session.setAttribute("lastOrderId", System.currentTimeMillis()); // demo order ID

                cart.clear();
                response.sendRedirect("paymentSuccess.jsp");
                session.setAttribute("cart", cart);
                return;
            } else if (action.equals("add")) {
                int id = Integer.parseInt(request.getParameter("id"));
                String name = request.getParameter("name");
                double price = Double.parseDouble(request.getParameter("price"));

                boolean found = false;
                for (CartItem item : cart) {
                    if (item.getId() == id) {
                        item.setQuantity(item.getQuantity() + 1);
                        found = true;
                        break;
                    }
                }
                if (!found) cart.add(new CartItem(id, name, price, 1));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        session.setAttribute("cart", cart);
        response.sendRedirect("cart.jsp");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("cart.jsp");
    }
}
