package Servlet;

import dao.ItemDAO;
import model.Item;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.util.List;

@WebServlet("/inventory")
public class InventoryServlet extends HttpServlet {

    private ItemDAO itemDAO = new ItemDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Session check: if no session exists, redirect to login
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect("login");
            return;
        }

        try {
            List<Item> items = itemDAO.getAllItems();
            request.setAttribute("items", items);
            request.getRequestDispatcher("/inventory.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
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
                itemDAO.addItem(item);

            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                itemDAO.deleteItem(id);
            }
            response.sendRedirect("inventory");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}