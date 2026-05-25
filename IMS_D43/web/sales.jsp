<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sales – Smart IMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
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
        .btn-purple {
            background: linear-gradient(135deg, #7c5cfc, #a855f7);
            border: none; color: #fff; border-radius: 10px; font-weight: 500;
        }
        .btn-purple:hover { color: #fff; transform: translateY(-1px); }
        .form-control, .form-select {
            background: rgba(255,255,255,0.06); border: 1px solid rgba(255,255,255,0.1);
            color: #fff; border-radius: 10px;
        }
        .form-control:focus, .form-select:focus {
            background: rgba(255,255,255,0.1); border-color: #7c5cfc; color: #fff;
            box-shadow: 0 0 0 3px rgba(124,92,252,0.2);
        }
        .form-control option, .form-select option { background: #161b22; color: #fff; }
        .form-label { color: rgba(255,255,255,0.6); font-size: 0.8rem; font-weight: 500; }
        .sale-line { background: rgba(255,255,255,0.03); border-radius: 10px; padding: 12px; margin-bottom: 8px; }
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
        /* Modal */
        .modal-content {
            background: #1c2128; border: 1px solid rgba(255,255,255,0.08);
            border-radius: 16px; color: #e1e4e8;
        }
        .modal-header { border-bottom: 1px solid rgba(255,255,255,0.06); }
        .modal-footer { border-top: 1px solid rgba(255,255,255,0.06); }
        .btn-close { filter: invert(1); }
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
        <a class="nav-link active" href="sales"><i class="bi bi-cart-fill"></i> Sales</a>
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
        <a href="logout" title="Logout"><i class="bi bi-box-arrow-right" style="color:rgba(255,255,255,0.4);font-size:1.1rem;"></i></a>
    </div>
</div>

<!-- MAIN CONTENT -->
<div class="main-content">
    <div class="page-header d-flex justify-content-between align-items-start mb-4">
        <div>
            <h1><i class="bi bi-cart-fill me-2"></i>Sales Management</h1>
            <p>Record sales and view transaction history</p>
        </div>
        <button class="btn btn-purple" data-bs-toggle="collapse" data-bs-target="#newSaleForm">
            <i class="bi bi-plus-lg me-1"></i> New Sale
        </button>
    </div>

    <!-- Alerts -->
    <c:if test="${not empty sessionScope.successMsg}">
        <div class="alert alert-success alert-dismissible fade show" style="border-radius:12px;">
            <i class="bi bi-check-circle me-1"></i> ${sessionScope.successMsg}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <% session.removeAttribute("successMsg"); %>
    </c:if>
    <c:if test="${not empty sessionScope.errorMsg}">
        <div class="alert alert-danger alert-dismissible fade show" style="border-radius:12px;">
            <i class="bi bi-exclamation-triangle me-1"></i> ${sessionScope.errorMsg}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <% session.removeAttribute("errorMsg"); %>
    </c:if>

    <!-- New Sale Form -->
    <div class="collapse mb-4" id="newSaleForm">
        <div class="card-dark">
            <h6 style="color:#fff; font-weight:600; margin-bottom:16px;">
                <i class="bi bi-receipt me-1"></i> Record New Sale
            </h6>
            <form method="post" action="sales" id="saleForm">
                <div id="saleLines">
                    <div class="sale-line row g-2 align-items-end" data-index="0">
                        <div class="col-md-5">
                            <label class="form-label">Product</label>
                            <select class="form-select" name="product_0" required onchange="updatePrice(this)">
                                <option value="">Select product...</option>
                                <c:forEach var="p" items="${products}">
                                    <option value="${p.id}" data-price="${p.price}" data-stock="${p.quantity}">
                                        ${p.name} ($${p.price}) — Stock: ${p.quantity}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <label class="form-label">Qty</label>
                            <input type="number" class="form-control" name="qty_0" min="1" value="1" required>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Subtotal</label>
                            <input type="text" class="form-control subtotal-display" readonly placeholder="$0.00">
                        </div>
                        <div class="col-md-2">
                            <button type="button" class="btn btn-outline-danger w-100" style="border-radius:10px;"
                                    onclick="removeLine(this)">
                                <i class="bi bi-trash"></i>
                            </button>
                        </div>
                    </div>
                </div>
                <div class="d-flex justify-content-between mt-3">
                    <button type="button" class="btn btn-outline-light" style="border-radius:10px;"
                            onclick="addLine()">
                        <i class="bi bi-plus me-1"></i> Add Item
                    </button>
                    <div class="d-flex align-items-center gap-3">
                        <strong style="color:#fff; font-size:1.1rem;">
                            Total: $<span id="grandTotal">0.00</span>
                        </strong>
                        <button type="submit" class="btn btn-purple px-4">
                            <i class="bi bi-check-lg me-1"></i> Complete Sale
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!-- Sales History -->
    <div class="card-dark">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h6 style="color:#fff; font-weight:600; margin:0;">
                <i class="bi bi-clock-history me-1"></i> Sales History
            </h6>
            <form method="get" action="sales" class="d-flex gap-2">
                <input type="date" class="form-control" name="date" value="${dateFilter}"
                       style="width:180px;">
                <button type="submit" class="btn btn-purple btn-sm">Filter</button>
                <c:if test="${not empty dateFilter}">
                    <a href="sales" class="btn btn-outline-secondary btn-sm" style="border-radius:10px;">Clear</a>
                </c:if>
            </form>
        </div>
        <div class="table-responsive">
            <table class="table table-dark-custom mb-0">
                <thead>
                    <tr>
                        <th>Invoice</th><th>Date</th><th>Total</th><th>User</th><th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="sale" items="${salesHistory}">
                    <tr>
                        <td><strong>${sale.invoiceNumber}</strong></td>
                        <td><fmt:formatDate value="${sale.saleDate}" pattern="yyyy-MM-dd HH:mm"/></td>
                        <td>$<fmt:formatNumber value="${sale.totalAmount}" pattern="#,##0.00"/></td>
                        <td>${sale.username}</td>
                        <td>
                            <button class="btn btn-sm btn-outline-light" style="border-radius:8px;font-size:0.78rem;"
                                    onclick="viewInvoice(${sale.id})">
                                <i class="bi bi-eye"></i> View
                            </button>
                        </td>
                    </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
        <c:if test="${empty salesHistory}">
            <p class="text-center py-4" style="color:rgba(255,255,255,0.3);">No sales records found.</p>
        </c:if>
    </div>
</div>

<!-- Invoice Modal -->
<div class="modal fade" id="invoiceModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="bi bi-receipt me-2"></i>Invoice Detail</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body" id="invoiceBody">Loading...</div>
            <div class="modal-footer">
                <button class="btn btn-purple" onclick="window.print()"><i class="bi bi-printer me-1"></i>Print</button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
let lineCount = 1;

function addLine() {
    const idx = lineCount++;
    const container = document.getElementById('saleLines');
    const first = container.querySelector('.sale-line');
    const clone = first.cloneNode(true);
    clone.dataset.index = idx;
    clone.querySelector('select').name = 'product_' + idx;
    clone.querySelector('select').value = '';
    clone.querySelector('input[type=number]').name = 'qty_' + idx;
    clone.querySelector('input[type=number]').value = '1';
    clone.querySelector('.subtotal-display').value = '';
    container.appendChild(clone);
}

function removeLine(btn) {
    const lines = document.querySelectorAll('.sale-line');
    if (lines.length > 1) btn.closest('.sale-line').remove();
    calcTotal();
}

function updatePrice(sel) {
    const line = sel.closest('.sale-line');
    const opt = sel.selectedOptions[0];
    const price = parseFloat(opt.dataset.price) || 0;
    const qty = parseInt(line.querySelector('input[type=number]').value) || 1;
    line.querySelector('.subtotal-display').value = '$' + (price * qty).toFixed(2);
    calcTotal();
}

function calcTotal() {
    let total = 0;
    document.querySelectorAll('.sale-line').forEach(line => {
        const sel = line.querySelector('select');
        const opt = sel.selectedOptions[0];
        const price = parseFloat(opt?.dataset?.price) || 0;
        const qty = parseInt(line.querySelector('input[type=number]').value) || 0;
        const sub = price * qty;
        line.querySelector('.subtotal-display').value = sub > 0 ? '$' + sub.toFixed(2) : '';
        total += sub;
    });
    document.getElementById('grandTotal').textContent = total.toFixed(2);
}

document.addEventListener('input', e => {
    if (e.target.name && e.target.name.startsWith('qty_')) calcTotal();
});

function viewInvoice(saleId) {
    const modal = new bootstrap.Modal(document.getElementById('invoiceModal'));
    document.getElementById('invoiceBody').innerHTML = '<div class="text-center py-3"><div class="spinner-border text-light"></div></div>';
    modal.show();
    fetch('sales?action=invoice&id=' + saleId)
        .then(r => r.json())
        .then(data => {
            let html = '<div style="padding:8px;">';
            html += '<div class="d-flex justify-content-between mb-3">';
            html += '<div><strong style="font-size:1.2rem;">Invoice #' + data.invoice + '</strong><br>';
            html += '<small style="color:rgba(255,255,255,0.5);">' + data.date + '</small></div>';
            html += '<div class="text-end"><small style="color:rgba(255,255,255,0.5);">Cashier: ' + data.user + '</small></div></div>';
            html += '<table class="table table-sm" style="color:#e1e4e8;"><thead><tr>';
            html += '<th>Product</th><th>Qty</th><th>Price</th><th>Subtotal</th></tr></thead><tbody>';
            data.items.forEach(it => {
                html += '<tr><td>' + it.product + '</td><td>' + it.qty + '</td>';
                html += '<td>$' + it.price.toFixed(2) + '</td><td>$' + it.subtotal.toFixed(2) + '</td></tr>';
            });
            html += '</tbody></table>';
            html += '<div class="text-end mt-2"><strong style="font-size:1.2rem; color:#a78bfa;">Total: $' + data.total.toFixed(2) + '</strong></div>';
            html += '</div>';
            document.getElementById('invoiceBody').innerHTML = html;
        })
        .catch(() => { document.getElementById('invoiceBody').innerHTML = '<p class="text-center text-danger">Error loading invoice.</p>'; });
}
</script>
</body>
</html>
