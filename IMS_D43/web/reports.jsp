<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reports – Smart IMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.7/dist/chart.umd.min.js"></script>
    <style>
        * { font-family: 'Inter', sans-serif; }
        body { background: #0f1117; color: #e1e4e8; min-height: 100vh; }
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
            margin-bottom: 4px; font-size: 0.9rem; font-weight: 500; transition: all 0.2s;
        }
        .sidebar .nav-link:hover, .sidebar .nav-link.active {
            background: rgba(124,92,252,0.15); color: #a78bfa;
        }
        .sidebar .nav-link i { margin-right: 10px; }
        .main-content { margin-left: 260px; padding: 32px; }
        .page-header h1 { font-weight: 700; font-size: 1.6rem; color: #fff; margin-bottom: 4px; }
        .page-header p { color: rgba(255,255,255,0.45); font-size: 0.9rem; margin: 0; }
        .card-dark {
            background: #161b22; border: 1px solid rgba(255,255,255,0.06);
            border-radius: 16px; padding: 24px;
        }
        .table-dark-custom { color: #e1e4e8; }
        .table-dark-custom thead th {
            background: rgba(124,92,252,0.12); color: #a78bfa;
            border-bottom: 1px solid rgba(255,255,255,0.08);
            font-weight: 600; font-size: 0.8rem; text-transform: uppercase;
        }
        .table-dark-custom td {
            border-bottom: 1px solid rgba(255,255,255,0.04);
            padding: 10px 12px; font-size: 0.88rem;
        }
        .table-dark-custom tbody tr:hover { background: rgba(255,255,255,0.03); }
        .badge-low { background: rgba(239,68,68,0.15); color: #f87171; }
        .badge-ok { background: rgba(34,197,94,0.15); color: #4ade80; }
        .badge-over { background: rgba(245,158,11,0.15); color: #fbbf24; }
        .btn-purple {
            background: linear-gradient(135deg, #7c5cfc, #a855f7);
            border: none; color: #fff; border-radius: 10px; font-weight: 500;
        }
        .btn-purple:hover { color: #fff; }
        .nav-pills .nav-link { color: rgba(255,255,255,0.55); border-radius: 10px; font-weight: 500; }
        .nav-pills .nav-link.active { background: rgba(124,92,252,0.2); color: #a78bfa; }
        .form-control {
            background: rgba(255,255,255,0.06); border: 1px solid rgba(255,255,255,0.1);
            color: #fff; border-radius: 10px;
        }
        .form-control:focus {
            background: rgba(255,255,255,0.1); border-color: #7c5cfc; color: #fff;
            box-shadow: 0 0 0 3px rgba(124,92,252,0.2);
        }
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
        .user-badge .info .name { font-weight: 600; font-size: 0.85rem; color: #fff; }
        .user-badge .info .role { font-size: 0.75rem; color: rgba(255,255,255,0.45); text-transform: capitalize; }
    </style>
</head>
<body>

<!-- SIDEBAR -->
<div class="sidebar d-flex flex-column">
    <div class="brand">
        <div class="brand-icon"><i class="bi bi-box-seam-fill"></i></div>
        <span>Smart IMS</span>
    </div>
    <nav class="nav flex-column">
        <a class="nav-link" href="dashboard"><i class="bi bi-grid-1x2-fill"></i> Dashboard</a>
        <a class="nav-link" href="inventory"><i class="bi bi-box-fill"></i> Products &amp; Inventory</a>
        <a class="nav-link" href="sales"><i class="bi bi-cart-fill"></i> Sales</a>
        <a class="nav-link active" href="reports"><i class="bi bi-bar-chart-fill"></i> Reports</a>
        <a class="nav-link" href="ai-insights.jsp"><i class="bi bi-stars"></i> AI Insights</a>
        <a class="nav-link" href="ai-predictions.jsp"><i class="bi bi-graph-up-arrow"></i> Predictions</a>
    </nav>
    <div class="user-badge mt-auto">
        <div class="avatar">${sessionScope.username.substring(0,1).toUpperCase()}</div>
        <div class="info">
            <div class="name">${sessionScope.username}</div>
            <div class="role">${sessionScope.role}</div>
        </div>
        <a href="logout" title="Logout"><i class="bi bi-box-arrow-right" style="color:rgba(255,255,255,0.4);font-size:1.1rem;"></i></a>
    </div>
</div>

<!-- MAIN -->
<div class="main-content">
    <div class="page-header mb-4">
        <h1><i class="bi bi-bar-chart-fill me-2"></i>Reports</h1>
        <p>View daily, monthly, and stock reports</p>
    </div>

    <!-- Report Type Tabs -->
    <div class="card-dark mb-4">
        <div class="d-flex flex-wrap justify-content-between align-items-center gap-3">
            <ul class="nav nav-pills">
                <li class="nav-item">
                    <a class="nav-link ${reportType == 'daily' ? 'active' : ''}"
                       href="reports?type=daily">
                        <i class="bi bi-calendar-day me-1"></i> Daily Sales
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${reportType == 'monthly' ? 'active' : ''}"
                       href="reports?type=monthly">
                        <i class="bi bi-calendar-month me-1"></i> Monthly Sales
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${reportType == 'stock' ? 'active' : ''}"
                       href="reports?type=stock">
                        <i class="bi bi-box-seam me-1"></i> Product Stock
                    </a>
                </li>
            </ul>
            <c:if test="${reportType == 'daily'}">
                <form method="get" action="reports" class="d-flex gap-2">
                    <input type="hidden" name="type" value="daily">
                    <input type="date" class="form-control" name="date" value="${dateParam}" style="width:180px;">
                    <button class="btn btn-purple btn-sm">Go</button>
                </form>
            </c:if>
            <c:if test="${reportType == 'monthly'}">
                <form method="get" action="reports" class="d-flex gap-2">
                    <input type="hidden" name="type" value="monthly">
                    <input type="month" class="form-control" name="month" value="${monthParam}" style="width:200px;">
                    <button class="btn btn-purple btn-sm">Go</button>
                </form>
            </c:if>
        </div>
    </div>

    <!-- Report Data -->
    <div class="row g-4">
        <!-- Table -->
        <div class="col-lg-7">
            <div class="card-dark">
                <h6 style="color:#fff; font-weight:600; margin-bottom:16px;">
                    <c:choose>
                        <c:when test="${reportType == 'daily'}"><i class="bi bi-calendar-day me-1"></i> Daily Report – ${dateParam}</c:when>
                        <c:when test="${reportType == 'monthly'}"><i class="bi bi-calendar-month me-1"></i> Monthly Report – ${monthParam}</c:when>
                        <c:otherwise><i class="bi bi-box-seam me-1"></i> Stock Report</c:otherwise>
                    </c:choose>
                </h6>
                <div class="table-responsive" style="max-height:500px; overflow-y:auto;">
                    <table class="table table-dark-custom mb-0">
                        <c:choose>
                            <c:when test="${reportType == 'daily'}">
                                <thead><tr><th>Invoice</th><th>Date</th><th>Total</th><th>User</th></tr></thead>
                                <tbody>
                                    <c:set var="dayTotal" value="0"/>
                                    <c:forEach var="r" items="${reportData}">
                                    <tr>
                                        <td>${r.invoice}</td>
                                        <td>${r.date}</td>
                                        <td>$<fmt:formatNumber value="${r.total}" pattern="#,##0.00"/></td>
                                        <td>${r.user}</td>
                                    </tr>
                                    <c:set var="dayTotal" value="${dayTotal + r.total}"/>
                                    </c:forEach>
                                    <c:if test="${not empty reportData}">
                                    <tr style="background:rgba(124,92,252,0.1);">
                                        <td colspan="2"><strong>Total</strong></td>
                                        <td colspan="2"><strong>$<fmt:formatNumber value="${dayTotal}" pattern="#,##0.00"/></strong></td>
                                    </tr>
                                    </c:if>
                                </tbody>
                            </c:when>
                            <c:when test="${reportType == 'monthly'}">
                                <thead><tr><th>Date</th><th>Transactions</th><th>Revenue</th></tr></thead>
                                <tbody>
                                    <c:set var="monthTotal" value="0"/>
                                    <c:forEach var="r" items="${reportData}">
                                    <tr>
                                        <td>${r.day}</td>
                                        <td>${r.txnCount}</td>
                                        <td>$<fmt:formatNumber value="${r.total}" pattern="#,##0.00"/></td>
                                    </tr>
                                    <c:set var="monthTotal" value="${monthTotal + r.total}"/>
                                    </c:forEach>
                                    <c:if test="${not empty reportData}">
                                    <tr style="background:rgba(124,92,252,0.1);">
                                        <td><strong>Total</strong></td>
                                        <td></td>
                                        <td><strong>$<fmt:formatNumber value="${monthTotal}" pattern="#,##0.00"/></strong></td>
                                    </tr>
                                    </c:if>
                                </tbody>
                            </c:when>
                            <c:otherwise>
                                <thead><tr><th>Product</th><th>Category</th><th>Qty</th><th>Value</th><th>Status</th></tr></thead>
                                <tbody>
                                    <c:forEach var="r" items="${reportData}">
                                    <tr>
                                        <td><strong>${r.name}</strong></td>
                                        <td>${r.category}</td>
                                        <td>${r.quantity}</td>
                                        <td>$<fmt:formatNumber value="${r.stockValue}" pattern="#,##0.00"/></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${r.status == 'LOW'}"><span class="badge badge-low">LOW</span></c:when>
                                                <c:when test="${r.status == 'OVER'}"><span class="badge badge-over">OVER</span></c:when>
                                                <c:otherwise><span class="badge badge-ok">OK</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                    </c:forEach>
                                </tbody>
                            </c:otherwise>
                        </c:choose>
                    </table>
                </div>
                <c:if test="${empty reportData}">
                    <p class="text-center py-4" style="color:rgba(255,255,255,0.3);">No data for this period.</p>
                </c:if>
            </div>
        </div>

        <!-- Charts -->
        <div class="col-lg-5">
            <div class="card-dark mb-4">
                <h6 style="color:#fff; font-weight:600; margin-bottom:16px;">
                    <i class="bi bi-pie-chart me-1"></i> Revenue by Category
                </h6>
                <canvas id="catRevenueChart" height="200"></canvas>
            </div>
            <div class="card-dark">
                <h6 style="color:#fff; font-weight:600; margin-bottom:16px;">
                    <i class="bi bi-trophy me-1"></i> Top Products by Units
                </h6>
                <canvas id="topProdChart" height="200"></canvas>
            </div>
        </div>
    </div>
</div>

<script>
Chart.defaults.color = 'rgba(255,255,255,0.5)';
Chart.defaults.borderColor = 'rgba(255,255,255,0.06)';

fetch('reports?action=categoryRevenue')
    .then(r => r.json())
    .then(data => {
        const colors = ['#7c5cfc','#a855f7','#3b82f6','#22c55e','#f59e0b','#ef4444','#ec4899','#06b6d4','#8b5cf6','#f43f5e'];
        new Chart(document.getElementById('catRevenueChart'), {
            type: 'doughnut',
            data: {
                labels: data.map(d => d.category),
                datasets: [{ data: data.map(d => d.revenue), backgroundColor: colors, borderWidth: 0 }]
            },
            options: { responsive: true, plugins: { legend: { position: 'bottom', labels: { padding: 10, boxWidth: 12 } } } }
        });
    });

fetch('reports?action=topProducts')
    .then(r => r.json())
    .then(data => {
        new Chart(document.getElementById('topProdChart'), {
            type: 'bar',
            data: {
                labels: data.map(d => d.name.length > 18 ? d.name.substring(0,18)+'...' : d.name),
                datasets: [{
                    label: 'Units Sold',
                    data: data.map(d => d.unitsSold),
                    backgroundColor: 'rgba(124,92,252,0.6)',
                    borderRadius: 6
                }]
            },
            options: { responsive: true, indexAxis: 'y', plugins: { legend: { display: false } }, scales: { x: { beginAtZero: true } } }
        });
    });
</script>
</body>
</html>
