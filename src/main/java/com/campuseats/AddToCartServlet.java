package com.campuseats;

import java.io.IOException;
import java.util.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/addToCart")
public class AddToCartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @SuppressWarnings("unchecked")
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new ArrayList<>();
        }

        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        double price = Double.parseDouble(request.getParameter("price"));
        int quantity = 1; // default 1 item
        CartItem found = null;
        for (CartItem item : cart) {
            if (item.getId() == id) { found = item; break; }
        }
        if (found != null) {
            found.setQuantity(found.getQuantity() + 1);
        } else {
            cart.add(new CartItem(id, name, price, quantity));
        }

        session.setAttribute("cart", cart);
        response.sendRedirect("cart.jsp");
    }
}
