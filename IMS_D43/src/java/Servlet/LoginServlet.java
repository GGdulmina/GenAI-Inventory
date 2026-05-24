package Servlet;

import dao.UserDAO;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try {

            UserDAO userDAO = new UserDAO();

            // Authenticate user and get full user object
            User user = userDAO.authenticate(username, password);

            if (user != null) {

                HttpSession session = request.getSession();

                // Store user info in session
                session.setAttribute("user", user);
                session.setAttribute("role", user.getRole());
                session.setAttribute("username", user.getUsername());

                session.setMaxInactiveInterval(30 * 60);

                // Role-based redirect
                if ("admin".equals(user.getRole())) {

                    response.sendRedirect(request.getContextPath() + "/dashboard.jsp");

                } else {

                    response.sendRedirect(request.getContextPath() + "/inventory");

                }

            } else {

                request.setAttribute("error", "Invalid username or password");
                request.getRequestDispatcher("/login.jsp").forward(request, response);

            }

        } catch (Exception e) {

            throw new ServletException("Login error occurred", e);

        }
    }
}