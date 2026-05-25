package Servlet;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.*;
import java.net.*;
import java.nio.charset.StandardCharsets;

public class AIServlet extends HttpServlet {

    private static final String BASE_URL = "http://localhost:5000/api/ai/";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String feature = req.getParameter("feature");

        if (feature == null || feature.isEmpty()) {
            sendError(resp, "Missing feature parameter");
            return;
        }

        String endpoint = BASE_URL + feature;

        try {
            HttpURLConnection conn = (HttpURLConnection) new URL(endpoint).openConnection();

            conn.setRequestMethod("GET");
            conn.setConnectTimeout(5000);   // 5s timeout
            conn.setReadTimeout(8000);      // 8s read timeout

            int status = conn.getResponseCode();

            InputStream stream = (status >= 200 && status < 300)
                    ? conn.getInputStream()
                    : conn.getErrorStream();

            String response = readStream(stream);

            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            resp.getWriter().write(response);

        } catch (Exception e) {
            // SAFE FALLBACK RESPONSE (critical for UI stability)
            resp.setContentType("application/json");
            resp.setStatus(503);

            String fallbackJson =
                    "{\"status\":\"offline\",\"message\":\"AI service unavailable\",\"data\":null}";

            resp.getWriter().write(fallbackJson);
        }
    }

    private String readStream(InputStream stream) throws IOException {
        if (stream == null) return "{}";

        BufferedReader in = new BufferedReader(
                new InputStreamReader(stream, StandardCharsets.UTF_8)
        );

        StringBuilder sb = new StringBuilder();
        String line;

        while ((line = in.readLine()) != null) {
            sb.append(line);
        }

        in.close();
        return sb.toString();
    }

    private void sendError(HttpServletResponse resp, String message) throws IOException {
        resp.setContentType("application/json");
        resp.setStatus(400);
        resp.getWriter().write("{\"error\":\"" + message + "\"}");
    }
}