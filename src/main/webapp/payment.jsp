<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>Payment Success</title>
    <style>
        body { font-family: Arial; background: #f7f7f7; text-align: center; padding-top: 50px; }
        .success-box { background: #fff; padding: 30px; display: inline-block; border-radius: 12px; box-shadow: 0 0 15px rgba(0,0,0,0.1); }
        .success-box h1 { color: green; }
        .btn { padding: 8px 16px; border-radius: 6px; background-color: maroon; color: white; text-decoration: none; display: inline-block; margin-top: 20px; }
        .btn:hover { background-color: darkred; }
    </style>
</head>
<body>
    <div class="success-box">
        <h1>Payment Successful</h1>
        <%
            String method = (String) session.getAttribute("paymentMethod");
            String amount = (String) session.getAttribute("amountPaid");
            String orderId = (String) session.getAttribute("orderId");

            if(method != null && amount != null && orderId != null){
        %>
            <p>Payment Method: <b><%= method %></b></p>
            <p>Amount Paid: <b><%= amount %></b></p>
            <%
                if("Cash".equalsIgnoreCase(method)) {
            %>
                <p>Your Order ID: <b><%= orderId %></b> (Cash on Delivery)</p>
            <%
                } else {
            %>
                <p>Your Transaction ID: <b><%= orderId %></b></p>
            <%
                }
            %>
        <%
            } else {
        %>
            <p>Payment information not available</p>
        <%
            }
        %>
        <a href="menu" class="btn">Back to Menu</a>
    </div>
</body>
</html>
