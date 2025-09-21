<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>Payment Success - CampusEats</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f7f7f7; margin: 0; padding: 0; }
        .container { width: 50%; margin: 100px auto; background: #fff; padding: 30px; border-radius: 12px; text-align: center; box-shadow: 0 0 15px rgba(0,0,0,0.1); }
        .heading { background-color: maroon; color: white; padding: 15px; font-size:1.5em; border-radius:8px; margin-bottom: 20px; }
        p { font-size: 1.1em; margin: 10px 0; }
        .back-link { display: inline-block; margin-top: 20px; text-decoration: none; color: white; background-color: maroon; padding: 8px 15px; border-radius: 6px; transition: 0.3s; }
        .back-link:hover { background-color: darkred; }
    </style>
</head>
<body>
<div class="container">
    <div class="heading">Payment Success</div>
    <p>Order ID: <b><%= session.getAttribute("lastOrderId") %></b></p>
    <p>Total Amount: <b><%= session.getAttribute("lastOrderTotal") %> rs</b></p>
    <p>Payment Status: <b><%= session.getAttribute("lastPaymentStatus") %></b></p>
    <a href="menu" class="back-link">Back to Menu</a>
</div>
</body>
</html>
