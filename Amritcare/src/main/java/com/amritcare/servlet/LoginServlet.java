package com.amritcare.servlet;

import com.amritcare.dao.UserDAO;
import com.amritcare.model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email    = req.getParameter("email").trim();
        String password = req.getParameter("password").trim();

        UserDAO dao = new UserDAO();
        User user  = dao.login(email, password);

        if (user != null) {
            // Create session and store user object
            HttpSession session = req.getSession();
            session.setAttribute("loggedUser", user);
            session.setAttribute("userId",   user.getId());
            session.setAttribute("userName", user.getName());
            session.setAttribute("userRole", user.getRole());

            // Role-based redirect
            switch (user.getRole()) {
                case "city_admin":
                    resp.sendRedirect("admin_dashboard.jsp");
                    break;
                case "hospital_admin":
                    session.setAttribute("hospitalId", user.getHospitalId());
                    resp.sendRedirect("hospital_dashboard.jsp");
                    break;
                default: // patient
                    resp.sendRedirect("dashboard.jsp");
            }
        } else {
            req.setAttribute("error", "Invalid email or password. Please try again.");
            req.getRequestDispatcher("login.jsp").forward(req, resp);
        }
    }
}
