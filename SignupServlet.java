package smartirrigation;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/SignupServlet")
public class SignupServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        UserLoggerService.signUp(username, password);
        UserLoggerService.logUserEvent(username, "Signup", "Farmer", req.getRemoteAddr());

        resp.sendRedirect("login.html");
    }

    }
