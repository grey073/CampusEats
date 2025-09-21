<%@ page import="java.util.List, java.util.ArrayList, com.campuseats.CartItem" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>CampusEats - Cart</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f7f7f7; margin: 0; padding: 0; }
        .header { background: maroon; color: white; padding: 15px; text-align: center; font-size: 1.5em; }
        .container { width: 80%; margin: 40px auto; background: #fff; padding: 20px; border-radius: 12px; box-shadow: 0 0 15px rgba(0,0,0,0.1); }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 12px; text-align: center; border-bottom: 1px solid #ddd; }
        th { background-color: maroon; color: white; }
        td input[type="number"] { width: 60px; padding: 4px; text-align: center; border-radius: 4px; border: 1px solid #ccc; }
        .btn { padding: 6px 12px; border: none; border-radius: 5px; cursor: pointer; font-weight: bold; margin: 2px; }
        .btn-update { background-color: #28a745; color: white; }
        .btn-update:hover { background-color: #218838; }
        .btn-remove { background-color: #dc3545; color: white; }
        .btn-remove:hover { background-color: #c82333; }
        .btn-pay { background-color: maroon; color: white; padding: 10px 20px; font-size: 1em; margin-top: 15px; }
        .btn-pay:hover { background-color: darkred; }
        .grand-total { text-align: right; font-size: 1.2em; font-weight: bold; margin-top: 15px; }
        .empty-cart { text-align: center; font-size: 1.1em; color: #555; margin-top: 20px; }
        .back-link { display: inline-block; margin-top: 20px; text-decoration: none; color: white; background-color: maroon; padding: 8px 15px; border-radius: 6px; transition: 0.3s; }
        .back-link:hover { background-color: darkred; }
        .payment-method { margin-top: 15px; text-align: left; }
        .payment-method label { margin-right: 20px; font-weight: bold; }
    </style>
</head>
<body>

<div class="header">Your Cart</div>

<div class="container">
<%
    List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
    if (cart == null) cart = new ArrayList<>();
    if (cart.isEmpty()) {
%>
    <p class="empty-cart">Your cart is empty.</p>
<%
    } else {
        double grandTotal = 0;
%>
    <form action="cart" method="post">
        <table>
            <tr>
                <th>Item Name</th>
                <th>Price</th>
                <th>Quantity</th>
                <th>Total</th>
                <th>Actions</th>
            </tr>
            <%
                for (int i = 0; i < cart.size(); i++) {
                    CartItem item = cart.get(i);
                    double total = item.getTotalPrice();
                    grandTotal += total;
            %>
            <tr>
                <td><%= item.getName() %></td>
                <td><%= item.getPrice() %></td>
                <td>
                    <input type="number" name="quantity_<%= item.getId() %>" value="<%= item.getQuantity() %>" min="1"/>
                </td>
                <td><%= total %></td>
                <td>
                    <button type="submit" name="action" value="update_<%= item.getId() %>" class="btn btn-update">Update</button>
                    <button type="submit" name="action" value="remove_<%= item.getId() %>" class="btn btn-remove">Remove</button>
                </td>
            </tr>
            <% } %>
        </table>

        <div class="grand-total">Grand Total: <%= grandTotal %></div>
</form>   <form action="PaymentDemoServlet" method="post">
        <!-- Payment Method -->
        <div class="payment-method">
            <label><input type="radio" name="paymentMethod" value="COD" checked> Cash on Delivery</label>
            <label><input type="radio" name="paymentMethod" value="UPI"> UPI Payment</label>
        </div>

        <button type="submit" name="action" value="pay" class="btn-pay">Pay Now</button>
    </form>
<% } %>

<div style="text-align:center;">
    <a href="menu" class="back-link">Back to Menu</a>
</div>

</div>
</body>
</html>
