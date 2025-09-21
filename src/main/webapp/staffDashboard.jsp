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
    <title>Staff Dashboard - CampusEats</title>
    <style>
        body { font-family: Arial; background: #f7f7f7; margin:0; padding:0; }
        .container { width:90%; margin:40px auto; background:#fff; padding:20px; border-radius:12px; box-shadow:0 0 15px rgba(0,0,0,0.1);}
        h1.block-heading { background:maroon; color:white; padding:15px; border-radius:8px; text-align:center; margin-bottom:20px;}
        .dashboard-options { display:flex; flex-wrap:wrap; gap:20px; justify-content:center; }
        .card { flex:0 0 250px; background:#fafafa; border:1px solid #ccc; border-radius:8px; padding:20px; text-align:center; box-shadow:0px 2px 5px rgba(0,0,0,0.1);}
        .card h2 { color:maroon; margin-bottom:15px; font-size:1.2em; }
        .card a { display:inline-block; background:maroon; color:white; padding:8px 15px; text-decoration:none; border-radius:6px; transition:0.3s; }
        .card a:hover { background:darkred; }
       
          .cart-link { display:inline-block; margin-bottom:15px; text-decoration:none; color:white; background:maroon; padding:8px 12px; border-radius:6px; }
        .cart-link:hover { background:darkred; } #notifications { margin-top:30px; text-align:center; color:green; font-weight:bold; font-size:1.1em; }
    </style>
</head>
<body>

<div class="container">

    <h1 class="block-heading">Staff Dashboard</h1>
<a href="index.jsp" class="cart-link">Logout</a>
    <div class="dashboard-options">
        <div class="card">
            <h2>Manage Orders</h2>
            <p>View all orders and update order status</p>
            <a href="manageOrdersServlet">Go</a>
        </div>
        <div class="card">
            <h2>Manage Menu Items</h2>
            <p>Mark items as unavailable or available</p>
            <a href="manageItemsServlet">Go</a>
        </div>
        <div class="card">
            <h2>Notifications</h2>
            <p>Check new order notifications</p>
            <div id="notifications">No new orders</div>
        </div>
    </div>
</div>

<script>
function checkNotifications() {
    fetch('<%= request.getContextPath() %>/checkNewOrdersPlain') // a servlet returning plain text like "New order(s) received!"
        .then(resp => resp.text())
        .then(text => {
            let notifDiv = document.getElementById("notifications");
            if (text.trim() !== "") {
                notifDiv.innerText = text; // show new notification
                notifDiv.style.color = "red"; // highlight new orders
            } else {
                notifDiv.innerText = "No new orders";
                notifDiv.style.color = "green";
            }
        })
        .catch(err => console.error(err));
}

// check every 10 seconds
setInterval(checkNotifications, 10000);
</script>

</body>
</html>
