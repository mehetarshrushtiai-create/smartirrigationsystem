package smartirrigation;

public class WeatherCheck {
	public String weather_climate;
	public String Weather_Description;
	public int temperature;
	public String getWeather_climte() {
		return weather_climate;
	}
	public void setWeather_climte(String weather_climte) {
		this.weather_climate = weather_climte;
	}
	public String getWeather_Description() {
		return Weather_Description;
	}
	public void setWeather_Description(String weather_Description) {
		Weather_Description = weather_Description;
	}
	public int getTemperature() {
		return temperature;
	}
	public void setTemperature(int temperature) {
		this.temperature = temperature;
	}
	
	public void check() {

		    switch (weather_climate.toLowerCase()) {
		        case "rainy":
		            System.out.println(" Rainy weather detected. No need for irrigation.");
		            break;
		        case "cloudy":
		            System.out.println(" Cloudy weather. Monitor soil moisture closely.");
		            break;
		        case "sunny":
		            System.out.println(" Sunny weather. Irrigation may be needed.");
		            break;
		        default:
		            System.out.println(" Unknown weather. Please verify input.");
		            break;
		    }
		}
   		}
    


