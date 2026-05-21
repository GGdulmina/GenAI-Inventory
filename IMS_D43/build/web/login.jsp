<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Inventory Login</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f0f2f5; 
               display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .card { background: white; padding: 2rem; border-radius: 8px; 
                box-shadow: 0 2px 10px rgba(0,0,0,0.1); width: 320px; }
        input { width: 100%; padding: 10px; margin: 8px 0; border: 1px solid #ddd; 
                border-radius: 4px; box-sizing: border-box; }
        button { width: 100%; padding: 10px; background: #3B7DD8; color: white; 
                 border: none; border-radius: 4px; cursor: pointer; font-size: 15px; }
        .error { color: red; font-size: 13px; }
    </style>
</head>
<body>
<div class="card">
    <h2>Inventory Login</h2>
    <% if (request.getAttribute("error") != null) { %>
        <p class="error">${error}</p>
    <% } %>
    <form method="post" action="login">
        <input type="text" name="username" placeholder="Username" required/>
        <input type="password" name="password" placeholder="Password" required/>
        <button type="submit">Log in</button>
    </form>
</div>
</body>
</html>