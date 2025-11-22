package smartirrigation;

public class IrrigationController {
    public static void main(String[] args) {
        ArduinoConnector arduino = new ArduinoConnector("COM3"); // Replace COM3 with your Arduino port

        double soilMoisture = 25.0; // Replace with your Hibernate DB query

        if (soilMoisture < 30.0) {
            arduino.sendCommand("ON");
        } else {
            arduino.sendCommand("OFF");
        }

        arduino.close();
    }
}
