<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>AI Insights - Smart IMS</title>

    <!-- Fonts & CSS -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.7/dist/chart.umd.min.js"></script>

    <style>
        body { background:#0f1117; color:#e1e4e8; font-family:'Inter',sans-serif; }
        .sidebar { background:#161b22; min-height:100vh; border-right:1px solid rgba(255,255,255,0.06); }
        .nav-link { color:#9ca3af; }
        .nav-link.active { color:#fff; background:#1f2937; border-radius:8px; }
        .card { background:#161b22; border:1px solid rgba(255,255,255,0.06); }
        .alert-item { background:#161b22; border-left:4px solid; padding:12px; border-radius:8px; }
        .alert-item.high { border-color:#ef4444; }
        .alert-item.medium { border-color:#f59e0b; }
        .alert-item.low { border-color:#3b82f6; }
        .badge-user { background:#1f2937; }
    </style>
</head>

<body>

<div class="container-fluid">
    <div class="row">

        <!-- SIDEBAR -->
        <div class="col-md-2 sidebar p-3">
            <h5 class="text-white mb-4">Smart IMS</h5>

            <div class="mb-3 p-2 badge-user rounded">
                <div class="small text-muted">Logged in</div>
                <div>${sessionScope.username}</div>
                <div class="small text-secondary">${sessionScope.role}</div>
            </div>

            <ul class="nav flex-column">
                <li><a class="nav-link" href="dashboard.jsp"><i class="bi bi-speedometer2"></i> Dashboard</a></li>
                <li><a class="nav-link" href="inventory.jsp"><i class="bi bi-box"></i> Inventory</a></li>
                <li><a class="nav-link" href="sales.jsp"><i class="bi bi-cart"></i> Sales</a></li>
                <li><a class="nav-link" href="reports.jsp"><i class="bi bi-graph-up"></i> Reports</a></li>
                <li><a class="nav-link active" href="ai-insights.jsp"><i class="bi bi-cpu"></i> AI Insights</a></li>
                <li><a class="nav-link" href="ai-predictions.jsp"><i class="bi bi-lightning"></i> Predictions</a></li>
            </ul>
        </div>

        <!-- MAIN -->
        <div class="col-md-10 p-4">

            <h3 class="mb-4">AI Business Insights</h3>

            <!-- FAST / SLOW MOVING -->
            <div class="row g-3 mb-4">
                <div class="col-md-4">
                    <div class="card p-3">
                        <h6>🔥 Fast Moving Products</h6>
                        <c:forEach var="item" items="${fastMoving}">
                            <div class="small text-success">${item.name}</div>
                        </c:forEach>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="card p-3">
                        <h6>🐢 Slow Moving Products</h6>
                        <c:forEach var="item" items="${slowMoving}">
                            <div class="small text-warning">${item.name}</div>
                        </c:forEach>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="card p-3">
                        <h6>💀 Dead Stock</h6>
                        <c:forEach var="item" items="${deadStock}">
                            <div class="small text-danger">${item.name}</div>
                        </c:forEach>
                    </div>
                </div>
            </div>

            <!-- CHARTS -->
            <div class="row g-3">
                <div class="col-md-6">
                    <div class="card p-3">
                        <h6>Product Performance</h6>
                        <canvas id="performanceChart"></canvas>
                    </div>
                </div>

                <div class="col-md-6">
                    <div class="card p-3">
                        <h6>Revenue Analysis</h6>
                        <canvas id="revenueChart"></canvas>
                    </div>
                </div>
            </div>

            <!-- ALERTS -->
            <div class="card mt-4 p-3">
                <h6>⚠ Intelligent Alerts</h6>

                <c:forEach var="alert" items="${alerts}">
                    <div class="alert-item ${alert.priority} mt-2">
                        ${alert.message}
                    </div>
                </c:forEach>
            </div>

        </div>
    </div>
</div>

<script>
Chart.defaults.color = 'rgba(255,255,255,0.5)';
Chart.defaults.borderColor = 'rgba(255,255,255,0.06)';

// Performance Chart
fetch('ai/trends?type=performance')
.then(r => r.json())
.then(data => {
    new Chart(document.getElementById('performanceChart'), {
        type: 'bar',
        data: {
            labels: data.labels,
            datasets: [{
                label: 'Sales',
                data: data.values,
                backgroundColor: '#3b82f6'
            }]
        }
    });
})
.catch(() => {
    document.getElementById('performanceChart').parentElement.innerHTML =
        '<div class="text-danger">AI service unavailable</div>';
});

// Revenue Chart
fetch('ai/trends?type=revenue')
.then(r => r.json())
.then(data => {
    new Chart(document.getElementById('revenueChart'), {
        type: 'line',
        data: {
            labels: data.labels,
            datasets: [{
                label: 'Revenue',
                data: data.values,
                borderColor: '#22c55e',
                tension: 0.4
            }]
        }
    });
})
.catch(() => {
    document.getElementById('revenueChart').parentElement.innerHTML =
        '<div class="text-danger">AI service unavailable</div>';
});
</script>

</body>
</html>