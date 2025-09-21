<%@ page import="java.util.*, com.campuseats.Order, com.campuseats.OrderItem" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>My Orders - CampusEats</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f7f7f7; margin: 0; padding: 0; }
        .container { width: 80%; margin: 40px auto; background: #fff; padding: 20px; border-radius: 12px; box-shadow: 0 0 15px rgba(0,0,0,0.1); }
        h1 { background: maroon; color: white; text-align: center; padding: 15px; border-radius: 8px; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; font-size: 0.9em; }
        th, td { padding: 8px; text-align: center; border-bottom: 1px solid #ddd; }
        th { background-color: maroon; color: white; }
        td.status-paid { color: green; font-weight: bold; }
        td.status-pending { color: orange; font-weight: bold; }
        .empty { text-align: center; font-size: 1.1em; color: #555; margin-top: 20px; }
        .back-link { display: inline-block; margin-top: 20px; text-decoration: none; color: white; background-color: maroon; padding: 8px 15px; border-radius: 6px; transition: 0.3s; }
        .back-link:hover { background-color: darkred; }
    </style>
</head>
<body>
<div class="container">
    <h1>My Orders</h1>

    <%
        List<Order> orders = (List<Order>) request.getAttribute("orders");
        if (orders != null && !orders.isEmpty()) {
    %>
        <table>
            <tr>
                <th>Order ID</th>
                <th>Item Name</th>
                <th>Total Amount Rs</th>
                <th>Payment Status</th>
                <th>Order Status</th>
                <th>Order Date</th>
            </tr>
            <% for (Order o : orders) { 
                   for (OrderItem item : o.getItems()) {
            %>
            <tr>
                <td><%= o.getOrderId() %></td>
                <td><%= item.getName() %></td>
                <td><%= o.getTotalAmount() %></td>
                <td class="status-<%= o.getPaymentStatus().toLowerCase() %>"><%= o.getPaymentStatus() %></td>
                <td><%= o.getOrderStatus() %></td>
                <td><%= o.getOrderDate() %></td>
            </tr>
            <% } } %>
        </table>
    <% } else { %>
        <p class="empty">You have no orders yet.</p>
    <% } %>

    <div style="text-align:center;">
        <a href="menu" class="back-link">Back to Menu</a>
    </div>
</div>
</body>
</html>
