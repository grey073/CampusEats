<%@ page import="java.util.*, com.campuseats.Order, com.campuseats.OrderItem" %>
<%@ page session="true" %>
<%
String role = (String) session.getAttribute("role");
if (role == null || (!role.equals("staff") && !role.equals("admin"))) {
    response.sendRedirect("index.jsp");
    return;
}
%>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Orders - CampusEats</title>
    <style>
        body { font-family: Arial; background: #f7f7f7; margin:0; padding:0; }
        .container { width:90%; margin:40px auto; background:#fff; padding:20px; border-radius:12px; box-shadow:0 0 15px rgba(0,0,0,0.1);}
        h1.block-heading { background:maroon; color:white; padding:15px; border-radius:8px; text-align:center; margin-bottom:20px;}
        table { width:100%; border-collapse:collapse; margin-bottom:20px; }
        th, td { border:1px solid #ccc; padding:8px; text-align:center; }
        th { background:maroon; color:white; }
        select, button { padding:5px 10px; border-radius:5px; border:none; cursor:pointer; }
        button { background:maroon; color:white; }
        button:hover { background:darkred; }
        .back-link { display:inline-block; margin-top:15px; text-decoration:none; color:white; background:maroon; padding:8px 12px; border-radius:6px; }
        .back-link:hover { background:darkred; }
    </style>
</head>
<body>
<div class="container">
<h1 class="block-heading">Manage Orders</h1>

<%
List<Order> orders = (List<Order>) request.getAttribute("orders");
if (orders != null && !orders.isEmpty()) {
%>
<table>
    <tr>
        <th>Order ID</th>
        <th>User ID</th>
        <th>Items</th>
        <th>Total Rs</th>
        <th>Payment Status</th>
        <th>Order Status</th>
        <th>Change Status</th>
        <th>Order Date</th>
    </tr>
<%  for (Order o : orders) { %>
    <tr>
        <td><%= o.getOrderId() %></td>
        <td><%= o.getUserId() %></td>
        <td>
            <% for (OrderItem item : o.getItems()) { %>
                <%= item.getName() %> (x<%= item.getQuantity() %>)<br/>
            <% } %>
        </td>
        <td><%= o.getTotalAmount() %></td>
        <td><%= o.getPaymentStatus() %></td>
        <td><%= o.getOrderStatus() %></td>
        <td>
            <form action="manageOrdersServlet" method="post">
                <input type="hidden" name="orderId" value="<%= o.getOrderId() %>"/>
                <select name="status">
                    <option value="pending" <%= "pending".equals(o.getOrderStatus())?"selected":"" %>>Pending</option>
                    <option value="preparing" <%= "preparing".equals(o.getOrderStatus())?"selected":"" %>>Preparing</option>
                    <option value="completed" <%= "completed".equals(o.getOrderStatus())?"selected":"" %>>Completed</option>
                    <option value="cancelled" <%= "cancelled".equals(o.getOrderStatus())?"selected":"" %>>Cancelled</option>
                </select>
                <button type="submit">Update</button>
            </form>
        </td>
        <td><%= o.getOrderDate() %></td>
    </tr>
<%  } %>
</table>
<% } else { %>
<p>No orders found.</p>
<% } %>

<div style="text-align:center;">
    <a href="staffDashboard.jsp" class="back-link">Back to Dashboard</a>
</div>

</div>
</body>
</html>
