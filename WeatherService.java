package smartirrigation;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import org.json.JSONArray;
import org.json.JSONObject;

public class WeatherService {

    private String fetchAPI(String url) throws Exception {
        HttpURLConnection conn = (HttpURLConnection) new URL(url).openConnection();
        conn.setRequestMethod("GET");

        BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
        StringBuilder response = new StringBuilder();
        String line;
        while ((line = reader.readLine()) != null) response.append(line);
        reader.close();
        return response.toString();
    }

    public String getCurrentWeather(String apiKey, String location) {
        try {
            String url = "https://api.weatherapi.com/v1/current.json?key=" + apiKey + "&q=" + location + "&aqi=no";
            JSONObject json = new JSONObject(fetchAPI(url));
            return json.getJSONObject("current").getJSONObject("condition").getString("text");
        } catch (Exception e) {
            return "Weather info unavailable";
        }
    }

    public int getForecastRainChance(String apiKey, String location) {
        try {
            String url = "https://api.weatherapi.com/v1/forecast.json?key=" + apiKey + "&q=" + location + "&days=2";
            JSONObject json = new JSONObject(fetchAPI(url));
            JSONArray forecast = json.getJSONObject("forecast").getJSONArray("forecastday");
            return forecast.getJSONObject(1).getJSONObject("day").getInt("daily_chance_of_rain");
        } catch (Exception e) {
            return 0;
        }
    }

    public String getTomorrowCondition(String apiKey, String location) {
        try {
            String url = "https://api.weatherapi.com/v1/forecast.json?key=" + apiKey + "&q=" + location + "&days=2";
            JSONObject json = new JSONObject(fetchAPI(url));
            JSONArray forecast = json.getJSONObject("forecast").getJSONArray("forecastday");
            return forecast.getJSONObject(1).getJSONObject("day").getJSONObject("condition").getString("text");
        } catch (Exception e) {
            return "Unavailable";
        }
    }

    public double getTomorrowTemp(String apiKey, String location) {
        try {
            String url = "https://api.weatherapi.com/v1/forecast.json?key=" + apiKey + "&q=" + location + "&days=2";
            JSONObject json = new JSONObject(fetchAPI(url));
            JSONArray forecast = json.getJSONObject("forecast").getJSONArray("forecastday");
            return forecast.getJSONObject(1).getJSONObject("day").getDouble("avgtemp_c");
        } catch (Exception e) {
            return -999;
        }
    }
}