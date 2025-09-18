<%@ page import="java.util.*, com.campuseats.CartItem" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Your Cart - CampusEats</title>
  <style>
    body { font-family: Arial, sans-serif; padding: 20px; }
    h1 { color: #660505; }
    table { width:100%; border-collapse: collapse; margin-top:20px; }
    th, td { padding:10px; border:1px solid #ccc; text-align:center; }
    th { background:#660505; color:#fff; }
    .total { font-weight:bold; }
    .btn { padding:6px 12px; background:#800000; color:#fff; border:none; cursor:pointer; border-radius:4px; }
    .btn:hover { background:#5a0000; }
  </style>
</head>
<body>
  <h1>Your Cart</h1>

  <%
    Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
    if (cart == null || cart.isEmpty()) {
  %>
    <p>Your cart is empty.</p>
  <%
    } else {
      double grandTotal = 0;
  %>
    <table>
      <tr>
        <th>Item</th>
        <th>Price</th>
        <th>Quantity</th>
        <th>Total</th>
      </tr>
      <%
        for (CartItem ci : cart.values()) {
            double total = ci.getTotalPrice();
            grandTotal += total;
      %>
      <tr>
        <td><%= ci.getItem().getName() %></td>
        <td><%= String.format("%.2f rs", ci.getItem().getPrice()) %></td>
        <td><%= ci.getQuantity() %></td>
        <td><%= String.format("%.2f rs", total) %></td>
      </tr>
      <%
        }
      %>
      <tr class="total">
        <td colspan="3">Grand Total</td>
        <td><%= String.format("%.2f rs", grandTotal) %></td>
      </tr>
    </table>

    <form action="checkout" method="post">
      <button class="btn" type="submit">Checkout</button>
    </form>
  <%
    }
  %>
</body>
</html>
