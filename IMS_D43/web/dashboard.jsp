<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard – Smart IMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.7/dist/chart.umd.min.js"></script>
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
        /* ── Main ── */
        .main-content { margin-left: 260px; padding: 32px; }
        .page-header { margin-bottom: 32px; }
        .page-header h1 { font-weight: 700; font-size: 1.6rem; color: #fff; margin-bottom: 4px; }
        .page-header p { color: rgba(255,255,255,0.45); font-size: 0.9rem; margin: 0; }
        /* ── KPI Cards ── */
        .kpi-card {
            background: #161b22; border: 1px solid rgba(255,255,255,0.06);
            border-radius: 16px; padding: 24px; transition: transform 0.2s;
        }
        .kpi-card:hover { transform: translateY(-4px); }
        .kpi-icon {
            width: 48px; height: 48px; border-radius: 12px;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.3rem; margin-bottom: 16px;
        }
        .kpi-icon.purple { background: rgba(124,92,252,0.15); color: #a78bfa; }
        .kpi-icon.green  { background: rgba(34,197,94,0.15);  color: #4ade80; }
        .kpi-icon.blue   { background: rgba(59,130,246,0.15); color: #60a5fa; }
        .kpi-icon.amber  { background: rgba(245,158,11,0.15); color: #fbbf24; }
        .kpi-icon.red    { background: rgba(239,68,68,0.15);  color: #f87171; }
        .kpi-value { font-size: 1.8rem; font-weight: 700; color: #fff; }
        .kpi-label { font-size: 0.8rem; color: rgba(255,255,255,0.45); margin-top: 4px; }
        /* ── Chart Card ── */
        .chart-card {
            background: #161b22; border: 1px solid rgba(255,255,255,0.06);
            border-radius: 16px; padding: 24px;
        }
        .chart-card h6 { color: #fff; font-weight: 600; margin-bottom: 16px; }
        /* ── Alert list ── */
        .alert-item {
            background: rgba(255,255,255,0.03); border-radius: 10px;
            padding: 12px 16px; margin-bottom: 8px;
            border-left: 3px solid;
            font-size: 0.85rem;
        }
        .alert-item.high   { border-color: #ef4444; }
        .alert-item.medium { border-color: #f59e0b; }
        .alert-item.low    { border-color: #3b82f6; }
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

<!-- ═══════════ SIDEBAR ═══════════ -->
<div class="sidebar d-flex flex-column">
    <div class="brand">
        <div class="brand-icon"><i class="bi bi-box-seam-fill"></i></div>
        <span>GenAI-Inventory</span>
    </div>
    <nav class="nav flex-column">
        <a class="nav-link active" href="dashboard"><i class="bi bi-grid-1x2-fill"></i> Dashboard</a>
        <a class="nav-link" href="inventory"><i class="bi bi-box-fill"></i> Products &amp; Inventory</a>
        <a class="nav-link" href="sales"><i class="bi bi-cart-fill"></i> Sales</a>
        <a class="nav-link" href="reports"><i class="bi bi-bar-chart-fill"></i> Reports</a>
        <a class="nav-link" href="ai-insights.jsp"><i class="bi bi-stars"></i> AI Insights</a>
        <a class="nav-link" href="ai-predictions.jsp"><i class="bi bi-graph-up-arrow"></i> Predictions</a>
    </nav>
    <div class="user-badge mt-auto">
        <div class="avatar">${sessionScope.username.substring(0,1).toUpperCase()}</div>
        <div class="info">
            <div class="name">${sessionScope.username}</div>
            <div class="role">${sessionScope.role}</div>
        </div>
        <a href="logout" class="text-decoration-none" title="Logout"><i class="bi bi-box-arrow-right" style="color:rgba(255,255,255,0.4);font-size:1.1rem;"></i></a>
    </div>
</div>

<!-- ═══════════ MAIN CONTENT ═══════════ -->
<div class="main-content">
    <div class="page-header">
        <h1><i class="bi bi-grid-1x2-fill me-2"></i>Dashboard</h1>
        <p>Welcome back, ${sessionScope.username}. Here's your business overview.</p>
    </div>

    <!-- KPI Cards -->
    <div class="row g-4 mb-4">
        <div class="col-md-4 col-lg">
            <div class="kpi-card">
                <div class="kpi-icon purple"><i class="bi bi-box-seam"></i></div>
                <div class="kpi-value">${totalProducts}</div>
                <div class="kpi-label">Total Products</div>
            </div>
        </div>
        <div class="col-md-4 col-lg">
            <div class="kpi-card">
                <div class="kpi-icon red"><i class="bi bi-exclamation-triangle"></i></div>
                <div class="kpi-value">${lowStockCount}</div>
                <div class="kpi-label">Low Stock Alerts</div>
            </div>
        </div>
        <div class="col-md-4 col-lg">
            <div class="kpi-card">
                <div class="kpi-icon blue"><i class="bi bi-receipt"></i></div>
                <div class="kpi-value">${totalSales}</div>
                <div class="kpi-label">Total Transactions</div>
            </div>
        </div>
        <div class="col-md-4 col-lg">
            <div class="kpi-card">
                <div class="kpi-icon green"><i class="bi bi-currency-dollar"></i></div>
                <div class="kpi-value">$<fmt:formatNumber value="${totalRevenue}" pattern="#,##0.00"/></div>
                <div class="kpi-label">Total Revenue</div>
            </div>
        </div>
        <div class="col-md-4 col-lg">
            <div class="kpi-card">
                <div class="kpi-icon amber"><i class="bi bi-calendar-check"></i></div>
                <div class="kpi-value">$<fmt:formatNumber value="${todayRevenue}" pattern="#,##0.00"/></div>
                <div class="kpi-label">Today's Revenue</div>
            </div>
        </div>
    </div>

    <!-- Charts Row -->
    <div class="row g-4 mb-4">
        <div class="col-lg-8">
            <div class="chart-card">
                <h6><i class="bi bi-graph-up me-2"></i>Sales Trend (Last 60 Days)</h6>
                <canvas id="salesTrendChart" height="100"></canvas>
            </div>
        </div>
        <div class="col-lg-4">
            <div class="chart-card">
                <h6><i class="bi bi-pie-chart me-2"></i>Revenue by Category</h6>
                <canvas id="categoryChart" height="200"></canvas>
            </div>
        </div>
    </div>

    <!-- Bottom Row -->
    <div class="row g-4">
        <div class="col-lg-6">
            <div class="chart-card">
                <h6><i class="bi bi-trophy me-2"></i>Top 10 Products</h6>
                <canvas id="topProductsChart" height="200"></canvas>
            </div>
        </div>
        <div class="col-lg-6">
            <div class="chart-card">
                <h6><i class="bi bi-exclamation-triangle me-2" style="color:#f87171;"></i>Low Stock Alerts</h6>
                <div style="max-height:340px; overflow-y:auto;">
                    <c:forEach var="item" items="${lowStockItems}">
                        <div class="alert-item high">
                            <strong>${item.name}</strong> – Only <strong>${item.quantity}</strong> units left
                            (min: ${item.minStockLevel})
                        </div>
                    </c:forEach>
                    <c:if test="${empty lowStockItems}">
                        <p class="text-center" style="color:rgba(255,255,255,0.3); padding:40px;">
                            <i class="bi bi-check-circle" style="font-size:2rem;"></i><br>
                            All products are well stocked!
                        </p>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
// ── Chart defaults ──
Chart.defaults.color = 'rgba(255,255,255,0.5)';
Chart.defaults.borderColor = 'rgba(255,255,255,0.06)';

// ── Sales Trend Chart ──
fetch('ai/trends?feature=trends')
    .then(r => r.ok ? r.json() : Promise.reject('AI API unavailable'))
    .then(data => {
        if (!data.daily) return;
        const ctx = document.getElementById('salesTrendChart').getContext('2d');
        new Chart(ctx, {
            type: 'line',
            data: {
                labels: data.daily.map(d => d.day.substring(5)),
                datasets: [{
                    label: 'Daily Revenue ($)',
                    data: data.daily.map(d => d.revenue),
                    borderColor: '#7c5cfc',
                    backgroundColor: 'rgba(124,92,252,0.1)',
                    fill: true, tension: 0.4, pointRadius: 2
                }]
            },
            options: { responsive: true, plugins: { legend: { display: false } },
                       scales: { y: { beginAtZero: true } } }
        });
    })
    .catch(() => {
        document.getElementById('salesTrendChart').parentElement.innerHTML +=
            '<p class="text-center mt-3" style="color:rgba(255,255,255,0.3)">Start the AI API (Flask) to see trend data</p>';
    });

// ── Category Revenue Chart ──
fetch('reports?action=categoryRevenue')
    .then(r => r.json())
    .then(data => {
        const colors = ['#7c5cfc','#a855f7','#3b82f6','#22c55e','#f59e0b','#ef4444','#ec4899','#06b6d4','#8b5cf6','#f43f5e'];
        new Chart(document.getElementById('categoryChart'), {
            type: 'doughnut',
            data: {
                labels: data.map(d => d.category),
                datasets: [{ data: data.map(d => d.revenue), backgroundColor: colors, borderWidth: 0 }]
            },
            options: { responsive: true, plugins: { legend: { position: 'bottom', labels: { padding: 12, boxWidth: 12 } } } }
        });
    });

// ── Top Products Chart ──
fetch('reports?action=topProducts')
    .then(r => r.json())
    .then(data => {
        new Chart(document.getElementById('topProductsChart'), {
            type: 'bar',
            data: {
                labels: data.map(d => d.name.length > 15 ? d.name.substring(0,15) + '...' : d.name),
                datasets: [{
                    label: 'Units Sold',
                    data: data.map(d => d.unitsSold),
                    backgroundColor: 'rgba(124,92,252,0.6)',
                    borderRadius: 6
                }]
            },
            options: { responsive: true, indexAxis: 'y',
                       plugins: { legend: { display: false } },
                       scales: { x: { beginAtZero: true } } }
        });
    });
</script>

</body>
</html>
