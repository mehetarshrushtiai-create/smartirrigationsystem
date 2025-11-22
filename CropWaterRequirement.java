package smartirrigation;

import java.util.HashMap;
import java.util.Map;

public class CropWaterRequirement {

    private static final Map<String, Integer> cropWaterMap = new HashMap<>();

    static {
        cropWaterMap.put("rice", 1400);
        cropWaterMap.put("wheat", 550);
        cropWaterMap.put("cotton", 1000);
        cropWaterMap.put("maize", 650);
        cropWaterMap.put("jowar", 450);
        cropWaterMap.put("bajra", 375);
        cropWaterMap.put("sugarcane", 2000);
        cropWaterMap.put("soybean", 600);
        cropWaterMap.put("groundnut", 750);
        cropWaterMap.put("tur", 700);
        cropWaterMap.put("chickpea", 400);
        cropWaterMap.put("sunflower", 650);
        cropWaterMap.put("onion", 450);
        cropWaterMap.put("tomato", 700);
        cropWaterMap.put("banana", 1600);
        cropWaterMap.put("grapes", 1000);
        cropWaterMap.put("mango", 850);
    }

    public static int getWaterForCrop(String crop) {
        return cropWaterMap.getOrDefault(crop.toLowerCase(), 500); // default 500 mm/season
    }

	public static int getWaterRequirement(String crop) {
		// TODO Auto-generated method stub
		return 0;
	}
}
