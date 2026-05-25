<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AI Insights – Smart IMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <style>
        * { font-family: 'Inter', sans-serif; }
        body { background: #0f1117; color: #e1e4e8; min-height: 100vh; }
        
        /* ── Sidebar ── */
        .sidebar {
            width: 260px; background: #161b22; min-height: 100vh; padding: 24px 16px;
            position: fixed; left: 0; top: 0; z-index: 100;
            border-right: 1px solid rgba(255,255,255,0.06);
        }
        .sidebar .brand { display: flex; align-items: center; gap: 12px; margin-bottom: 32px; padding: 0 8px; }
        .sidebar .brand-icon {
            width: 40px; height: 40px; border-radius: 12px;
            background: linear-gradient(135deg, #7c5cfc, #a855f7);
            display: flex; align-items: center; justify-content: center;
            font-size: 1.1rem; color: #fff;
        }
        .sidebar .brand span { font-weight: 700; font-size: 1.1rem; color: #fff; }
        .sidebar .nav-link {
            color: rgba(255,255,255,0.55); border-radius: 10px; padding: 10px 14px;
            margin-bottom: 4px; font-size: 0.9rem; font-weight: 500;
            transition: all 0.2s;
        }
        .sidebar .nav-link:hover, .sidebar .nav-link.active {
            background: rgba(124,92,252,0.15); color: #a78bfa;
        }
        .sidebar .nav-link i { margin-right: 10px; font-size: 1rem; }
        
        /* ── Main content ── */
        .main-content { margin-left: 260px; padding: 32px; }
        .page-header { margin-bottom: 32px; }
        .page-header h1 { font-weight: 700; font-size: 1.6rem; color: #fff; margin-bottom: 4px; }
        .page-header p { color: rgba(255,255,255,0.45); font-size: 0.9rem; margin: 0; }
        
        /* ── Card Styles ── */
        .insight-card {
            background: #161b22; border: 1px solid rgba(255,255,255,0.06);
            border-radius: 16px; padding: 24px; height: 100%;
        }
        .insight-card h6 { color: #fff; font-weight: 600; margin-bottom: 20px; display: flex; align-items: center; gap: 8px; }
        
        /* ── Lists ── */
        .product-list { list-style: none; padding: 0; margin: 0; }
        .product-list li {
            padding: 12px 14px; border-bottom: 1px solid rgba(255,255,255,0.04);
            font-size: 0.88rem; display: flex; justify-content: space-between; align-items: center;
        }
        .product-list li:last-child { border-bottom: none; }
        .badge-sales { background: rgba(124,92,252,0.15); color: #a78bfa; font-weight: 600; padding: 4px 8px; border-radius: 6px; }
        
        /* ── System Alerts ── */
        .alert-container h5 { color: #fff; font-weight: 600; margin-bottom: 16px; }
        .alert-item {
            background: rgba(255,255,255,0.03); border-radius: 12px;
            padding: 14px 18px; margin-bottom: 10px;
            border-left: 4px solid; font-size: 0.88rem;
            display: flex; align-items: center; gap: 12px;
        }
        .alert-item.high { border-color: #ef4444; background: rgba(239,68,68,0.04); }
        .alert-item.medium { border-color: #f59e0b; background: rgba(245,158,11,0.04); }
        .alert-item.low { border-color: #3b82f6; background: rgba(59,130,246,0.04); }
        
        /* ── User badge ── */
        .user-badge {
            background: rgba(255,255,255,0.06); border-radius: 12px;
            padding: 10px 14px; margin-top: auto;
            display: flex; align-items: center; gap: 10px;
        }
        .user-badge .avatar {
            width: 36px; height: 36px; border-radius: 10px;
            background: linear-gradient(135deg, #7c5cfc, #a855f7);
            display: flex; align-items: center; justify-content: center;
            font-weight: 600; color: #fff; font-size: 0.85rem;
        }
        .user-badge .info { flex: 1; }
        .user-badge .info .name { font-weight: 600; font-size: 0.85rem; color: #fff; }
        .user-badge .info .role { font-size: 0.75rem; color: rgba(255,255,255,0.45); text-transform: capitalize; }
    </style>
</head>
<body>

<div class="sidebar d-flex flex-column">
    <div class="brand">
        <div class="brand-icon"><i class="bi bi-box-seam-fill"></i></div>
        <span>Smart IMS</span>
    </div>
    <nav class="nav flex-column">
        <a class="nav-link" href="dashboard"><i class="bi bi-grid-1x2-fill"></i> Dashboard</a>
        <a class="nav-link" href="inventory"><i class="bi bi-box-fill"></i> Products &amp; Inventory</a>
        <a class="nav-link" href="sales"><i class="bi bi-cart-fill"></i> Sales</a>
        <a class="nav-link" href="reports"><i class="bi bi-bar-chart-fill"></i> Reports</a>
        <a class="nav-link active" href="ai-insights.jsp"><i class="bi bi-stars"></i> AI Insights</a>
        <a class="nav-link" href="ai-predictions.jsp"><i class="bi bi-graph-up-arrow"></i> Predictions</a>
    </nav>
    <div class="user-badge mt-auto">
        <div class="avatar">${not empty sessionScope.username ? sessionScope.username.substring(0,1).toUpperCase() : "U"}</div>
        <div class="info">
            <div class="name">${sessionScope.username}</div>
            <div class="role">${sessionScope.role}</div>
        </div>
        <a href="logout" class="text-decoration-none" title="Logout"><i class="bi bi-box-arrow-right" style="color:rgba(255,255,255,0.4);font-size:1.1rem;"></i></a>
    </div>
</div>

<div class="main-content">
    <div class="page-header">
        <h1><i class="bi bi-stars me-2" style="color: #a78bfa;"></i>AI Business Insights</h1>
        <p>Automated stock movement profiling and data-driven inventory warnings.</p>
    </div>

    <div class="alert-container mb-4">
        <h5><i class="bi bi-exclamation-triangle me-2" style="color:#fbbf24;"></i>Intelligent System Alerts</h5>
        <div id="alertsList">
            <p class="text-muted small"><i class="bi bi-arrow-clockwise hspin me-1"></i>Analyzing database stock metrics...</p>
        </div>
    </div>

    <div class="row g-4">
        
        <div class="col-md-4">
            <div class="insight-card">
                <h6 style="color: #4ade80;"><i class="bi bi-lightning-charge-fill"></i> Fast Moving Stock</h6>
                <p class="text-muted small">Products performing above the 66th percentile over the last 30 days.</p>
                <ul id="fastMovingList" class="product-list"></ul>
            </div>
        </div>

        <div class="col-md-4">
            <div class="insight-card">
                <h6 style="color: #fbbf24;"><i class="bi bi-hourglass-split"></i> Slow Moving Stock</h6>
                <p class="text-muted small">Products performing below the 33rd percentile over the last 30 days.</p>
                <ul id="slowMovingList" class="product-list"></ul>
            </div>
        </div>

        <div class="col-md-4">
            <div class="insight-card">
                <h6 style="color: #f87171;"><i class="bi bi-trash3-fill"></i> Dead Stock</h6>
                <p class="text-muted small">Products that generated absolutely zero transaction velocity this month.</p>
                <ul id="deadStockList" class="product-list"></ul>
            </div>
        </div>

    </div>
</div>

<script>
document.addEventListener("DOMContentLoaded", () => {
    fetch("http://localhost:5000/api/ai/dashboard")
        .then(res => {
            if (!res.ok) throw new Error("Flask Engine Offline");
            return res.json();
        })
        .then(data => {
            // 1. POPULATE INTELLIGENT ALERTS WITH APPLIED SEVERITY CLASSES
            const alertsList = document.getElementById("alertsList");
            let alertsHtml = "";
            
            if (data.alerts && data.alerts.length > 0) {
                data.alerts.forEach(alert => {
                    let icon = "bi-info-circle";
                    if (alert.severity === 'high') icon = "bi-exclamation-octagon-fill";
                    else if (alert.severity === 'medium') icon = "bi-exclamation-triangle-fill";

                    alertsHtml += `
                        <div class="alert-item \${alert.severity}">
                            <i class="bi \${icon}"></i>
                            <div>\${alert.message}</div>
                        </div>
                    `;
                });
                alertsList.innerHTML = alertsHtml;
            } else {
                alertsList.innerHTML = `
                    <div class="text-center p-4 text-muted border border-dashed rounded-3" style="border-color: rgba(255,255,255,0.1) !important;">
                        <i class="bi bi-shield-check text-success" style="font-size: 1.5rem;"></i>
                        <p class="mb-0 mt-2 small">No critical automated business exceptions found.</p>
                    </div>`;
            }

            // 2. POPULATE FAST MOVING PRODUCTS
            const fastList = document.getElementById("fastMovingList");
            if (data.fast && data.fast.length > 0) {
                data.fast.forEach(p => {
                    fastList.innerHTML += `
                        <li>
                            <span class="text-white font-medium">\${p.name}</span>
                            <span class="badge-sales">\${p.units_sold} sold</span>
                        </li>`;
                });
            } else {
                fastList.innerHTML = '<li class="text-muted small py-3 justify-content-center">No fast-moving items</li>';
            }

            // 3. POPULATE SLOW MOVING PRODUCTS
            const slowList = document.getElementById("slowMovingList");
            if (data.slow && data.slow.length > 0) {
                data.slow.forEach(p => {
                    slowList.innerHTML += `
                        <li>
                            <span class="text-white font-medium">\${p.name}</span>
                            <span class="badge-sales" style="background: rgba(245,158,11,0.15); color: #fbbf24;">\${p.units_sold} sold</span>
                        </li>`;
                });
            } else {
                slowList.innerHTML = '<li class="text-muted small py-3 justify-content-center">No slow-moving items</li>';
            }

            // 4. POPULATE DEAD STOCK
            const deadList = document.getElementById("deadStockList");
            if (data.dead && data.dead.length > 0) {
                data.dead.forEach(p => {
                    deadList.innerHTML += `
                        <li>
                            <span class="text-white font-medium">\${p.name}</span>
                            <span class="badge bg-danger-subtle text-danger border border-danger-subtle rounded-pill font-small">0 velocity</span>
                        </li>`;
                });
            } else {
                deadList.innerHTML = '<li class="text-muted small py-3 justify-content-center">No stale items found</li>';
            }
        })
        .catch(err => {
            console.error(err);
            document.getElementById("alertsList").innerHTML = `
                <div class="alert alert-danger border-0 bg-danger-subtle text-danger rounded-3 p-3">
                    <i class="bi bi-wifi-off me-2"></i><strong>AI Core Engine Down:</strong> 
                    Could not connect to the analytical service running on port 5000. Please check your system logs or run app.py.
                </div>`;
        });
});
</script>

</body>
</html>