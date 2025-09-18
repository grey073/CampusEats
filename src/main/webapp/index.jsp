<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>CampusEats Login</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    <style>
        /* Reset and body styling */
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            height: 100vh;
            font-family: 'Poppins', sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            background: url("images/bg.jpg") no-repeat center center fixed;
            background-size: cover;
        }
        .overlay {
            position: absolute;
            top:0; left:0; width:100%; height:100%;
            background: rgba(0,0,0,0.4);
            backdrop-filter: blur(2px);
            z-index: 0;
        }

        /* Login box */
        .login-box {
            position: relative;
            z-index: 1;
            background: #fff;
            border-radius: 12px;
            padding: 40px 30px;
            width: 320px;
            max-width: 90%;
            box-shadow: 0 6px 20px rgba(0,0,0,0.3);
            text-align: center;
            color: #333;
        }
        .login-box h2 {
            font-size: 24px;
            margin-bottom: 20px;
            color: #660505;
        }
        .login-box input {
            width: 100%;
            padding: 12px;
            margin: 10px 0;
            border: 1px solid #ccc;
            border-radius: 8px;
            font-size: 14px;
            outline: none;
            transition: border 0.3s;
        }
        .login-box input:focus {
            border-color: #660505;
        }
        .login-box button {
            width: 100%;
            padding: 12px;
            margin-top: 15px;
            border: none;
            border-radius: 8px;
            background-color: #660505;
            color: #fff;
            font-weight: 600;
            font-size: 15px;
            cursor: pointer;
            transition: background 0.3s;
        }
        .login-box button:hover {
            background-color: #a83232;
        }

        /* Error message */
        .error {
            color: red;
            font-size: 13px;
            margin-bottom: 10px;
        }

        /* Signup link */
        .login-box p {
            margin-top: 15px;
            font-size: 13px;
            color: #333;
        }
        .login-box p a {
            color: #660505;
            text-decoration: none;
            font-weight: 600;
        }
        .login-box p a:hover {
            text-decoration: underline;
        }

        /* Responsive */
        @media(max-width:400px){
            .login-box { padding: 25px 20px; }
            .login-box h2 { font-size: 20px; }
        }
    </style>
</head>
<body>
    <div class="overlay"></div>

    <div class="login-box">
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
</body>
</html>
