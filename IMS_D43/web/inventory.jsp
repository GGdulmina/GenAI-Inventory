<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Inventory</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; background: #f5f5f5; }
        nav { background: #3B7DD8; color: white; padding: 14px 24px; 
              display: flex; justify-content: space-between; align-items: center; }
        nav a { color: white; text-decoration: none; margin-left: 16px; }
        .container { max-width: 1100px; margin: 24px auto; padding: 0 16px; }
        table { width: 100%; border-collapse: collapse; background: white; border-radius: 8px; overflow: hidden; }
        th { background: #3B7DD8; color: white; padding: 12px 16px; text-align: left; }
        td { padding: 10px 16px; border-bottom: 1px solid #eee; }
        tr:last-child td { border-bottom: none; }
        .low-stock { color: #e74c3c; font-weight: bold; }
        .btn { padding: 6px 12px; border: none; border-radius: 4px; cursor: pointer; }
        .btn-danger { background: #e74c3c; color: white; }
        .add-form { background: white; padding: 20px; border-radius: 8px; margin-bottom: 20px; }
        .add-form input, .add-form select { padding: 8px; margin: 4px; border: 1px solid #ddd; border-radius: 4px; }
    </style>
</head>
<body>
<nav>
    <span>Inventory System</span>
    <div>
        Welcome, <strong>${sessionScope.loggedInUser}</strong>
        <a href="logout">Logout</a>
    </div>
</nav>
<div class="container">

    <h2>Add New Item</h2>
    <div class="add-form">
        <form method="post" action="inventory">
            <input type="hidden" name="action" value="add"/>
            <input type="text" name="name" placeholder="Item name" required/>
            <input type="text" name="category" placeholder="Category"/>
            <input type="number" name="quantity" placeholder="Qty" min="0" required/>
            <input type="number" name="price" placeholder="Price" step="0.01" min="0" required/>
            <input type="text" name="description" placeholder="Description"/>
            <button type="submit" class="btn" style="background:#27ae60;color:white">Add Item</button>
        </form>
    </div>

    <h2>Current Inventory</h2>
    <table>
        <tr>
            <th>ID</th><th>Name</th><th>Category</th>
            <th>Quantity</th><th>Price</th><th>Action</th>
        </tr>
        <c:forEach var="item" items="${items}">
        <tr>
            <td>${item.id}</td>
            <td>${item.name}</td>
            <td>${item.category}</td>
            <td class="${item.quantity < 10 ? 'low-stock' : ''}">${item.quantity}</td>
            <td>$${item.price}</td>
            <td>
                <form method="post" action="inventory" style="display:inline">
                    <input type="hidden" name="action" value="delete"/>
                    <input type="hidden" name="id" value="${item.id}"/>
                    <button class="btn btn-danger" 
                            onclick="return confirm('Delete this item?')">Delete</button>
                </form>
            </td>
        </tr>
        </c:forEach>
    </table>
</div>
</body>
</html>