<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, com.campuseats.MenuItem" %>
<!DOCTYPE html>
<html>
<head>
    <title>CampusEats - Menu</title>
    <style>
        body { font-family: Arial; margin: 20px; background: #fff; }
        h1 { color: maroon; }
        h2 { color: maroon; text-transform: capitalize; } /* Capitalize category names */

        .category { margin-bottom: 40px; }
        
        .scroll-container {
            display: flex;
            overflow-x: auto;
            scroll-behavior: smooth;
            gap: 15px;
            padding-bottom: 10px;
        }

        .scroll-container::-webkit-scrollbar {
            display: none; /* Hide scrollbar */
        }

        .item {
            flex: 0 0 auto;
            border: 1px solid #ccc;
            padding: 10px;
            width: 200px;
            text-align: center;
            border-radius: 8px;
            background: #fafafa;
            box-shadow: 0px 2px 5px rgba(0,0,0,0.1);
        }

        .item img { width: 150px; height: 120px; object-fit: cover; border-radius: 4px; }
        .item b { display: block; margin-top: 8px; color: maroon; }

        button {
            background: maroon; 
            color: white; 
            padding: 6px 12px; 
            border: none; 
            border-radius: 4px; 
            cursor: pointer;
            margin-top: 10px;
        }
        button:hover { background: darkred; }
    </style>
</head>
<body>

<h1>CampusEats Menu</h1>
<a href="cart.jsp" style="color: maroon; font-weight: bold;">🛒 View Cart</a>
<hr/>

<%
    Map<String, List<MenuItem>> menuByCategory = 
        (Map<String, List<MenuItem>>) request.getAttribute("menuByCategory");

    if (menuByCategory != null) {
        for (String category : menuByCategory.keySet()) {
%>
    <div class="category">
        <h2><%= category %></h2>
        <div class="scroll-container">
        <%
            for (MenuItem item : menuByCategory.get(category)) {
        %>
            <div class="item">
   <img src="images/menu/<%= item.getImage() %>" alt="<%= item.getName() %>"
     onerror="this.onerror=null;this.src='images/menu/placeholder.jpg';"/>

    <b><%= item.getName() %></b>
    <b><%= item.getPrice() %> rs</b>
    <form action="addToCart" method="post">
        <input type="hidden" name="id" value="<%= item.getId() %>"/>
        <input type="hidden" name="name" value="<%= item.getName() %>"/>
        <input type="hidden" name="price" value="<%= item.getPrice() %>"/>
        <button type="submit">Add to Cart</button>
    </form>
</div>

        <% } %>
        </div>
    </div>
<%
        }
    }
%>

<script>
    // Auto-scroll effect for each category row
    document.querySelectorAll('.scroll-container').forEach(container => {
        let scrollAmount = 0;
        setInterval(() => {
            container.scrollBy({ left: 210, behavior: 'smooth' });
            scrollAmount += 210;
            if (scrollAmount >= container.scrollWidth - container.clientWidth) {
                container.scrollTo({ left: 0, behavior: 'smooth' });
                scrollAmount = 0;
            }
        }, 3000); // change every 3 seconds
    });
</script>

</body>
</html>
