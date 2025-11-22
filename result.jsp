<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*,java.nio.file.*" %>
<%
    // Retrieve attributes from servlet
    String location = (String) request.getAttribute("location");
    String crop = (String) request.getAttribute("crop");
    String soilType = (String) request.getAttribute("soilType");
    String decision = (String) request.getAttribute("decision");
    String todayWeather = (String) request.getAttribute("todayWeather");
    String tomorrowWeather = (String) request.getAttribute("tomorrowWeather");

    int rainChance = (request.getAttribute("rainChance") != null) ? (Integer) request.getAttribute("rainChance") : 0;
    double moisture = (request.getAttribute("moisture") != null) ? Double.parseDouble(request.getAttribute("moisture").toString()) : 0;
    int duration = (request.getAttribute("duration") != null) ? (Integer) request.getAttribute("duration") : 0;
    double tank = (request.getAttribute("tank") != null) ? Double.parseDouble(request.getAttribute("tank").toString()) : 0;

    double totalLand = (request.getAttribute("totalLand") != null) ? Double.parseDouble(request.getAttribute("totalLand").toString()) : 0;
    double cropLand = (request.getAttribute("cropLand") != null) ? Double.parseDouble(request.getAttribute("cropLand").toString()) : 0;
    String multipleCrops = (String) request.getAttribute("multipleCrops");
    int numMotors = (request.getAttribute("numMotors") != null) ? (Integer) request.getAttribute("numMotors") : 1;
    String motorFrequency = (String) request.getAttribute("motorFrequency");
    String suggestion = (String) request.getAttribute("suggestion");

    // Tank and irrigation alerts
    String tankAlert = (tank < 10) ? "⚠️ Tank level critically low!" : "";
    String irrigationAlert = (duration > 0) ? "💧 Irrigation ON" : "⛔ Irrigation OFF";

    // Read last 5 logs for history chart
    List<String> lines = new ArrayList<>();
    try {
        String logPath = application.getRealPath("/logs/irrigation_log.txt");
        lines = Files.readAllLines(Paths.get(logPath));
    } catch (Exception e) {}

    double[] pastMoisture = new double[5];
    double[] pastDuration = new double[5];
    int start = Math.max(0, lines.size() - 5);
    try {
        for (int i = start; i < lines.size(); i++) {
            String[] parts = lines.get(i).split(",");
            if (parts.length >= 4) {
                pastMoisture[i - start] = Double.parseDouble(parts[2].trim());
                pastDuration[i - start] = Double.parseDouble(parts[3].trim());
            }
        }
    } catch (Exception e) {}

    // Multiple crops mapping
    Map<String, Double> cropMap = new LinkedHashMap<>();
    cropMap.put(crop, cropLand); // main crop

    if (multipleCrops != null && !multipleCrops.trim().isEmpty()) {
        String[] crops = multipleCrops.split(",");
        for (String s : crops) {
            String[] parts = s.split("-");
            if (parts.length == 2) {
                String cName = parts[0].trim();
                double cAcre = 0;
                try { cAcre = Double.parseDouble(parts[1].trim()); } catch(Exception e) {}
                cropMap.put(cName, cAcre);
            }
        }
    }

    String cropNames = "";
    String cropValues = "";
    for (Map.Entry<String, Double> entry : cropMap.entrySet()) {
        cropNames += "'" + entry.getKey() + "',";
        cropValues += entry.getValue() + ",";
    }
    if (cropNames.endsWith(",")) cropNames = cropNames.substring(0, cropNames.length()-1);
    if (cropValues.endsWith(",")) cropValues = cropValues.substring(0, cropValues.length()-1);
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Smart Irrigation Result</title>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
<style>
body {
  font-family: 'Poppins', sans-serif;
  margin: 0;
  background: url('https://images.unsplash.com/photo-1596496055580-0b69ad3c0f6d?auto=format&fit=crop&w=1950&q=80') no-repeat center center fixed;
  background-size: cover;
  color: #e0e0e0;
}
.container {
  max-width: 1200px;
  margin: 50px auto;
  padding: 35px;
  background: rgba(0,100,0,0.85);
  border-radius: 25px;
  text-align: center;
}
h1 { font-size: 40px; margin-bottom: 30px; color: #76ff03; }
.card-container { display: flex; flex-wrap: wrap; justify-content: center; gap: 20px; margin-bottom: 35px; }
.card {
  flex: 1 1 220px;
  min-width: 220px;
  padding: 25px 20px;
  background: rgba(34, 49, 34, 0.8);
  border-radius: 20px;
  box-shadow: 0 10px 30px rgba(0,0,0,0.6);
}
.card h3 { font-size: 18px; font-weight: 600; color: #76ff03; margin-bottom: 12px; }
.card p { font-size: 16px; margin: 0; color: #cfd8dc; }
.alert { padding: 18px; border-radius: 15px; margin: 20px auto; width: 92%; font-weight: bold; font-size: 16px; box-shadow: 0 5px 20px rgba(0,0,0,0.5); }
.alert-warning { background: linear-gradient(90deg,#ff6f00,#ff8f00); color: #fff; }
.alert-info { background: linear-gradient(90deg,#0288d1,#03a9f4); color: #fff; }
.alert-success { background: linear-gradient(90deg,#2e7d32,#66bb6a); color: #fff; }
.irrigation-status { font-size: 20px; font-weight: 700; margin-top: 20px; padding: 14px 28px; border-radius: 15px; display: inline-block; box-shadow: 0 5px 25px rgba(0,0,0,0.5); }
.status-on { background: #00e676; color: #000; }
.status-off { background: #ff1744; color: #fff; }
.canvas-container { margin-top: 40px; }
canvas { background: rgba(0,0,0,0.5); border-radius: 15px; padding: 18px; box-shadow: 0 10px 30px rgba(0,0,0,0.6); }
</style>
</head>
<body>
<div class="container">
<h1>🌱 Smart Irrigation Dashboard</h1>

<% if(!tankAlert.isEmpty()) { %>
<div class="alert alert-warning"><%= tankAlert %></div>
<% } %>
<div class="alert alert-info">Decision: <%= decision %></div>
<div class="alert <%= duration>0 ? "alert-success" : "alert-warning" %>">Irrigation Status: <%= irrigationAlert %></div>

<div class="card-container">
  <div class="card"><h3>Location</h3><p><%= location %></p></div>
  <div class="card"><h3>Crop</h3><p><%= crop %></p></div>
  <div class="card"><h3>Soil Type</h3><p><%= soilType %></p></div>
  <div class="card"><h3>Soil Moisture</h3><p><%= moisture %>%</p></div>
  <div class="card"><h3>Irrigation Duration</h3><p><%= duration %> min</p></div>
  <div class="card"><h3>Tank Level</h3><p><%= tank %> L</p></div>
  <div class="card"><h3>Today's Weather</h3><p><%= todayWeather %></p></div>
  <div class="card"><h3>Tomorrow's Weather</h3><p><%= tomorrowWeather %> (<%= rainChance %>%)</p></div>
  <div class="card"><h3>Total Land</h3><p><%= totalLand %> acres</p></div>
  <div class="card"><h3>Crop Land</h3><p><%= cropLand %> acres</p></div>
  <div class="card"><h3>Motors</h3><p><%= numMotors %></p></div>
  <div class="card"><h3>Motor Frequency</h3><p><%= motorFrequency %></p></div>
  <% if(multipleCrops != null && !multipleCrops.isEmpty()) { %>
    <div class="card"><h3>Multiple Crops</h3><p><%= multipleCrops %></p></div>
  <% } %>
  <div class="card"><h3>Suggestions</h3><p><%= suggestion %></p></div>
</div>

<div class="irrigation-status <%= duration>0 ? "status-on" : "status-off" %>">
<%= irrigationAlert %>
</div>

<div class="canvas-container">
  <canvas id="liveChart"></canvas>
  <canvas id="historyChart"></canvas>
  <canvas id="cropChart" width="400" height="250"></canvas>
</div>

<script>
new Chart(document.getElementById('liveChart').getContext('2d'), {
  type: 'bar',
  data: { 
    labels: ['Moisture','Duration','Tank'], 
    datasets:[{ 
      label:'Live Values', 
      data:[<%= moisture %>,<%= duration %>,<%= tank %>], 
      backgroundColor:['#00e5ff','#81d4fa','#4dd0e1'] 
    }]
  },
  options:{ responsive:true, scales:{ y:{ beginAtZero:true } } }
});

new Chart(document.getElementById('historyChart').getContext('2d'), {
  type:'line',
  data:{
    labels:['S1','S2','S3','S4','S5'],
    datasets:[
      { label:'Moisture (%)', data:[<%= pastMoisture[0] %>,<%= pastMoisture[1] %>,<%= pastMoisture[2] %>,<%= pastMoisture[3] %>,<%= pastMoisture[4] %>], borderColor:'#00e5ff', fill:false },
      { label:'Duration (min)', data:[<%= pastDuration[0] %>,<%= pastDuration[1] %>,<%= pastDuration[2] %>,<%= pastDuration[3] %>,<%= pastDuration[4] %>], borderColor:'#81d4fa', fill:false }
    ]
  },
  options:{ responsive:true, scales:{ y:{ beginAtZero:true } } }
});

new Chart(document.getElementById('cropChart').getContext('2d'), {
    type: 'bar',
    data: {
        labels: [<%= cropNames %>],
        datasets: [{
            label: 'Acreage per Crop',
            data: [<%= cropValues %>],
            backgroundColor: [
                '#43a047','#66bb6a','#aed581','#ffb74d','#ffa726','#ff7043','#e57373'
            ]
        }]
    },
    options: {
        responsive: true,
        plugins: {
            legend: { display: false },
            title: { display: true, text: 'Land Allocation per Crop' }
        },
        scales: { y: { beginAtZero: true } }
    }
});
</script>
</div>
</body>
</html>
