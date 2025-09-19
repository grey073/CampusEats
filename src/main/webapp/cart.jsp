<%@ page import="java.util.*, com.campuseats.CartItem, com.campuseats.MenuItem" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>Your Cart - CampusEats</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f7f7f7; margin: 0; padding: 0; }
        .container { width: 80%; margin: 40px auto; background: #fff; padding: 20px; border-radius: 12px; box-shadow: 0 0 15px rgba(0,0,0,0.1); }
        h1 { text-align: center; color: maroon; margin-bottom: 20px; }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 12px; text-align: center; border-bottom: 1px solid #ddd; }
        th { background-color: maroon; color: white; }
        td input[type="number"] { width: 60px; padding: 4px; text-align: center; border-radius: 4px; border: 1px solid #ccc; }
        .btn { padding: 6px 12px; border: none; border-radius: 5px; cursor: pointer; font-weight: bold; }
        .btn-update { background-color: #28a745; color: white; }
        .btn-update:hover { background-color: #218838; }
        .btn-remove { background-color: #dc3545; color: white; }
        .btn-remove:hover { background-color: #c82333; }
        .grand-total { text-align: right; font-size: 1.2em; font-weight: bold; margin-top: 15px; }
        .empty-cart { text-align: center; font-size: 1.1em; color: #555; }
        .back-link { display: inline-block; margin-top: 20px; text-decoration: none; color: white; background-color: maroon; padding: 8px 15px; border-radius: 6px; transition: 0.3s; }
        .back-link:hover { background-color: darkred; }
    </style>
</head>
<body>
<div class="container">
    <h1>Your Cart</h1>

    <%
        // Step 1: safely load cart and convert old MenuItem -> CartItem
        List<CartItem> cart = new ArrayList<>();
        Object sessionCart = session.getAttribute("cart");
        if (sessionCart != null) {
            List<?> list = (List<?>) sessionCart;
            for (Object o : list) {
                if (o instanceof CartItem) {
                    cart.add((CartItem) o);
                } else if (o instanceof MenuItem) {
                    MenuItem m = (MenuItem) o;
                    cart.add(new CartItem(m.getId(), m.getName(), m.getPrice(), 1));
                }
            }
            // overwrite session with proper CartItem list
            session.setAttribute("cart", cart);
        }

        if (cart.isEmpty()) {
    %>
        <p class="empty-cart">Your cart is currently empty.</p>
    <%
        } else {
            double grandTotal = 0;
    %>
    <form action="cart" method="get">
        <table>
            <tr>
                <th>Item Name</th>
                <th>Price</th>
                <th>Quantity</th>
                <th>Total</th>
                <th>Actions</th>
            </tr>
            <%
                for (CartItem item : cart) {
                    double total = item.getTotalPrice();
                    grandTotal += total;
            %>
            <tr>
                <td><%= item.getName() %></td>
                <td><%= item.getPrice() %></td>
                <td>
                    <input type="number" name="quantity" value="<%= item.getQuantity() %>" min="1"/>
                </td>
                <td><%= total %></td>
                <td>
                    <button type="submit" name="action" value="update" class="btn btn-update">Update</button>
                    <button type="submit" name="action" value="remove" class="btn btn-remove">Remove</button>
                    <input type="hidden" name="id" value="<%= item.getId() %>"/>
                </td>
            </tr>
            <% } %>
        </table>
        <div class="grand-total">Grand Total: <%= grandTotal %></div>
    </form>
    <% } %>

    <div style="text-align:center;">
        <a href="menu" class="back-link">Back to Menu</a>
    </div>
</div>
</body>
</html>
