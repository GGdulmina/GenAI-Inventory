package Servlet;

import dao.ItemDAO;
import dao.SalesDAO;
import dao.ReportDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Dashboard Servlet – aggregates KPI stats and forwards to dashboard.jsp.
 * @author id43
 */
@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    private ItemDAO   itemDAO   = new ItemDAO();
    private SalesDAO  salesDAO  = new SalesDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }

        try {
            request.setAttribute("totalProducts",  itemDAO.getProductCount());
            request.setAttribute("lowStockCount",   itemDAO.getLowStockCount());
            request.setAttribute("totalSales",      salesDAO.getTotalSalesCount());
            request.setAttribute("totalRevenue",    salesDAO.getTotalRevenue());
            request.setAttribute("todayRevenue",    salesDAO.getTodayRevenue());
            request.setAttribute("lowStockItems",   itemDAO.getLowStockItems());

            request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
