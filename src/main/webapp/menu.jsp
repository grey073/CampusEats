<%@ page import="java.util.*,com.campuseats.MenuItem" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>CampusEats - Menu</title>
  <style>
    body { margin:0; font-family: Arial, sans-serif; background:#fff; color:#222; }
    .hero { padding: 30px 40px; text-align:center; background: #660505; }
    .hero h1 { margin:0; font-size: 32px; color:#fff; }
    .hero p { color:#f0f0f0; margin-top:8px; }

    .container { padding: 20px 40px; }

    .category { margin: 28px 0; }
    .category-header {
      display:flex; align-items:center; justify-content:space-between; margin-bottom:12px;
    }
    .category-header h2 { margin:0; font-size:20px; color:#660505; letter-spacing:0.5px; }
    .category-header a { color:#660505; text-decoration:none; font-weight:bold; }

    .row { position: relative; }
    .track {
      display:flex; gap: 14px; overflow-x: auto;
      scroll-behavior: smooth; padding: 8px 4px;
    }
    .track::-webkit-scrollbar { height: 6px; }
    .track::-webkit-scrollbar-thumb { background: #800000; border-radius:4px; }

    .card {
      min-width: 220px; background: #fafafa; border-radius: 10px;
      padding: 12px; text-align:center; color: #222;
      border: 1px solid #ddd; box-shadow: 0 3px 8px rgba(0,0,0,0.1);
    }
    .card img { width:100%; height:120px; object-fit:cover; border-radius:6px; margin-bottom:8px; }
    .card .name { font-weight:600; margin-bottom:6px; color:#333; }
    .card .price { color:#800000; margin-bottom:8px; font-weight:bold; }
    .card button {
      padding:8px 12px; border: none; border-radius:6px; cursor:pointer;
      background: #800000; color:#fff; font-weight:600;
      transition: background 0.3s;
    }
    .card button:hover { background:#5a0000; }

    .nav-btn {
      position:absolute; top:50%; transform: translateY(-50%);
      width:34px; height:34px; border-radius:50%; border:none;
      background:#800000; color:#fff; cursor:pointer; z-index:2;
      font-size:16px; font-weight:bold;
    }
    .nav-left { left:-18px; }
    .nav-right { right:-18px; }

    @media (max-width:700px){
      .card { min-width:160px; }
      .nav-left, .nav-right { display:none; }
    }

    .toast {
      position: fixed; right: 24px; bottom: 24px;
      background: #800000; color:#fff;
      padding:10px 14px; border-radius:8px; display:none;
      box-shadow: 0 2px 8px rgba(0,0,0,0.3);
   }
  </style>
</head>
<body>
  <div class="hero">
    <h1>CampusEats - Menu</h1>
    <p>Tap items to add to cart. Checkout from Cart.</p>
  </div>

  <div class="container">
    <%
      Map menuByCategory = (Map) request.getAttribute("menuByCategory");
      if (menuByCategory == null) {
    %>
      <p>No menu available.</p>
    <%
      } else {
        for (Object catObj : menuByCategory.keySet()) {
          String category = (String) catObj;
          List items = (List) menuByCategory.get(category);
    %>
      <div class="category">
        <div class="category-header">
          <h2><%= category.substring(0,1).toUpperCase() + category.substring(1).toLowerCase() %></h2>
          <div><a href="cart.jsp">Cart</a></div>
        </div>

        <div class="row">
          <button class="nav-btn nav-left" data-target="track-<%=category.replaceAll("\\s+","-")%>">&#9664;</button>
          <div id="track-<%=category.replaceAll("\\s+","-")%>" class="track">
            <%
              if (items != null) {
                 for (Object o : items) {
                    MenuItem m = (MenuItem) o;
            %>
              <div class="card">
                <img src="images/menu/<%= m.getImage() != null ? m.getImage() : "placeholder.jpg" %>" alt="<%= m.getName() %>"/>
                <div class="name"><%= m.getName() %></div>
                <div class="price"><%= String.format("%.2f rs", m.getPrice()) %></div>
                <button onclick="addToCart(<%= m.getId() %>)">Add to Cart</button>
              </div>
            <%
                 }
              }
            %>
          </div>
          <button class="nav-btn nav-right" data-target="track-<%=category.replaceAll("\\s+","-")%>">&#9654;</button>
        </div>
      </div>
    <%
        }
      }
    %>
  </div>

  <div class="toast" id="toast">Added to cart</div>

  <script>
    // slide buttons
    document.querySelectorAll('.nav-btn').forEach(btn=>{
      btn.addEventListener('click', ()=>{
        const id = btn.getAttribute('data-target');
        const track = document.getElementById(id);
        const amount = track.clientWidth * 0.6;
        if (btn.classList.contains('nav-left')) track.scrollBy({left: -amount, behavior:'smooth'});
        else track.scrollBy({left: amount, behavior:'smooth'});
      });
    });

    // auto scrolling
    document.querySelectorAll('.track').forEach(track => {
      let direction = 1;
      let step = track.clientWidth * 0.6;
      setInterval(() => {
        if (track.scrollLeft + track.clientWidth >= track.scrollWidth) {
          direction = -1;
        } else if (track.scrollLeft <= 0) {
          direction = 1;
        }
        track.scrollBy({ left: step * direction, behavior:'smooth' });
      }, 4000);
    });

    // Toast
    function showToast(msg){
      const t = document.getElementById('toast');
      t.textContent = msg;
      t.style.display = 'block';
      setTimeout(()=> t.style.display = 'none', 1500);
    }

    // Add to cart
    function addToCart(itemId){
      fetch('add-to-cart', {
        method:'POST',
        headers: {'Content-Type':'application/x-www-form-urlencoded'},
        body: 'itemId=' + encodeURIComponent(itemId) + '&qty=1'
      })
      .then(resp => resp.text())
      .then(txt => {
         if (txt.trim() === 'OK') showToast('Added to cart');
         else showToast('Error');
      })
      .catch(err => showToast('Error'));
    }
  </script>
</body>
</html> 