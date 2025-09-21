<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, com.campuseats.CartItem" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Order Summary - CampusEats</title>
    <style>
        body { font-family: Arial, sans-serif; background:#fff; color:#222; margin:20px; }
        h1 { color: maroon; }
        table { width: 80%; border-collapse: collapse; margin: 20px auto; }
        th, td { padding: 10px; border: 1px solid #ccc; text-align: center; }
        th { background: maroon; color: white; }
        .total { font-weight: bold; font-size: 18px; color: maroon; }
        .btn { background: maroon; color: white; padding: 10px 20px; border: none; cursor: pointer; margin-top: 20px; }
        .btn:hover { background: #4b0000; }
    </style>
</head>
<body>
    <h1 align="center">Order Summary</h1>

    <%
        List<CartItem> cart = (List<CartItem>) request.getAttribute("cart");
        double grandTotal = 0;
    %>

    <table>
        <tr>
            <th>Item</th>
            <th>Price (₹)</th>
            <th>Quantity</th>
            <th>Total (₹)</th>
        </tr>

        <%
            if (cart != null) {
                for (CartItem item : cart) {
                    double total = item.getTotalPrice();
                    grandTotal += total;
        %>
        <tr>
            <td><%= item.getName() %></td>
            <td><%= item.getPrice() %></td>
            <td><%= item.getQuantity() %></td>
            <td><%= total %></td>
        </tr>
        <%      }
            }
        %>

        <tr>
            <td colspan="3" class="total">Grand Total</td>
            <td class="total"><%= grandTotal %></td>
        </tr>
    </table>

    <div style="text-align:center;">
        <form action="payment.jsp" method="post">
            <input type="hidden" name="amount" value="<%= grandTotal %>">
            <button type="submit" class="btn">Proceed to Payment</button>
        </form>
    </div>
</body>
</html>
