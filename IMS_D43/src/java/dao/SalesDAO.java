package dao;

import model.Sale;
import model.SaleItem;
import util.DBConnection;
import java.sql.*;
import java.util.*;

/**
 * Sales Data Access Object – handles sale recording, history, and invoice details.
 * @author id43
 */
public class SalesDAO {

    /**
     * Record a new sale transaction.
     * @param userId  the logged-in user's id
     * @param items   list of int[]{productId, quantity}
     * @return the generated invoice number
     */
    public String recordSale(int userId, List<int[]> items) throws SQLException {
        Connection conn = DBConnection.getConnection();
        conn.setAutoCommit(false);
        try {
            String invoiceNum = "INV" + String.format("%05d", System.currentTimeMillis() % 100000);

            // Insert sale header
            PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO sales (invoice_number, user_id, total_amount) VALUES (?,?,0)",
                Statement.RETURN_GENERATED_KEYS
            );
            ps.setString(1, invoiceNum);
            ps.setInt(2, userId);
            ps.executeUpdate();
            ResultSet keys = ps.getGeneratedKeys();
            keys.next();
            int saleId = keys.getInt(1);

            double total = 0;
            for (int[] item : items) {
                int productId = item[0], qty = item[1];

                // Look up price and check stock
                PreparedStatement psp = conn.prepareStatement(
                    "SELECT price, quantity FROM products WHERE id=?"
                );
                psp.setInt(1, productId);
                ResultSet rs = psp.executeQuery();
                if (rs.next()) {
                    double price = rs.getDouble("price");
                    int stock = rs.getInt("quantity");
                    if (stock < qty) {
                        throw new SQLException("Insufficient stock for product " + productId +
                                " (available: " + stock + ", requested: " + qty + ")");
                    }
                    double subtotal = price * qty;
                    total += subtotal;

                    // Insert sale item
                    PreparedStatement psi = conn.prepareStatement(
                        "INSERT INTO sale_items (sale_id, product_id, quantity, unit_price, subtotal) VALUES (?,?,?,?,?)"
                    );
                    psi.setInt(1, saleId);
                    psi.setInt(2, productId);
                    psi.setInt(3, qty);
                    psi.setDouble(4, price);
                    psi.setDouble(5, subtotal);
                    psi.executeUpdate();

                    // Reduce stock
                    PreparedStatement psu = conn.prepareStatement(
                        "UPDATE products SET quantity = quantity - ? WHERE id = ?"
                    );
                    psu.setInt(1, qty);
                    psu.setInt(2, productId);
                    psu.executeUpdate();
                }
            }

            // Update total
            PreparedStatement pst = conn.prepareStatement(
                "UPDATE sales SET total_amount = ? WHERE id = ?"
            );
            pst.setDouble(1, total);
            pst.setInt(2, saleId);
            pst.executeUpdate();

            conn.commit();
            return invoiceNum;
        } catch (Exception e) {
            conn.rollback();
            throw e instanceof SQLException ? (SQLException) e : new SQLException(e);
        } finally {
            conn.setAutoCommit(true);
            conn.close();
        }
    }

    /**
     * Get sales history with optional date filter.
     */
    public List<Sale> getSalesHistory(String dateFilter) throws SQLException {
        List<Sale> sales = new ArrayList<>();
        String sql;
        if (dateFilter != null && !dateFilter.isEmpty()) {
            sql = "SELECT s.*, u.username FROM sales s JOIN users u ON s.user_id=u.id " +
                  "WHERE DATE(s.sale_date) = ? ORDER BY s.sale_date DESC";
        } else {
            sql = "SELECT s.*, u.username FROM sales s JOIN users u ON s.user_id=u.id " +
                  "ORDER BY s.sale_date DESC LIMIT 100";
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            if (dateFilter != null && !dateFilter.isEmpty()) {
                stmt.setString(1, dateFilter);
            }
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Sale sale = new Sale();
                sale.setId(rs.getInt("id"));
                sale.setInvoiceNumber(rs.getString("invoice_number"));
                sale.setSaleDate(rs.getTimestamp("sale_date"));
                sale.setTotalAmount(rs.getBigDecimal("total_amount"));
                sale.setUserId(rs.getInt("user_id"));
                sale.setUsername(rs.getString("username"));
                sales.add(sale);
            }
        }
        return sales;
    }

    /**
     * Get invoice detail (sale + line items).
     */
    public Sale getInvoiceDetail(int saleId) throws SQLException {
        Sale sale = null;
        String sqlSale = "SELECT s.*, u.username FROM sales s JOIN users u ON s.user_id=u.id WHERE s.id=?";
        String sqlItems = "SELECT si.*, p.name AS product_name FROM sale_items si " +
                          "JOIN products p ON si.product_id = p.id WHERE si.sale_id=?";

        try (Connection conn = DBConnection.getConnection()) {
            // Sale header
            try (PreparedStatement ps = conn.prepareStatement(sqlSale)) {
                ps.setInt(1, saleId);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    sale = new Sale();
                    sale.setId(rs.getInt("id"));
                    sale.setInvoiceNumber(rs.getString("invoice_number"));
                    sale.setSaleDate(rs.getTimestamp("sale_date"));
                    sale.setTotalAmount(rs.getBigDecimal("total_amount"));
                    sale.setUserId(rs.getInt("user_id"));
                    sale.setUsername(rs.getString("username"));
                }
            }
            // Line items
            if (sale != null) {
                List<SaleItem> items = new ArrayList<>();
                try (PreparedStatement ps = conn.prepareStatement(sqlItems)) {
                    ps.setInt(1, saleId);
                    ResultSet rs = ps.executeQuery();
                    while (rs.next()) {
                        SaleItem si = new SaleItem();
                        si.setId(rs.getInt("id"));
                        si.setSaleId(rs.getInt("sale_id"));
                        si.setProductId(rs.getInt("product_id"));
                        si.setProductName(rs.getString("product_name"));
                        si.setQuantity(rs.getInt("quantity"));
                        si.setUnitPrice(rs.getDouble("unit_price"));
                        si.setSubtotal(rs.getDouble("subtotal"));
                        items.add(si);
                    }
                }
                sale.setItems(items);
            }
        }
        return sale;
    }

    // ── Daily sales report ──────────────────────────────────────
    public List<Map<String, Object>> getDailySales(String date) throws SQLException {
        Connection conn = DBConnection.getConnection();
        PreparedStatement ps = conn.prepareStatement(
            "SELECT s.invoice_number, s.sale_date, s.total_amount, u.username " +
            "FROM sales s JOIN users u ON s.user_id=u.id " +
            "WHERE DATE(s.sale_date)=? ORDER BY s.sale_date DESC"
        );
        ps.setString(1, date);
        ResultSet rs = ps.executeQuery();
        List<Map<String, Object>> results = new ArrayList<>();
        while (rs.next()) {
            Map<String, Object> row = new HashMap<>();
            row.put("invoice", rs.getString("invoice_number"));
            row.put("date", rs.getTimestamp("sale_date"));
            row.put("total", rs.getDouble("total_amount"));
            row.put("user", rs.getString("username"));
            results.add(row);
        }
        conn.close();
        return results;
    }

    // ── Monthly sales summary ───────────────────────────────────
    public List<Map<String, Object>> getMonthlySales(String yearMonth) throws SQLException {
        Connection conn = DBConnection.getConnection();
        PreparedStatement ps = conn.prepareStatement(
            "SELECT DATE(sale_date) AS sale_day, COUNT(*) AS num_sales, " +
            "SUM(total_amount) AS day_total FROM sales " +
            "WHERE DATE_FORMAT(sale_date, '%Y-%m') = ? " +
            "GROUP BY DATE(sale_date) ORDER BY sale_day"
        );
        ps.setString(1, yearMonth);
        ResultSet rs = ps.executeQuery();
        List<Map<String, Object>> results = new ArrayList<>();
        while (rs.next()) {
            Map<String, Object> row = new HashMap<>();
            row.put("day", rs.getString("sale_day"));
            row.put("numSales", rs.getInt("num_sales"));
            row.put("total", rs.getDouble("day_total"));
            results.add(row);
        }
        conn.close();
        return results;
    }

    // ── Total sales count ───────────────────────────────────────
    public int getTotalSalesCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM sales";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            rs.next();
            return rs.getInt(1);
        }
    }

    // ── Total revenue ───────────────────────────────────────────
    public double getTotalRevenue() throws SQLException {
        String sql = "SELECT COALESCE(SUM(total_amount), 0) FROM sales";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            rs.next();
            return rs.getDouble(1);
        }
    }

    // ── Today's revenue ─────────────────────────────────────────
    public double getTodayRevenue() throws SQLException {
        String sql = "SELECT COALESCE(SUM(total_amount), 0) FROM sales WHERE DATE(sale_date) = CURDATE()";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            rs.next();
            return rs.getDouble(1);
        }
    }
}