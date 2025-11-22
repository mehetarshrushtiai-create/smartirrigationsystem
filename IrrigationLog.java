package smartirrigation;

import java.sql.*;

public class  IrrigationLog{

    private static final String URL = "jdbc:oracle:thin:@localhost:1521/XEPDB1";
    private static final String USER = "system"; // your DB username
    private static final String PASS = "240703"; // your DB password

    public static void logData(String location, int soilMoisture, int temperature, int tankLevel, String weather, int rainChance, int duration) {
        try (Connection conn = DriverManager.getConnection(URL, USER, PASS)) {
            String sql = "INSERT INTO IrrigationLogs (location, soilMoisture, temperature, tankLevel, weather, rainChance, duration) VALUES (?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, location);
            stmt.setInt(2, soilMoisture);
            stmt.setInt(3, temperature);
            stmt.setInt(4, tankLevel);
            stmt.setString(5, weather);
            stmt.setInt(6, rainChance);
            stmt.setInt(7, duration);
            stmt.executeUpdate();
        } catch (SQLException e) {
            System.out.println("⚠️ Failed to log data: " + e.getMessage());
        }
    }
}