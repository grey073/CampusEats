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
        .payment-box { margin-top: 20px; padding: 15px; border: 1px solid #ddd; border-radius: 8px; background: #fafafa; }
        .payment-title { font-weight: bold; margin-bottom: 10px; color: maroon; }
        .action-buttons { text-align:center; margin-top: 20px; }
    </style>
    <script>
        function confirmRemove() {
            return confirm('Are you sure you want to remove this item?');
        }
    </script>
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
            session.setAttribute("cart", cart);
        }

        if (cart.isEmpty()) {
    %>
        <p class="empty-cart">Your cart is currently empty.</p>
    <%
        } else {
            double grandTotal = 0;
    %>
   
    

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
            <td><%= String.format("%.2f", item.getPrice()) %></td>

            <!-- Update quantity -->
            <td>
                <form action="cart" method="post" style="display:inline-block;">
                    <input type="hidden" name="action" value="update"/>
                    <input type="hidden" name="id" value="<%= item.getId() %>"/>
                    <input type="number" name="quantity" value="<%= item.getQuantity() %>" min="1"/>
                    <button type="submit" class="btn btn-update">Update</button>
                </form>
            </td>

            <td><%= String.format("%.2f", total) %></td>

            <!-- Remove item -->
            <td>
                <form action="cart" method="post" style="display:inline;">
                    <input type="hidden" name="action" value="remove">
                    <input type="hidden" name="id" value="<%= item.getId() %>">
                    <button type="submit" class="btn btn-remove" onclick="return confirmRemove();">Remove</button>
                </form>
            </td>
        </tr>
        <% } %>
    </table>

    <div class="grand-total">Grand Total: <%= String.format("%.2f", grandTotal) %></div>

    <!-- Payment & Place Order -->
     <div class="payment-box">
    <form action="PaymentDemoServlet" method="post">
        <div>
            <label>
                <input type="radio" name="paymentMethod" value="Cash" required> Cash on Delivery
            </label><br>
            <label>
                <input type="radio" name="paymentMethod" value="UPI"> UPI
            </label><br>
            <label>
                <input type="radio" name="paymentMethod" value="Card"> Card
            </label>
        </div>
        <input type="hidden" name="amount" value="<%= grandTotal %>">
        <div style="margin-top:15px;">
            <button type="submit" class="btn btn-update">Place Order</button>
        </div>
    </form>
</div>
       

    <% } %>

    <div class="action-buttons">
        <a href="menu" class="back-link">Back to Menu</a>
    </div>
</div>
</body>
</html>
