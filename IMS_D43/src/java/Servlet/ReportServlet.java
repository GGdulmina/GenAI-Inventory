package Servlet;

import service.ReportService;
import model.ReportDTO;
import util.PdfReportGenerator;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;

/**
 * Report Servlet – daily, monthly, and stock reports.
 * Provides PDF export and JSON endpoints for chart data.
 * @author id43
 */
@WebServlet("/reports")
public class ReportServlet extends HttpServlet {

    private final ReportService reportService = new ReportService();

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

            // JSON endpoints for AJAX chart data
            if ("categoryRevenue".equals(action)) {
                sendJson(response, reportService.getCategoryRevenue());
                return;
            }
            if ("topProducts".equals(action)) {
                sendJson(response, reportService.getTopProducts());
                return;
            }

            // PDF Download endpoint
            if ("downloadPdf".equals(action)) {
                String reportType = request.getParameter("type");
                if (reportType == null) reportType = "daily";

                String dateParam = request.getParameter("date");
                if (dateParam == null || dateParam.isEmpty()) {
                    dateParam = LocalDate.now().toString(); // yyyy-MM-dd
                }

                String monthParam = request.getParameter("month");
                if (monthParam == null || monthParam.isEmpty()) {
                    monthParam = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM"));
                }

                // Fetch data packaged in DTO via Service Layer
                ReportDTO reportDTO = reportService.getReportDTO(reportType, dateParam, monthParam);

                // Set headers for download
                response.setContentType("application/pdf");
                response.setCharacterEncoding("UTF-8");
                String filename = "report_" + reportType + "_" + 
                        (reportType.equals("daily") ? dateParam : (reportType.equals("monthly") ? monthParam : "current")) 
                        + ".pdf";
                response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + "\"");

                // Generate PDF using Utility
                try (OutputStream os = response.getOutputStream()) {
                    PdfReportGenerator.generateReportPdf(reportDTO, os);
                    os.flush();
                }
                return;
            }

            // Default: render reports page
            String reportType = request.getParameter("type");
            if (reportType == null) reportType = "daily";

            String dateParam = request.getParameter("date");
            if (dateParam == null || dateParam.isEmpty()) {
                dateParam = LocalDate.now().toString(); // yyyy-MM-dd
            }

            String monthParam = request.getParameter("month");
            if (monthParam == null || monthParam.isEmpty()) {
                monthParam = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM"));
            }

            request.setAttribute("reportType", reportType);
            request.setAttribute("dateParam", dateParam);
            request.setAttribute("monthParam", monthParam);

            if ("daily".equals(reportType)) {
                request.setAttribute("reportData", reportService.getDailyReport(dateParam));
            } else if ("monthly".equals(reportType)) {
                request.setAttribute("reportData", reportService.getMonthlyReport(monthParam));
            } else if ("stock".equals(reportType)) {
                request.setAttribute("reportData", reportService.getStockReport());
            }

            request.getRequestDispatcher("/reports.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private void sendJson(HttpServletResponse response, List<Map<String, Object>> data)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < data.size(); i++) {
            if (i > 0) sb.append(",");
            sb.append("{");
            Map<String, Object> row = data.get(i);
            int j = 0;
            for (Map.Entry<String, Object> entry : row.entrySet()) {
                if (j > 0) sb.append(",");
                sb.append("\"").append(entry.getKey()).append("\":");
                if (entry.getValue() instanceof String) {
                    sb.append("\"").append(entry.getValue()).append("\"");
                } else {
                    sb.append(entry.getValue());
                }
                j++;
            }
            sb.append("}");
        }
        sb.append("]");
        out.write(sb.toString());
    }
}
