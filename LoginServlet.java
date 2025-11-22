package smartirrigation;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        // ✅ Allow all users to log in (demo mode)
        HttpSession session = req.getSession();
        session.setAttribute("user", username);

        // Optional: Log the login event
        UserLoggerService.logUserEvent(username, "Login (Open Access)", "DemoUser", req.getRemoteAddr());

        // Redirect to irrigation dashboard
        resp.sendRedirect("irrigationjsp.jsp");
    }
}