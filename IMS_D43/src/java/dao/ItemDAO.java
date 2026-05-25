package dao;

import model.Item;
import util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Item / Product Data Access Object – full CRUD against the `products` table.
 * @author id43
 */
public class ItemDAO {

    // ── Fetch all products ──────────────────────────────────────
    public List<Item> getAllItems() throws SQLException {
        List<Item> items = new ArrayList<>();
        String sql = "SELECT * FROM products ORDER BY name";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                items.add(mapRow(rs));
            }
        }
        return items;
    }

    // ── Search products by name or category ─────────────────────
    public List<Item> searchItems(String keyword) throws SQLException {
        List<Item> items = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE name LIKE ? OR category LIKE ? ORDER BY name";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            String like = "%" + keyword + "%";
            stmt.setString(1, like);
            stmt.setString(2, like);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                items.add(mapRow(rs));
            }
        }
        return items;
    }

    // ── Get single product by ID ────────────────────────────────
    public Item getItemById(int id) throws SQLException {
        String sql = "SELECT * FROM products WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapRow(rs);
            }
        }
        return null;
    }

    // ── Add a new product ───────────────────────────────────────
    public void addItem(Item item) throws SQLException {
        String sql = "INSERT INTO products (name, category, quantity, price, description, " +
                     "min_stock_level, max_stock_level, expiry_date) VALUES (?,?,?,?,?,?,?,?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, item.getName());
            stmt.setString(2, item.getCategory());
            stmt.setInt(3, item.getQuantity());
            stmt.setDouble(4, item.getPrice());
            stmt.setString(5, item.getDescription());
            stmt.setInt(6, item.getMinStockLevel());
            stmt.setInt(7, item.getMaxStockLevel());
            stmt.setDate(8, item.getExpiryDate());
            stmt.executeUpdate();
        }
    }

    // ── Update existing product ─────────────────────────────────
    public void updateItem(Item item) throws SQLException {
        String sql = "UPDATE products SET name=?, category=?, quantity=?, price=?, description=?, " +
                     "min_stock_level=?, max_stock_level=?, expiry_date=? WHERE id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, item.getName());
            stmt.setString(2, item.getCategory());
            stmt.setInt(3, item.getQuantity());
            stmt.setDouble(4, item.getPrice());
            stmt.setString(5, item.getDescription());
            stmt.setInt(6, item.getMinStockLevel());
            stmt.setInt(7, item.getMaxStockLevel());
            stmt.setDate(8, item.getExpiryDate());
            stmt.setInt(9, item.getId());
            stmt.executeUpdate();
        }
    }

    // ── Delete a product ────────────────────────────────────────
    public void deleteItem(int id) throws SQLException {
        // First remove any sale_items referencing this product
        String delItems = "DELETE FROM sale_items WHERE product_id = ?";
        String delProd  = "DELETE FROM products WHERE id = ?";

        try (Connection conn = DBConnection.getConnection()) {
            try (PreparedStatement ps1 = conn.prepareStatement(delItems)) {
                ps1.setInt(1, id);
                ps1.executeUpdate();
            }
            try (PreparedStatement ps2 = conn.prepareStatement(delProd)) {
                ps2.setInt(1, id);
                ps2.executeUpdate();
            }
        }
    }

    // ── Count total products ────────────────────────────────────
    public int getProductCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM products";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            rs.next();
            return rs.getInt(1);
        }
    }

    // ── Count low-stock products ────────────────────────────────
    public int getLowStockCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM products WHERE quantity <= min_stock_level";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            rs.next();
            return rs.getInt(1);
        }
    }

    // ── Get low-stock products list ─────────────────────────────
    public List<Item> getLowStockItems() throws SQLException {
        List<Item> items = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE quantity <= min_stock_level ORDER BY quantity ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                items.add(mapRow(rs));
            }
        }
        return items;
    }

    // ── Helper: map a ResultSet row to an Item object ───────────
    private Item mapRow(ResultSet rs) throws SQLException {
        Item item = new Item(
            rs.getInt("id"),
            rs.getString("name"),
            rs.getString("category"),
            rs.getInt("quantity"),
            rs.getDouble("price")
        );
        item.setDescription(rs.getString("description"));
        item.setMinStockLevel(rs.getInt("min_stock_level"));
        item.setMaxStockLevel(rs.getInt("max_stock_level"));
        item.setExpiryDate(rs.getDate("expiry_date"));
        return item;
    }
}