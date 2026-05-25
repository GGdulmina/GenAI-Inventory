package Servlet;

import dao.ItemDAO;
import model.Item;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.sql.Date;
import java.util.List;

/**
 * Inventory & Product management servlet – full CRUD + search.
 * @author id43
 */
@WebServlet("/inventory")
public class InventoryServlet extends HttpServlet {

    private ItemDAO itemDAO = new ItemDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }

        try {
            String search = request.getParameter("search");
            List<Item> items;
            if (search != null && !search.trim().isEmpty()) {
                items = itemDAO.searchItems(search.trim());
                request.setAttribute("searchTerm", search.trim());
            } else {
                items = itemDAO.getAllItems();
            }
            request.setAttribute("items", items);

            // Check if we're editing
            String editId = request.getParameter("edit");
            if (editId != null) {
                Item editItem = itemDAO.getItemById(Integer.parseInt(editId));
                request.setAttribute("editItem", editItem);
            }

            request.getRequestDispatcher("/inventory.jsp").forward(request, response);
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

        String action = request.getParameter("action");

        try {
            if ("add".equals(action)) {
                Item item = new Item();
                item.setName(request.getParameter("name"));
                item.setCategory(request.getParameter("category"));
                item.setQuantity(Integer.parseInt(request.getParameter("quantity")));
                item.setPrice(Double.parseDouble(request.getParameter("price")));
                item.setDescription(request.getParameter("description"));
                item.setMinStockLevel(parseIntOrDefault(request.getParameter("minStock"), 10));
                item.setMaxStockLevel(parseIntOrDefault(request.getParameter("maxStock"), 500));
                String expiry = request.getParameter("expiryDate");
                if (expiry != null && !expiry.isEmpty()) {
                    item.setExpiryDate(Date.valueOf(expiry));
                }
                itemDAO.addItem(item);

            } else if ("update".equals(action)) {
                Item item = new Item();
                item.setId(Integer.parseInt(request.getParameter("id")));
                item.setName(request.getParameter("name"));
                item.setCategory(request.getParameter("category"));
                item.setQuantity(Integer.parseInt(request.getParameter("quantity")));
                item.setPrice(Double.parseDouble(request.getParameter("price")));
                item.setDescription(request.getParameter("description"));
                item.setMinStockLevel(parseIntOrDefault(request.getParameter("minStock"), 10));
                item.setMaxStockLevel(parseIntOrDefault(request.getParameter("maxStock"), 500));
                String expiry = request.getParameter("expiryDate");
                if (expiry != null && !expiry.isEmpty()) {
                    item.setExpiryDate(Date.valueOf(expiry));
                }
                itemDAO.updateItem(item);

            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                itemDAO.deleteItem(id);
            }

            response.sendRedirect("inventory");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private int parseIntOrDefault(String value, int defaultVal) {
        try { return Integer.parseInt(value); } catch (Exception e) { return defaultVal; }
    }
}