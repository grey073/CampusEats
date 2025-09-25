<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, com.campuseats.MenuItem" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>CampusEats - Menu</title>
    <style>
        body { font-family: Arial; background: #f7f7f7; margin:0; padding:0; }
        .container { width:90%; margin:40px auto; background:#fff; padding:20px; border-radius:12px; box-shadow:0 0 15px rgba(0,0,0,0.1);}
        h1.block-heading { background:maroon; color:white; padding:15px; border-radius:8px; text-align:center; margin-bottom:20px;}
        h2 { color: maroon; text-transform: capitalize; margin: 20px 0 10px; }
        .category { margin-bottom: 40px; }
        .scroll-container { display:flex; overflow-x:auto; gap:15px; padding-bottom:10px; scroll-behavior:smooth;}
        .scroll-container::-webkit-scrollbar { display:none; }
        .item { flex:0 0 auto; border:1px solid #ccc; padding:10px; width:200px; text-align:center; border-radius:8px; background:#fafafa; box-shadow:0px 2px 5px rgba(0,0,0,0.1);}
        .item img { width:150px; height:120px; object-fit:cover; border-radius:4px; }
        .item b { display:block; margin-top:8px; color:maroon; }
        button { background:maroon; color:white; padding:6px 12px; border:none; border-radius:4px; cursor:pointer; margin-top:10px; }
        button:hover { background:darkred; }
        .cart-link { display:inline-block; margin-bottom:15px; text-decoration:none; color:white; background:maroon; padding:8px 12px; border-radius:6px; }
        .cart-link:hover { background:darkred; }
    </style>
</head>
<body>
<div class="container">
<h1 class="block-heading">CampusEats Menu</h1>
<a href="cart.jsp" class="cart-link"> View Cart</a>
<a href="<%= request.getContextPath() %>/OrderSummaryServlet" class="cart-link">My Orders</a>
<a href="index.jsp" class="cart-link">Logout</a>

<%
Map<String, List<MenuItem>> menuByCategory = (Map<String, List<MenuItem>>) request.getAttribute("menuByCategory");
if (menuByCategory != null) {
    for (String category : menuByCategory.keySet()) {
%>
<div class="category">
    <h2><%= category %></h2>
    <div class="scroll-container">
    <%
        for (MenuItem item : menuByCategory.get(category)) {
            if (!item.isAvailable()) continue; // skip unavailable items
    %>
    <div class="item">
        <img src="images/menu/<%= item.getImages() %>" alt="<%= item.getItemName() %>"
             onerror="this.onerror=null;this.src='images/menu/placeholder.jpg';"/>
        <b><%= item.getItemName() %></b>
        <b><%= item.getPrice() %> rs</b>
        <form action="addToCart" method="post">
            <input type="hidden" name="id" value="<%= item.getId() %>"/>
            <input type="hidden" name="name" value="<%= item.getItemName() %>"/>
            <input type="hidden" name="price" value="<%= item.getPrice() %>"/>
            <input type="hidden" name="image" value="<%= item.getImages() %>"/>
            <button type="submit">Add to Cart</button>
        </form>
    </div>
    <% } %>
    </div>
</div>
<% } } %>

<script>
document.querySelectorAll('.scroll-container').forEach(container => {
    let scrollAmount = 0;
    setInterval(() => {
        container.scrollBy({ left: 240, behavior: 'smooth' });
        scrollAmount += 220;
        if (scrollAmount >= container.scrollWidth - container.clientWidth) {
            container.scrollTo({ left: 0, behavior: 'smooth' });
            scrollAmount = 0;
        }
    }, 3000);
});
</script>
</div>
</body>
</html>
