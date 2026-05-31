<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Products & Inventory – Smart IMS</title>
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
        .sidebar .nav-link i { margin-right: 10px; font-size: 1rem; }
        .main-content { margin-left: 260px; padding: 32px; }
        .page-header { margin-bottom: 24px; }
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
            font-weight: 600; font-size: 0.8rem; text-transform: uppercase; letter-spacing: 0.5px;
        }
        .table-dark-custom td {
            border-bottom: 1px solid rgba(255,255,255,0.04);
            padding: 10px 12px; vertical-align: middle; font-size: 0.88rem;
        }
        .table-dark-custom tbody tr:hover { background: rgba(255,255,255,0.03); }
        .badge-low { background: rgba(239,68,68,0.15); color: #f87171; }
        .badge-ok { background: rgba(34,197,94,0.15); color: #4ade80; }
        .badge-over { background: rgba(245,158,11,0.15); color: #fbbf24; }
        .btn-purple {
            background: linear-gradient(135deg, #7c5cfc, #a855f7);
            border: none; color: #fff; border-radius: 10px; font-weight: 500; font-size: 0.85rem;
            padding: 8px 16px; transition: transform 0.2s;
        }
        .btn-purple:hover { transform: translateY(-1px); color: #fff; }
        .form-control, .form-select {
            background: rgba(255,255,255,0.06); border: 1px solid rgba(255,255,255,0.1);
            color: #fff; border-radius: 10px; font-size: 0.88rem;
        }
        .form-control:focus, .form-select:focus {
            background: rgba(255,255,255,0.1); border-color: #7c5cfc; color: #fff;
            box-shadow: 0 0 0 3px rgba(124,92,252,0.2);
        }
        .form-label { color: rgba(255,255,255,0.6); font-size: 0.8rem; font-weight: 500; }
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
        <span>GenAI-Inventory</span>
    </div>
    <nav class="nav flex-column">
        <a class="nav-link" href="dashboard"><i class="bi bi-grid-1x2-fill"></i> Dashboard</a>
        <a class="nav-link active" href="inventory"><i class="bi bi-box-fill"></i> Products &amp; Inventory</a>
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

<!-- MAIN CONTENT -->
<div class="main-content">
    <div class="page-header d-flex justify-content-between align-items-start">
        <div>
            <h1><i class="bi bi-box-fill me-2"></i>Products &amp; Inventory</h1>
            <p>Manage your product catalog and stock levels</p>
        </div>
        <button class="btn btn-purple" data-bs-toggle="collapse" data-bs-target="#addForm">
            <i class="bi bi-plus-lg me-1"></i> Add Product
        </button>
    </div>

    <!-- Add / Edit Form (collapsible) -->
    <div class="collapse ${not empty editItem ? 'show' : ''} mb-4" id="addForm">
        <div class="card-dark">
            <h6 class="mb-3" style="color:#fff; font-weight:600;">
                <c:choose>
                    <c:when test="${not empty editItem}"><i class="bi bi-pencil me-1"></i> Edit Product</c:when>
                    <c:otherwise><i class="bi bi-plus-circle me-1"></i> Add New Product</c:otherwise>
                </c:choose>
            </h6>
            <form method="post" action="inventory">
                <input type="hidden" name="action" value="${not empty editItem ? 'update' : 'add'}">
                <c:if test="${not empty editItem}">
                    <input type="hidden" name="id" value="${editItem.id}">
                </c:if>
                <div class="row g-3">
                    <div class="col-md-3">
                        <label class="form-label">Product Name</label>
                        <input type="text" class="form-control" name="name"
                               value="${editItem.name}" placeholder="e.g. Fresh Milk" required>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label">Category</label>
                        <input type="text" class="form-control" name="category"
                               value="${editItem.category}" placeholder="e.g. Dairy">
                    </div>
                    <div class="col-md-1">
                        <label class="form-label">Qty</label>
                        <input type="number" class="form-control" name="quantity"
                               value="${not empty editItem ? editItem.quantity : ''}" min="0" required>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label">Price ($)</label>
                        <input type="number" class="form-control" name="price" step="0.01"
                               value="${not empty editItem ? editItem.price : ''}" min="0" required>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label">Description</label>
                        <input type="text" class="form-control" name="description"
                               value="${editItem.description}" placeholder="Optional">
                    </div>
                    <div class="col-md-1">
                        <label class="form-label">Min Stock</label>
                        <input type="number" class="form-control" name="minStock"
                               value="${not empty editItem ? editItem.minStockLevel : '10'}" min="0">
                    </div>
                    <div class="col-md-1">
                        <label class="form-label">Max Stock</label>
                        <input type="number" class="form-control" name="maxStock"
                               value="${not empty editItem ? editItem.maxStockLevel : '500'}" min="0">
                    </div>
                    <div class="col-md-2">
                        <label class="form-label">Expiry Date</label>
                        <input type="date" class="form-control" name="expiryDate"
                               value="${editItem.expiryDate}">
                    </div>
                    <div class="col-md-2 d-flex align-items-end">
                        <button type="submit" class="btn btn-purple w-100">
                            <c:choose>
                                <c:when test="${not empty editItem}"><i class="bi bi-check-lg me-1"></i> Update</c:when>
                                <c:otherwise><i class="bi bi-plus-lg me-1"></i> Add</c:otherwise>
                            </c:choose>
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!-- Search Bar -->
    <div class="card-dark mb-4">
        <form method="get" action="inventory" class="d-flex gap-2">
            <input type="text" class="form-control" name="search"
                   value="${searchTerm}" placeholder="Search products by name or category...">
            <button type="submit" class="btn btn-purple">
                <i class="bi bi-search"></i>
            </button>
            <c:if test="${not empty searchTerm}">
                <a href="inventory" class="btn btn-outline-secondary" style="border-radius:10px;">Clear</a>
            </c:if>
        </form>
    </div>

    <!-- Products Table -->
    <div class="card-dark">
        <div class="table-responsive">
            <table class="table table-dark-custom mb-0">
                <thead>
                    <tr>
                        <th>ID</th><th>Name</th><th>Category</th>
                        <th>Qty</th><th>Price</th><th>Min/Max</th>
                        <th>Status</th><th>Expiry</th><th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="item" items="${items}">
                    <tr>
                        <td>${item.id}</td>
                        <td><strong>${item.name}</strong></td>
                        <td><span class="badge" style="background:rgba(124,92,252,0.15);color:#a78bfa;">${item.category}</span></td>
                        <td><strong>${item.quantity}</strong></td>
                        <td>$<fmt:formatNumber value="${item.price}" pattern="#,##0.00"/></td>
                        <td style="font-size:0.78rem;">${item.minStockLevel} / ${item.maxStockLevel}</td>
                        <td>
                            <c:choose>
                                <c:when test="${item.quantity <= item.minStockLevel}">
                                    <span class="badge badge-low"><i class="bi bi-exclamation-triangle-fill me-1"></i>Low</span>
                                </c:when>
                                <c:when test="${item.quantity >= item.maxStockLevel}">
                                    <span class="badge badge-over"><i class="bi bi-arrow-up-circle-fill me-1"></i>Over</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-ok"><i class="bi bi-check-circle-fill me-1"></i>OK</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td style="font-size:0.78rem;">${item.expiryDate != null ? item.expiryDate : '—'}</td>
                        <td>
                            <a href="inventory?edit=${item.id}" class="btn btn-sm btn-outline-light me-1"
                               style="border-radius:8px; font-size:0.78rem; padding:4px 10px;">
                                <i class="bi bi-pencil"></i>
                            </a>
                            <form method="post" action="inventory" style="display:inline">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="id" value="${item.id}">
                                <button class="btn btn-sm btn-outline-danger"
                                        style="border-radius:8px; font-size:0.78rem; padding:4px 10px;"
                                        onclick="return confirm('Delete ${item.name}?')">
                                    <i class="bi bi-trash"></i>
                                </button>
                            </form>
                        </td>
                    </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
        <c:if test="${empty items}">
            <p class="text-center py-4" style="color:rgba(255,255,255,0.3);">No products found.</p>
        </c:if>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>