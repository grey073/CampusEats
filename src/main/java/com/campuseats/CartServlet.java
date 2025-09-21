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

        switch (action) {
            case "add":
                addItem(request, cart, session);
                session.setAttribute("cart", cart);
                response.sendRedirect("menu.jsp?added=success");
                return;

            case "update":
                updateItem(request, cart);
                break;

            case "remove":
                removeItem(request, cart);
                break;

            default:
                break;
        }

        session.setAttribute("cart", cart);
        response.sendRedirect("cart.jsp");
    }

    private void addItem(HttpServletRequest request, List<CartItem> cart, HttpSession session) {
        try {
            int id = Integer.parseInt(request.getParameter("id"));

            List<MenuItem> menu = (List<MenuItem>) session.getAttribute("menu");
            double price = 0;
            String name = "";
            if (menu != null) {
                for (MenuItem m : menu) {
                    if (m.getId() == id) {
                        price = m.getPrice();
                        name = m.getName();
                        break;
                    }
                }
            }

            boolean found = false;
            for (CartItem item : cart) {
                if (item.getId() == id) {
                    item.setQuantity(item.getQuantity() + 1);
                    found = true;
                    break;
                }
            }
            if (!found) cart.add(new CartItem(id, name, price, 1));

        } catch (NumberFormatException e) {
            e.printStackTrace();
        }
    }

    private void updateItem(HttpServletRequest request, List<CartItem> cart) {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));

            for (CartItem item : cart) {
                if (item.getId() == id) {
                    item.setQuantity(quantity);
                    break;
                }
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }
    }

    private void removeItem(HttpServletRequest request, List<CartItem> cart) {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            cart.removeIf(item -> item.getId() == id);
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("cart.jsp");
    }
}
