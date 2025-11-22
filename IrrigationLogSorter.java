/*package smartirrigation;



import java.io.FileWriter;
import java.io.IOException;
import java.io.Serializable;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class IrrigationLogSorter {

    private static final String FILE_NAME = "irrigation_log.txt";

    public static void logData(String location, int soilMoisture, int temperature, int tankLevel,
                               String weather, int rainChance, Serializable string) {
        try (FileWriter writer = new FileWriter(FILE_NAME, true)) {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
            String timestamp = LocalDateTime.now().format(formatter);

            writer.write("[" + timestamp + "] "
                    + "Location: " + location
                    + ", Soil Moisture: " + soilMoisture
                    + ", Temperature: " + temperature + "°C"
                    + ", Tank Level: " + tankLevel + "L"
                    + ", Weather: " + weather
                    + ", Rain Chance: " + rainChance + "%"
                    + ", Decision: " + string + "\n");

            System.out.println("✅ Data logged successfully!");
        } catch (IOException e) {
            System.out.println("⚠️ Failed to log data: " + e.getMessage());
        }
    }
}*/
/*package smartirrigation;

import java.io.*;
import java.nio.file.*;
import java.util.*;

public class IrrigationLogSorter {
  public static void main(String[] args) throws IOException {
    List<String> lines = Files.readAllLines(Paths.get("irrigation_log.txt"));
    List<String[]> entries = new ArrayList<>();

    for (String line : lines) {
      String[] parts = line.split(",");
      if (parts.length >= 5) entries.add(parts); // crop, moisture, duration, tank, decision
    }

    entries.sort((a, b) -> Integer.compare(Integer.parseInt(a[1]), Integer.parseInt(b[1])));

    BufferedWriter writer = new BufferedWriter(new FileWriter("irrigation_log.txt"));
    for (String[] entry : entries) {
      writer.write(String.join(",", entry));
      writer.newLine();
    }
    writer.close();

    System.out.println("Log sorted by moisture level.");
  }
}*/