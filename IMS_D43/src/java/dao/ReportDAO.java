package dao;

import util.DBConnection;
import java.sql.*;
import java.util.*;

/**
 * Report Data Access Object – aggregation queries for reports and dashboard.
 * @author id43
 */
public class ReportDAO {

    // ── Daily sales summary ─────────────────────────────────────
    public List<Map<String, Object>> getDailyReport(String date) throws SQLException {
        String sql =
            "SELECT s.id, s.invoice_number, s.sale_date, s.total_amount, u.username " +
            "FROM sales s JOIN users u ON s.user_id = u.id " +
            "WHERE DATE(s.sale_date) = ? ORDER BY s.sale_date DESC";

        List<Map<String, Object>> rows = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, date);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("id", rs.getInt("id"));
                row.put("invoice", rs.getString("invoice_number"));
                row.put("date", rs.getTimestamp("sale_date"));
                row.put("total", rs.getDouble("total_amount"));
                row.put("user", rs.getString("username"));
                rows.add(row);
            }
        }
        return rows;
    }

    // ── Monthly summary (day-by-day) ────────────────────────────
    public List<Map<String, Object>> getMonthlyReport(String yearMonth) throws SQLException {
        String sql =
            "SELECT DATE(sale_date) AS day, COUNT(*) AS txn_count, SUM(total_amount) AS total " +
            "FROM sales WHERE DATE_FORMAT(sale_date, '%Y-%m') = ? " +
            "GROUP BY DATE(sale_date) ORDER BY day";

        List<Map<String, Object>> rows = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, yearMonth);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("day", rs.getString("day"));
                row.put("txnCount", rs.getInt("txn_count"));
                row.put("total", rs.getDouble("total"));
                rows.add(row);
            }
        }
        return rows;
    }

    // ── Stock report ────────────────────────────────────────────
    public List<Map<String, Object>> getStockReport() throws SQLException {
        String sql =
            "SELECT p.id, p.name, p.category, p.quantity, p.price, " +
            "p.min_stock_level, p.max_stock_level, p.expiry_date, " +
            "(p.quantity * p.price) AS stock_value, " +
            "CASE WHEN p.quantity <= p.min_stock_level THEN 'LOW' " +
            "     WHEN p.quantity >= p.max_stock_level THEN 'OVER' " +
            "     ELSE 'OK' END AS status " +
            "FROM products p ORDER BY p.quantity ASC";

        List<Map<String, Object>> rows = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("id", rs.getInt("id"));
                row.put("name", rs.getString("name"));
                row.put("category", rs.getString("category"));
                row.put("quantity", rs.getInt("quantity"));
                row.put("price", rs.getDouble("price"));
                row.put("minStock", rs.getInt("min_stock_level"));
                row.put("maxStock", rs.getInt("max_stock_level"));
                row.put("expiry", rs.getDate("expiry_date"));
                row.put("stockValue", rs.getDouble("stock_value"));
                row.put("status", rs.getString("status"));
                rows.add(row);
            }
        }
        return rows;
    }

    // ── Category-wise revenue (for charts) ──────────────────────
    public List<Map<String, Object>> getCategoryRevenue() throws SQLException {
        String sql =
            "SELECT p.category, SUM(si.subtotal) AS revenue, SUM(si.quantity) AS units_sold " +
            "FROM sale_items si JOIN products p ON si.product_id = p.id " +
            "GROUP BY p.category ORDER BY revenue DESC";

        List<Map<String, Object>> rows = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("category", rs.getString("category"));
                row.put("revenue", rs.getDouble("revenue"));
                row.put("unitsSold", rs.getInt("units_sold"));
                rows.add(row);
            }
        }
        return rows;
    }

    // ── Top 10 selling products (for charts) ────────────────────
    public List<Map<String, Object>> getTopProducts() throws SQLException {
        String sql =
            "SELECT p.name, SUM(si.quantity) AS units_sold, SUM(si.subtotal) AS revenue " +
            "FROM sale_items si JOIN products p ON si.product_id = p.id " +
            "GROUP BY p.id, p.name ORDER BY units_sold DESC LIMIT 10";

        List<Map<String, Object>> rows = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("name", rs.getString("name"));
                row.put("unitsSold", rs.getInt("units_sold"));
                row.put("revenue", rs.getDouble("revenue"));
                rows.add(row);
            }
        }
        return rows;
    }
}
