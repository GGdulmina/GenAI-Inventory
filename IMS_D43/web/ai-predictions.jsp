<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>AI Predictions - Smart IMS</title>

    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.7/dist/chart.umd.min.js"></script>

    <style>
        body { background:#0f1117; color:#e1e4e8; font-family:'Inter',sans-serif; }
        .sidebar { background:#161b22; min-height:100vh; border-right:1px solid rgba(255,255,255,0.06); }
        .nav-link { color:#9ca3af; }
        .nav-link.active { background:#1f2937; color:#fff; border-radius:8px; }
        .card { background:#161b22; border:1px solid rgba(255,255,255,0.06); }
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
                <li><a class="nav-link" href="dashboard.jsp">Dashboard</a></li>
                <li><a class="nav-link" href="inventory.jsp">Inventory</a></li>
                <li><a class="nav-link" href="sales.jsp">Sales</a></li>
                <li><a class="nav-link" href="reports.jsp">Reports</a></li>
                <li><a class="nav-link" href="ai-insights.jsp">AI Insights</a></li>
                <li><a class="nav-link active" href="ai-predictions.jsp">Predictions</a></li>
            </ul>
        </div>

        <!-- MAIN -->
        <div class="col-md-10 p-4">

            <h3 class="mb-4">AI Predictions & Forecasting</h3>

            <!-- RESTOCK CARDS -->
            <div class="row g-3">
                <c:forEach var="p" items="${restockPredictions}">
                    <div class="col-md-4">
                        <div class="card p-3">
                            <h6>${p.productName}</h6>
                            <div class="small text-warning">${p.message}</div>
                            <div class="mt-2 text-success">
                                Suggested Qty: <b>${p.quantity}</b>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <!-- SALES TRENDS -->
            <div class="card mt-4 p-3">
                <h6>📊 Sales Trend Insights</h6>
                <ul class="mt-2">
                    <c:forEach var="t" items="${trendInsights}">
                        <li class="small">${t}</li>
                    </c:forEach>
                </ul>
            </div>

            <!-- CHARTS -->
            <div class="row g-3 mt-2">
                <div class="col-md-6">
                    <div class="card p-3">
                        <h6>Sales Trend Forecast</h6>
                        <canvas id="trendChart"></canvas>
                    </div>
                </div>

                <div class="col-md-6">
                    <div class="card p-3">
                        <h6>AI Prediction Timeline</h6>
                        <canvas id="forecastChart"></canvas>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>

<script>
Chart.defaults.color = 'rgba(255,255,255,0.5)';
Chart.defaults.borderColor = 'rgba(255,255,255,0.06)';

// Trend Chart
fetch('ai/trends?type=trend')
.then(r => r.json())
.then(data => {
    new Chart(document.getElementById('trendChart'), {
        type: 'line',
        data: {
            labels: data.labels,
            datasets: [{
                label: 'Sales',
                data: data.values,
                borderColor: '#3b82f6',
                tension: 0.3
            }]
        }
    });
})
.catch(() => {
    document.getElementById('trendChart').parentElement.innerHTML =
        '<div class="text-danger">Trend data unavailable</div>';
});

// Forecast Chart
fetch('ai/trends?type=forecast')
.then(r => r.json())
.then(data => {
    new Chart(document.getElementById('forecastChart'), {
        type: 'line',
        data: {
            labels: data.labels,
            datasets: [
                {
                    label: 'Historical',
                    data: data.history,
                    borderColor: '#22c55e'
                },
                {
                    label: 'Predicted',
                    data: data.prediction,
                    borderColor: '#f59e0b',
                    borderDash: [5,5]
                }
            ]
        }
    });
})
.catch(() => {
    document.getElementById('forecastChart').parentElement.innerHTML =
        '<div class="text-danger">Forecast service unavailable</div>';
});
</script>

</body>
</html>