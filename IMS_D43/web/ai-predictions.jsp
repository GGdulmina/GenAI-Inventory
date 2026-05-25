<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AI Predictions – Smart IMS</title>
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
        
        /* ── Fixed Dark Table Container ── */
        .table-card {
            background: #161b22; 
            border: 1px solid rgba(255,255,255,0.06);
            border-radius: 16px; 
            padding: 24px;
        }
        .table-card h6 { color: #fff; font-weight: 600; margin-bottom: 20px; }
        
        /* Forced Dark Table Theme Elements */
        .custom-table { 
            margin-bottom: 0; 
            background-color: #161b22 !important;
        }
        .custom-table thead th {
            background: #1f242c !important;
            color: rgba(255, 255, 255, 0.7) !important;
            font-size: 0.8rem; font-weight: 600; text-transform: uppercase;
            letter-spacing: 0.5px; padding: 14px; border-bottom: 2px solid rgba(255,255,255,0.1);
        }
        .custom-table tbody tr { 
            background-color: #161b22 !important; 
            border-bottom: 1px solid rgba(255,255,255,0.06); 
        }
        .custom-table tbody tr:hover { 
            background-color: #1f242c !important; 
        }
        .custom-table tbody td { 
            padding: 14px; 
            font-size: 0.88rem; 
            vertical-align: middle;
            color: #e1e4e8 !important; /* Forces visible text on all data cells */
        }
        
        /* ── Status Badges ── */
        .status-badge {
            font-weight: 700; font-size: 0.72rem; letter-spacing: 0.5px;
            padding: 6px 10px; border-radius: 6px; text-transform: uppercase;
            display: inline-block;
        }
        .status-critical { background: rgba(239,68,68,0.2) !important; color: #f87171 !important; border: 1px solid rgba(239,68,68,0.4); }
        .status-low { background: rgba(245,158,11,0.2) !important; color: #fbbf24 !important; border: 1px solid rgba(245,158,11,0.4); }
        .status-ok { background: rgba(34,197,94,0.2) !important; color: #4ade80 !important; border: 1px solid rgba(34,197,94,0.4); }
        .status-no_sales { background: rgba(255,255,255,0.08) !important; color: rgba(255,255,255,0.6) !important; border: 1px solid rgba(255,255,255,0.15); }

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
        <a class="nav-link" href="ai-insights.jsp"><i class="bi bi-stars"></i> AI Insights</a>
        <a class="nav-link active" href="ai-predictions.jsp"><i class="bi bi-graph-up-arrow"></i> Predictions</a>
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
        <h1><i class="bi bi-graph-up-arrow me-2" style="color: #a78bfa;"></i>AI Predictive Restocking</h1>
        <p>Run-out schedules and procurement recommendations derived from rolling 30-day burn rates.</p>
    </div>

    <div id="errorBlock" class="d-none mb-4">
        <div class="alert alert-danger border-0 bg-danger-subtle text-danger rounded-3 p-3">
            <i class="bi bi-wifi-off me-2"></i><strong>Prediction Framework Offline:</strong> 
            Unable to connect to the Flask core service at port 5000. Verify execution state of app.py.
        </div>
    </div>

    <div class="table-card">
        <h6><i class="bi bi-table me-2" style="color:rgba(255,255,255,0.4)"></i>Restock Schedule &amp; Order Guidance</h6>
        <div class="table-responsive">
            <table class="table table-dark table-borderless custom-table">
                <thead>
                    <tr>
                        <th style="width: 25%;">Product Specification</th>
                        <th class="text-center">Current Stock</th>
                        <th class="text-center">Daily Burn Rate</th>
                        <th class="text-center">Days Remaining</th>
                        <th class="text-center">Risk Status</th>
                        <th style="width: 35%;">AI Recommendation Message</th>
                    </tr>
                </thead>
                <tbody id="tableBody">
                    <tr>
                        <td colspan="6" class="text-center text-muted py-5">
                            <div class="spinner-border spinner-border-sm text-primary me-2" role="status"></div>
                            Evaluating machine-learning metrics...
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script>
document.addEventListener("DOMContentLoaded", () => {
    fetch("http://localhost:5000/api/ai/dashboard")
        .then(res => {
            if (!res.ok) throw new Error("Flask Engine Disconnected");
            return res.json();
        })
        .then(data => {
            const tbody = document.getElementById("tableBody");
            let rows = "";

            if (data.restock && data.restock.length > 0) {
                data.restock.forEach(item => {
                    let badgeClass = "status-no_sales";
                    if (item.status === "critical") badgeClass = "status-critical";
                    else if (item.status === "low") badgeClass = "status-low";
                    else if (item.status === "ok") badgeClass = "status-ok";

                    let displayStatus = item.status.replace('_', ' ');

                    // Fixed text color bindings inside cells using direct color classes
                    rows += `
                        <tr>
                            <td class="fw-semibold text-white">\${item.product_name}</td>
                            <td class="text-center text-white-50">\${item.current_stock} units</td>
                            <td class="text-center font-monospace text-info">\${item.daily_avg_sales}</td>
                            <td class="text-center fw-bold \${item.days_remaining <= 3 ? 'text-danger' : item.days_remaining <= 7 ? 'text-warning' : 'text-success'}">
                                \${item.days_remaining === 999 ? '∞' : item.days_remaining}
                            </td>
                            <td class="text-center">
                                <span class="status-badge \${badgeClass}">\${displayStatus}</span>
                            </td>
                            <td class="text-light opacity-75">\${item.message}</td>
                        </tr>
                    `;
                });
                tbody.innerHTML = rows;
            } else {
                tbody.innerHTML = `
                    <tr>
                        <td colspan="6" class="text-center text-muted py-4">
                            <i class="bi bi-folder-x me-1"></i>No inventory entities discovered to run models against.
                        </td>
                    </tr>`;
            }
        })
        .catch(err => {
            console.error(err);
            document.getElementById("errorBlock").classList.remove("d-none");
            document.getElementById("tableBody").innerHTML = `
                <tr>
                    <td colspan="6" class="text-center text-danger py-4 small">
                        <i class="bi bi-exclamation-circle-fill me-1"></i>Failed to fetch real-time prediction data matrix.
                    </td>
                </tr>`;
        });
});
</script>

</body>
</html>