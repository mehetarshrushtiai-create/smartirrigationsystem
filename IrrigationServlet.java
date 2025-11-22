package smartirrigation;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/IrrigationServlet")
public class IrrigationServlet extends HttpServlet {

    private static final String WEATHER_API_KEY = "15e322be52504baea59191735250509";

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");

        // 🌾 Basic Parameters
        String location = request.getParameter("location");
        String crop = request.getParameter("crop");
        String soilType = request.getParameter("soilType");

        int soilMoisture = parseInt(request.getParameter("soilMoisture"), 300);
        int temperature = parseInt(request.getParameter("temperature"), 28);
        int tankCapacity = parseInt(request.getParameter("tankCapacity"), 1000);
        int tankLevel = parseInt(request.getParameter("tankLevel"), tankCapacity / 2);

        // 🌿 New Fields
        double totalLand = parseDouble(request.getParameter("totalAcreLand"), 0);
        double cropLand = parseDouble(request.getParameter("acreForCrop"), 0);
        String multipleCrops = request.getParameter("multipleCrops");
        int numMotors = parseInt(request.getParameter("numMotors"), 1);
        String motorFrequency = request.getParameter("motorFrequency");

        // Tank object (dummy class)
        WaterTank tank = new WaterTank(tankCapacity, tankLevel);

        // Weather service (dummy class)
        WeatherService weatherService = new WeatherService();
        String todayWeather = weatherService.getCurrentWeather(WEATHER_API_KEY, location);
        String tomorrowWeather = weatherService.getTomorrowCondition(WEATHER_API_KEY, location);
        int rainChance = weatherService.getForecastRainChance(WEATHER_API_KEY, location);

        // Decide irrigation
        String decision;
        int duration = 0;

        if (rainChance > 75) {
            decision = "🌧️ Rain expected tomorrow (" + rainChance + "%). Irrigation skipped.";
        } else if (tank.getCurrentLevel() < 10) {
            decision = "⚠️ Tank too low. Irrigation skipped.";
        } else if (soilMoisture > 700) {
            decision = "🌱 Soil moisture sufficient. No irrigation needed.";
        } else {
            duration = WaterTank.calculateWateringDuration(
                    soilMoisture, temperature, tank.getCurrentLevel(), rainChance, crop, soilType);
            decision = "💧 Irrigation ON for " + duration + " minutes.";
            tank.useWater(duration);
        }

        // Suggestion text
        String suggestion = "Total Land: " + totalLand + " acres | Crop Land: " + cropLand +
                " acres | Motors: " + numMotors + " | Motor Frequency: " + motorFrequency;
        if (multipleCrops != null && !multipleCrops.trim().isEmpty()) {
            suggestion += " | Multiple Crops: " + multipleCrops;
        }

        // ⚡ Set attributes with correct types
        request.setAttribute("location", location);
        request.setAttribute("crop", crop);
        request.setAttribute("soilType", soilType);
        request.setAttribute("moisture", soilMoisture);
        request.setAttribute("duration", duration);
        request.setAttribute("tank", tank.getCurrentLevel());
        request.setAttribute("decision", decision);
        request.setAttribute("todayWeather", todayWeather);
        request.setAttribute("tomorrowWeather", tomorrowWeather);
        request.setAttribute("rainChance", rainChance);

        request.setAttribute("totalLand", totalLand);
        request.setAttribute("cropLand", cropLand);
        request.setAttribute("multipleCrops", multipleCrops);
        request.setAttribute("numMotors", numMotors);
        request.setAttribute("motorFrequency", motorFrequency);
        request.setAttribute("suggestion", suggestion);

        // Forward to result.jsp
        RequestDispatcher rd = request.getRequestDispatcher("result.jsp");
        rd.forward(request, response);
    }

    // Safe parsing helpers
    private int parseInt(String val, int defaultVal) {
        try { return Integer.parseInt(val); } catch (Exception e) { return defaultVal; }
    }

    private double parseDouble(String val, double defaultVal) {
        try { return Double.parseDouble(val); } catch (Exception e) { return defaultVal; }
    }
}
