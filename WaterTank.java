package smartirrigation;

public class WaterTank {
    private int capacity;
    private double currentLevel;

    public WaterTank(int capacity, double currentLevel) {
        this.capacity = capacity;
        this.currentLevel = currentLevel;
    }

    public double getCurrentLevel() {
        return currentLevel;
    }

    public int getCapacity() {
        return capacity;
    }

    public void useWater(int amount) {
        currentLevel = Math.max(0, currentLevel - amount);
    }

    // Calculate irrigation duration based on soil, crop, weather, and tank level
    public static int calculateWateringDuration(int soilMoisture, int temperature, double tankLevel, int rainChance, String crop, String soilType) {
        if (rainChance > 70) return 0; // Skip if high chance of rain

        int duration = 5;

        // Soil moisture factor
        if (soilMoisture < 200) duration += 15;
        else if (soilMoisture < 400) duration += 10;
        else if (soilMoisture < 600) duration += 5;

        // Temperature factor
        if (temperature > 30) duration += 5;

        // Crop factor
        switch (crop.toLowerCase()) {
            case "rice": duration += 10; break;
            case "cotton": duration += 8; break;
            case "wheat": duration += 5; break;
            case "millet": duration += 3; break;
            case "chickpea": duration += 2; break;
            case "onion": duration += 6; break;
            case "tomato": duration += 7; break;
            default: duration += 4; break;
        }

        // Soil type factor
        switch (soilType.toLowerCase()) {
            case "sandy": duration += 5; break;
            case "clay": duration -= 3; break;
        }

        int maxDuration = (int)(tankLevel / 2); // Ensure tank has enough water
        return Math.max(0, Math.min(duration, maxDuration));
    }
}
