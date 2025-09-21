<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>CampusEats</title>
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap" rel="stylesheet">
<style>
    * { margin:0; padding:0; box-sizing:border-box; }
    body, html { width:100%; height:100%; font-family:'Poppins', sans-serif; overflow:hidden; }

    /* Background layers */
    .bg-layer {
        position: fixed;
        top:0; left:0; width:100%; height:100%;
        background-size: cover;
        background-position: center;
        filter: blur(2px);
        z-index: 0;
        transition: opacity 0.8s ease;
    }
    #bgIntro { background-image: url('<%=request.getContextPath()%>/images/b.jpg'); opacity:1; }
    #bgLogin { background-image: url('<%=request.getContextPath()%>/images/bg.jpg'); opacity:0; }

    /* Intro content */
    .intro-container {
        position: relative; z-index:1;
        width:100%; height:100%;
        display:flex; justify-content:center; align-items:center;
        flex-direction: row; gap:20px;
        cursor:pointer;
        transition: transform 0.8s ease;
    }
    .logo { width:90px; height:90px; opacity:0; animation: logoFadeIn 1.2s ease forwards; }
    .text-container { display:flex; flex-direction:column; justify-content:center; align-items:flex-start; }
    .site-name { color:#800020; font-size:3em; font-weight:700; opacity:0; transform: translateX(-50px); animation: nameSlideIn 1.5s ease forwards 1.2s; }
    .slogan { color:#800020; font-size:1.2em; font-weight:600; margin-top:5px; opacity:0; transform: translateX(-30px); animation: sloganSlideIn 1.2s ease forwards 2.7s; }

    @keyframes logoFadeIn { 0% {opacity:0; transform:scale(0.5);} 100% {opacity:1; transform:scale(1);} }
    @keyframes nameSlideIn { 0% {opacity:0; transform:translateX(-50px);} 100% {opacity:1; transform:translateX(0);} }
    @keyframes sloganSlideIn { 0% {opacity:0; transform:translateX(-30px);} 100% {opacity:1; transform:translateX(0);} }

    /* Slide intro up */
    .slide-up { transform: translateY(-100%); }

    /* Login form */
    .login-box {
        position: absolute; top:50%; left:50%;
        transform: translate(-50%, -50%);
        z-index:1;
        background: rgba(255,255,255,0.95);
        border-radius:12px;
        padding:40px 30px;
        width:320px; max-width:90%;
        box-shadow:0 6px 20px rgba(0,0,0,0.3);
        text-align:center;
        display:none;
    }
    .login-box h2 { font-size:26px; font-weight:700; margin-bottom:20px; color:#660505; }
    .login-box input { width:100%; padding:12px; margin:10px 0; border:1px solid #ccc; border-radius:8px; font-size:14px; outline:none; transition:border 0.3s; }
    .login-box input:focus { border-color:#660505; }
    .login-box button { width:100%; padding:12px; margin-top:15px; border:none; border-radius:8px; background-color:#660505; color:#fff; font-weight:600; font-size:15px; cursor:pointer; transition:0.3s; }
    .login-box button:hover { background-color:#a83232; }
    .login-box .error { color:red; font-size:13px; margin-bottom:10px; }
    .login-box p { margin-top:15px; font-size:13px; color:#333; }
    .login-box p a { color:#660505; text-decoration:none; font-weight:600; }
    .login-box p a:hover { text-decoration:underline; }

    @media(max-width:400px){ .login-box { padding:25px 20px; } .login-box h2 { font-size:20px; } }
</style>
</head>
<body>

<!-- Backgrounds -->
<div class="bg-layer" id="bgIntro"></div>
<div class="bg-layer" id="bgLogin"></div>

<!-- Intro -->
<div class="intro-container" id="introContainer">
    <div class="logo">
        <svg width="100%" height="100%" viewBox="0 0 48 48" fill="none" xmlns="http://www.w3.org/2000/svg">
          <circle cx="24" cy="24" r="22" fill="#800020" stroke="#600018" stroke-width="2"/>
          <path d="M12 20L24 16L36 20L24 24L12 20Z" fill="#FFF"/>
          <path d="M33 21V26C33 27.1 28.97 28 24 28C19.03 28 15 27.1 15 26V21" stroke="#FFF" stroke-width="1.5" fill="none"/>
          <rect x="35" y="19" width="2" height="8" fill="#FFF"/>
          <circle cx="36" cy="18" r="1" fill="#FFF"/>
          <g transform="translate(18, 30)">
            <path d="M2 2V12M0 2V6M4 2V6M2 6V8" stroke="#FFF" stroke-width="1.2" stroke-linecap="round"/>
            <path d="M8 2V12M8 2L10 4V6L8 6" stroke="#FFF" stroke-width="1.2" stroke-linecap="round" stroke-linejoin="round"/>
          </g>
        </svg>
    </div>
    <div class="text-container">
        <div class="site-name">CampusEats</div>
        <div class="slogan">Bringing the canteen to your fingertips</div>
    </div>
</div>

<!-- Login -->
<div class="login-box" id="loginBox">
    <h2>CampusEats</h2>
    <% if(request.getParameter("error") != null) { %>
        <div class="error">Invalid username or password</div>
    <% } %>
    <form action="LoginServlet" method="post">
        <input type="text" name="username" placeholder="Enter Username" required>
        <input type="password" name="password" placeholder="Enter Password" required>
        <button type="submit">Login</button>
    </form>
    <p>Not registered? <a href="signup.jsp">Sign up here</a></p>
</div>

<script>
function goToLogin() {
    const intro = document.getElementById('introContainer');
    const login = document.getElementById('loginBox');
    const bgIntro = document.getElementById('bgIntro');
    const bgLogin = document.getElementById('bgLogin');

    // Slide intro up
    intro.classList.add('slide-up');

    // Fade background
    bgIntro.style.opacity = 0;
    bgLogin.style.opacity = 1;

    // Show login after animation
    setTimeout(()=>{
        intro.style.display='none';
        login.style.display='block';
    }, 800);
}
</script>

<!-- Click anywhere to go to login -->
<body onclick="goToLogin()"></body>

</body>
</html>
