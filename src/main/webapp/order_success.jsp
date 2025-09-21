<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Order Success</title>
    <style>
        body { font-family: Arial; margin:20px; text-align:center; }
        .card { border:1px solid #ddd; padding:20px; display:inline-block; }
        h2 { color:green; }
    </style>
</head>
<body>
    <div class="card">
        <h2>🎉 Order Placed Successfully!</h2>
        <p>Order ID: <b><%= request.getAttribute("orderId") %></b></p>
        <p>Total Amount: <b>₹<%= request.getAttribute("total") %></b></p>
        <p>Payment Method: <b><%= request.getAttribute("paymentMethod") %></b></p>
        <p>Status: <b>Pending</b></p>
        <a href="orders.jsp">View All Orders</a>
    </div>
</body>
</html>
