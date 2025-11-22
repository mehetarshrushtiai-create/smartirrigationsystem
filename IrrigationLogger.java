package smartirrigation;

import java.io.*;
import java.util.Scanner;

public class IrrigationLogger {

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        System.out.print("Location: ");
        String location = scanner.nextLine();

        System.out.print("Soil Moisture: ");
        int soilMoisture = scanner.nextInt();

        try (BufferedWriter writer = new BufferedWriter(new FileWriter("IrrigationLogs.txt", true))) {
            writer.write("Location: " + location + ", Soil Moisture: " + soilMoisture);
            writer.newLine();
            System.out.println("✅ Data saved to IrrigationLogs.txt");
        } catch (IOException e) {
            e.printStackTrace();
        }

        scanner.close();
    }
}