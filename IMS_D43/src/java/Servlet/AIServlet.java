// In AIServlet.java — fetches Flask API and forwards JSON to JSP
package Servlet;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.*;
import java.net.*;

public class AIServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String feature = req.getParameter("feature"); // "alerts","restock","trends","products"
        String url = "http://localhost:5000/api/ai/" + feature;

        HttpURLConnection conn = (HttpURLConnection) new URL(url).openConnection();
        conn.setRequestMethod("GET");
        BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = in.readLine()) != null) sb.append(line);
        in.close();

        // Return JSON directly to the browser (called via JS fetch)
        resp.setContentType("application/json");
        resp.getWriter().write(sb.toString());
    }
}