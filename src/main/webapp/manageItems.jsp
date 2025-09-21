<%@ page import="java.util.*, com.campuseats.MenuItem" %>
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
    <title>Manage Menu Items - CampusEats</title>
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
        img { width:80px; height:60px; object-fit:cover; border-radius:4px; }
    </style>
</head>
<body>
<div class="container">
<h1 class="block-heading">Manage Menu Items</h1>

<%
List<MenuItem> items = (List<MenuItem>) request.getAttribute("items");
if (items != null && !items.isEmpty()) {
%>
<table>
    <tr>
        <th>ID</th>
        <th>Image</th>
        <th>Name</th>
        <th>Category</th>
        <th>Price Rs</th>
        <th>Available</th>
        <th>Action</th>
    </tr>
<% for (MenuItem item : items) { %>
    <tr>
        <td><%= item.getId() %></td>
        <td><img src="images/menu/<%= item.getImages() %>" 
                 onerror="this.onerror=null;this.src='images/menu/placeholder.jpg';"/></td>
        <td><%= item.getItemName() %></td>
        <td><%= item.getCategory() %></td>
        <td><%= item.getPrice() %></td>
        <td><%= item.isAvailable() ? "Yes" : "No" %></td>
        <td>
            <form action="manageItemsServlet" method="post">
                <input type="hidden" name="itemId" value="<%= item.getId() %>"/>
                <select name="available">
                    <option value="true" <%= item.isAvailable()?"selected":"" %>>Yes</option>
                    <option value="false" <%= !item.isAvailable()?"selected":"" %>>No</option>
                </select>
                <button type="submit">Update</button>
            </form>
        </td>
    </tr>
<% } %>
</table>
<% } else { %>
<p>No menu items found.</p>
<% } %>

<div style="text-align:center;">
    <a href="staffDashboard.jsp" class="back-link">Back to Dashboard</a>
</div>
</div>
</body>
</html>
