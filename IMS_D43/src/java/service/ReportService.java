package service;

import dao.ReportDAO;
import model.ReportDTO;
import java.sql.SQLException;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

/**
 * Service class handling report business logic, formatting, and data mapping.
 */
public class ReportService {

    private final ReportDAO reportDAO = new ReportDAO();
    private final DecimalFormat currencyFormat = new DecimalFormat("$#,##0.00");
    private final SimpleDateFormat dateTimeFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");

    /**
     * Retrieves daily sales report raw data.
     */
    public List<Map<String, Object>> getDailyReport(String date) throws SQLException {
        if (date == null || date.trim().isEmpty()) {
            throw new IllegalArgumentException("Date parameter cannot be empty.");
        }
        return reportDAO.getDailyReport(date);
    }

    /**
     * Retrieves monthly sales report raw data.
     */
    public List<Map<String, Object>> getMonthlyReport(String month) throws SQLException {
        if (month == null || month.trim().isEmpty()) {
            throw new IllegalArgumentException("Month parameter cannot be empty.");
        }
        return reportDAO.getMonthlyReport(month);
    }

    /**
     * Retrieves stock report raw data.
     */
    public List<Map<String, Object>> getStockReport() throws SQLException {
        return reportDAO.getStockReport();
    }

    /**
     * Retrieves category-wise revenue for chart visualization.
     */
    public List<Map<String, Object>> getCategoryRevenue() throws SQLException {
        return reportDAO.getCategoryRevenue();
    }

    /**
     * Retrieves top selling products for chart visualization.
     */
    public List<Map<String, Object>> getTopProducts() throws SQLException {
        return reportDAO.getTopProducts();
    }

    /**
     * Compiles a formatted ReportDTO based on type and parameters.
     */
    public ReportDTO getReportDTO(String type, String dateParam, String monthParam) throws SQLException {
        if (type == null) {
            throw new IllegalArgumentException("Report type is required.");
        }

        String generatedAt = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
        List<String> headers = new ArrayList<>();
        List<List<String>> rows = new ArrayList<>();
        String title;
        String totalSummary = "";

        switch (type.toLowerCase()) {
            case "daily":
                title = "Daily Sales Report - " + dateParam;
                headers.addAll(Arrays.asList("Invoice", "Date", "Total", "User"));
                
                List<Map<String, Object>> dailyData = getDailyReport(dateParam);
                double dailySum = 0;
                for (Map<String, Object> map : dailyData) {
                    List<String> row = new ArrayList<>();
                    row.add(getStringValue(map.get("invoice")));
                    
                    Object dateObj = map.get("date");
                    if (dateObj instanceof java.util.Date) {
                        row.add(dateTimeFormat.format((java.util.Date) dateObj));
                    } else {
                        row.add(getStringValue(dateObj));
                    }

                    double total = getDoubleValue(map.get("total"));
                    row.add(currencyFormat.format(total));
                    dailySum += total;
                    
                    row.add(getStringValue(map.get("user")));
                    rows.add(row);
                }
                totalSummary = "Total Sales: " + currencyFormat.format(dailySum);
                break;

            case "monthly":
                title = "Monthly Sales Report - " + monthParam;
                headers.addAll(Arrays.asList("Day", "Transaction Count", "Revenue"));
                
                List<Map<String, Object>> monthlyData = getMonthlyReport(monthParam);
                double monthlySum = 0;
                for (Map<String, Object> map : monthlyData) {
                    List<String> row = new ArrayList<>();
                    row.add(getStringValue(map.get("day")));
                    row.add(getStringValue(map.get("txnCount")));
                    
                    double total = getDoubleValue(map.get("total"));
                    row.add(currencyFormat.format(total));
                    monthlySum += total;
                    
                    rows.add(row);
                }
                totalSummary = "Total Revenue: " + currencyFormat.format(monthlySum);
                break;

            case "stock":
                title = "Stock Report";
                headers.addAll(Arrays.asList("Product Name", "Category", "Quantity", "Stock Value", "Status"));
                
                List<Map<String, Object>> stockData = getStockReport();
                double totalStockValue = 0;
                int totalProducts = 0;
                for (Map<String, Object> map : stockData) {
                    List<String> row = new ArrayList<>();
                    row.add(getStringValue(map.get("name")));
                    row.add(getStringValue(map.get("category")));
                    row.add(getStringValue(map.get("quantity")));
                    
                    double stockValue = getDoubleValue(map.get("stockValue"));
                    row.add(currencyFormat.format(stockValue));
                    totalStockValue += stockValue;
                    totalProducts++;
                    
                    row.add(getStringValue(map.get("status")));
                    rows.add(row);
                }
                totalSummary = "Total Products: " + totalProducts + "  |  Total Stock Value: " + currencyFormat.format(totalStockValue);
                break;

            default:
                throw new IllegalArgumentException("Unsupported report type: " + type);
        }

        return new ReportDTO(title, type.toUpperCase(), generatedAt, headers, rows, totalSummary);
    }

    private String getStringValue(Object obj) {
        return obj == null ? "" : obj.toString();
    }

    private double getDoubleValue(Object obj) {
        if (obj instanceof Number) {
            return ((Number) obj).doubleValue();
        }
        try {
            return obj == null ? 0.0 : Double.parseDouble(obj.toString());
        } catch (NumberFormatException e) {
            return 0.0;
        }
    }
}
