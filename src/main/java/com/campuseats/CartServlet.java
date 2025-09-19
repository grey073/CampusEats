
package com.campuseats;

import java.io.IOException;
import java.util.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;



@WebServlet("/cart")
public class CartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

        if (cart == null) {
            cart = new ArrayList<>();
            session.setAttribute("cart", cart);
        }

        String action = request.getParameter("action");
        String itemIdStr = request.getParameter("id");

        if (action != null && itemIdStr != null) {
            int id = Integer.parseInt(itemIdStr);

            switch (action) {
                case "add":
                    String name = request.getParameter("name");
                    double price = Double.parseDouble(request.getParameter("price"));
                    boolean found = false;
                    for (CartItem ci : cart) {
                        if (ci.getId() == id) {
                            ci.setQuantity(ci.getQuantity() + 1);
                            found = true;
                            break;
                        }
                    }
                    if (!found) {
                        cart.add(new CartItem(id, name, price, 1));
                    }
                    break;

                case "remove":
                    cart.removeIf(ci -> ci.getId() == id);
                    break;

                case "update":
                    int quantity = Integer.parseInt(request.getParameter("quantity"));
                    for (CartItem ci : cart) {
                        if (ci.getId() == id) {
                            ci.setQuantity(quantity);
                            break;
                        }
                    }
                    break;
            }
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("cart.jsp");
        dispatcher.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
