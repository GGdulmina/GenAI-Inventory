package dao;
import model.Sale;
import util.DBConnection;
import java.sql.*;
import java.util.*;

public class SalesDAO {

    // Record a new sale and reduce stock
    public boolean recordSale(int userId, List<int[]> items) throws SQLException {
        // items = list of [productId, quantity]
        Connection conn = DBConnection.getConnection();
        conn.setAutoCommit(false);
        try {
            String invoiceNum = "INV" + System.currentTimeMillis();

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
                PreparedStatement psp = conn.prepareStatement(
                    "SELECT price, quantity FROM products WHERE id=?"
                );
                psp.setInt(1, productId);
                ResultSet rs = psp.executeQuery();
                if (rs.next()) {
                    double price = rs.getDouble("price");
                    int stock = rs.getInt("quantity");
                    if (stock < qty) throw new SQLException("Insufficient stock for product " + productId);
                    double subtotal = price * qty;
                    total += subtotal;

                    // Insert sale item
                    PreparedStatement psi = conn.prepareStatement(
                        "INSERT INTO sale_items (sale_id,product_id,quantity,unit_price,subtotal) VALUES (?,?,?,?,?)"
                    );
                    psi.setInt(1, saleId); psi.setInt(2, productId);
                    psi.setInt(3, qty); psi.setDouble(4, price); psi.setDouble(5, subtotal);
                    psi.executeUpdate();

                    // Reduce stock
                    conn.prepareStatement(
                        "UPDATE products SET quantity=quantity-" + qty + " WHERE id=" + productId
                    ).executeUpdate();
                }
            }
            conn.prepareStatement("UPDATE sales SET total_amount=" + total + " WHERE id=" + saleId).executeUpdate();
            conn.commit();
            return true;
        } catch (Exception e) {
            conn.rollback();
            throw e;
        } finally {
            conn.setAutoCommit(true);
        }
    }

    // Daily sales report
    public List<Map<String,Object>> getDailySales(String date) throws SQLException {
        Connection conn = DBConnection.getConnection();
        PreparedStatement ps = conn.prepareStatement(
            "SELECT s.invoice_number, s.sale_date, s.total_amount, u.username " +
            "FROM sales s JOIN users u ON s.user_id=u.id " +
            "WHERE DATE(s.sale_date)=? ORDER BY s.sale_date DESC"
        );
        ps.setString(1, date);
        ResultSet rs = ps.executeQuery();
        List<Map<String,Object>> results = new ArrayList<>();
        while (rs.next()) {
            Map<String,Object> row = new HashMap<>();
            row.put("invoice", rs.getString("invoice_number"));
            row.put("date", rs.getTimestamp("sale_date"));
            row.put("total", rs.getDouble("total_amount"));
            row.put("user", rs.getString("username"));
            results.add(row);
        }
        return results;
    }
}