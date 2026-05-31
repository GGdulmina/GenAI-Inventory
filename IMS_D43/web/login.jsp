<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login – Smart IMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <style>
        * { font-family: 'Inter', sans-serif; }
        body {
            min-height: 100vh;
            background: linear-gradient(135deg, #0f0c29 0%, #302b63 50%, #24243e 100%);
            display: flex; align-items: center; justify-content: center;
        }
        .login-card {
            background: rgba(255,255,255,0.06);
            backdrop-filter: blur(24px);
            border: 1px solid rgba(255,255,255,0.12);
            border-radius: 20px;
            padding: 48px 40px;
            width: 100%; max-width: 420px;
            box-shadow: 0 32px 64px rgba(0,0,0,0.4);
        }
        .login-card h2 {
            color: #fff; font-weight: 700; font-size: 1.8rem;
            margin-bottom: 8px;
        }
        .login-card .subtitle { color: rgba(255,255,255,0.55); margin-bottom: 32px; }
        .form-control {
            background: rgba(255,255,255,0.08);
            border: 1px solid rgba(255,255,255,0.15);
            color: #fff; border-radius: 12px; padding: 14px 16px;
            font-size: 0.95rem;
        }
        .form-control:focus {
            background: rgba(255,255,255,0.12);
            border-color: #7c5cfc; color: #fff;
            box-shadow: 0 0 0 3px rgba(124,92,252,0.25);
        }
        .form-control::placeholder { color: rgba(255,255,255,0.4); }
        .form-label { color: rgba(255,255,255,0.7); font-weight: 500; font-size: 0.85rem; }
        .btn-login {
            background: linear-gradient(135deg, #7c5cfc, #a855f7);
            border: none; border-radius: 12px; padding: 14px;
            font-weight: 600; font-size: 1rem; color: #fff;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 24px rgba(124,92,252,0.4);
            color: #fff;
        }
        .brand-icon {
            width: 56px; height: 56px; border-radius: 16px;
            background: linear-gradient(135deg, #7c5cfc, #a855f7);
            display: flex; align-items: center; justify-content: center;
            margin-bottom: 20px; font-size: 1.5rem; color: #fff;
        }
        .alert { border-radius: 12px; }
        .demo-creds {
            background: rgba(255,255,255,0.06);
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 12px; padding: 16px;
            margin-top: 24px; color: rgba(255,255,255,0.6);
            font-size: 0.8rem;
        }
        .demo-creds strong { color: rgba(255,255,255,0.85); }
    </style>
</head>
<body>
<div class="login-card">
    <div class="brand-icon"><i class="bi bi-box-seam-fill"></i></div>
    <h2>GenAI-Inventory</h2>
    <p class="subtitle">Inventory Management System with AI Insights</p>

    <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-danger py-2 px-3">
            <i class="bi bi-exclamation-triangle me-1"></i> ${error}
        </div>
    <% } %>

    <form method="post" action="login">
        <div class="mb-3">
            <label class="form-label">Username</label>
            <input type="text" class="form-control" name="username" placeholder="Enter username" required autofocus>
        </div>
        <div class="mb-4">
            <label class="form-label">Password</label>
            <input type="password" class="form-control" name="password" placeholder="Enter password" required>
        </div>
        <button type="submit" class="btn btn-login w-100">
            <i class="bi bi-box-arrow-in-right me-1"></i> Sign In
        </button>
    </form>

    <div class="demo-creds">
        <strong>Demo Credentials</strong><br>
        Admin: <code>admin / admin123</code><br>
        Staff: <code>staff / staff123</code>
    </div>
</div>
</body>
</html>