package smartirrigation;

import java.io.FileWriter;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class UserLoggerService {

    private static final String FILE_NAME = "user_log.csv";

    public static void logUserEvent(String username, String action, String role, String ipAddress) {
        try (FileWriter writer = new FileWriter(FILE_NAME, true)) {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
            String timestamp = LocalDateTime.now().format(formatter);

            writer.write(timestamp + "," + username + "," + role + "," + action + "," + ipAddress + "\n");

            System.out.println("✅ User event logged successfully!");
        } catch (IOException e) {
            System.out.println("⚠️ Failed to log user event: " + e.getMessage());
        }}

	public static boolean isValidUser(String username, String password) {
		// TODO Auto-generated method stub
		return false;
	}

	public static void signUp(String username, String password) {
		// TODO Auto-generated method stub
		
	}}

	//public static void signUp(String username, String password) {
		// TODO Auto-generated method stub
	
    
