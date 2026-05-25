package Servlet;

import dao.ItemDAO;
import dao.SalesDAO;
import model.Item;
import model.Sale;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;

/**
 * Sales Management Servlet – record sales, view history, view invoices.
 * @author id43
 */
@WebServlet("/sales")
public class SalesServlet extends HttpServlet {

    private SalesDAO salesDAO = new SalesDAO();
    private ItemDAO  itemDAO  = new ItemDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }

        try {
            String action = request.getParameter("action");

            if ("invoice".equals(action)) {
                // View invoice detail as JSON (for modal)
                int saleId = Integer.parseInt(request.getParameter("id"));
                Sale sale = salesDAO.getInvoiceDetail(saleId);
                response.setContentType("application/json");
                PrintWriter out = response.getWriter();
                out.write(saleToJson(sale));
                return;
            }

            // Default: show sales page
            String dateFilter = request.getParameter("date");
            List<Sale> salesHistory = salesDAO.getSalesHistory(dateFilter);
            List<Item> products = itemDAO.getAllItems();

            request.setAttribute("salesHistory", salesHistory);
            request.setAttribute("products", products);
            request.setAttribute("dateFilter", dateFilter);

            request.getRequestDispatcher("/sales.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }

        try {
            int userId = (int) session.getAttribute("userId");

            // Parse item lines: product_0, qty_0, product_1, qty_1, ...
            List<int[]> items = new ArrayList<>();
            for (int i = 0; i < 20; i++) {
                String prodParam = request.getParameter("product_" + i);
                String qtyParam  = request.getParameter("qty_" + i);
                if (prodParam != null && qtyParam != null &&
                    !prodParam.isEmpty() && !qtyParam.isEmpty()) {
                    items.add(new int[]{
                        Integer.parseInt(prodParam),
                        Integer.parseInt(qtyParam)
                    });
                }
            }

            if (!items.isEmpty()) {
                String invoice = salesDAO.recordSale(userId, items);
                request.getSession().setAttribute("successMsg", "Sale recorded! Invoice: " + invoice);
            }

            response.sendRedirect("sales");
        } catch (Exception e) {
            request.getSession().setAttribute("errorMsg", "Error: " + e.getMessage());
            response.sendRedirect("sales");
        }
    }

    /**
     * Convert a Sale object to JSON string for AJAX invoice view.
     */
    private String saleToJson(Sale sale) {
        if (sale == null) return "{}";
        StringBuilder sb = new StringBuilder();
        sb.append("{");
        sb.append("\"invoice\":\"").append(sale.getInvoiceNumber()).append("\",");
        sb.append("\"date\":\"").append(sale.getSaleDate()).append("\",");
        sb.append("\"total\":").append(sale.getTotalAmount()).append(",");
        sb.append("\"user\":\"").append(sale.getUsername()).append("\",");
        sb.append("\"items\":[");
        for (int i = 0; i < sale.getItems().size(); i++) {
            var si = sale.getItems().get(i);
            if (i > 0) sb.append(",");
            sb.append("{\"product\":\"").append(si.getProductName()).append("\",");
            sb.append("\"qty\":").append(si.getQuantity()).append(",");
            sb.append("\"price\":").append(si.getUnitPrice()).append(",");
            sb.append("\"subtotal\":").append(si.getSubtotal()).append("}");
        }
        sb.append("]}");
        return sb.toString();
    }
}
