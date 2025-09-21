<%@ page import="java.sql.*" %>
<%
    int userId = 1; // TODO: replace with logged-in user
    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;
%>
<!DOCTYPE html>
<html>
<head>
    <title>My Orders</title>
    <style>
        body { font-family: Arial; margin:20px; }
        table { width: 80%; border-collapse: collapse; }
        th, td { border:1px solid #ddd; padding:10px; text-align:center; }
        th { background: maroon; color:white; }
    </style>
</head>
<body>
    <h1>My Orders</h1>
    <table>
        <tr>
            <th>Order ID</th><th>Total Amount</th><th>Payment Method</th><th>Status</th><th>Date</th>
        </tr>
        <%
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/campuseats", "root", "password");
                stmt = conn.createStatement();
                rs = stmt.executeQuery("SELECT * FROM orders WHERE user_id=" + userId + " ORDER BY order_date DESC");

                while (rs.next()) {
        %>
        <tr>
            <td><%= rs.getInt("order_id") %></td>
            <td>₹<%= rs.getDouble("total_amount") %></td>
            <td><%= rs.getString("payment_method") %></td>
            <td><%= rs.getString("status") %></td>
            <td><%= rs.getTimestamp("order_date") %></td>
        </tr>
        <%      }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                try { if (rs != null) rs.close(); } catch (Exception ignored) {}
                try { if (stmt != null) stmt.close(); } catch (Exception ignored) {}
                try { if (conn != null) conn.close(); } catch (Exception ignored) {}
            }
        %>
    </table>
</body>
</html>
