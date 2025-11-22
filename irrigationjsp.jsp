<%@ page session="true" %>
<%
    String user = (String) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("signup.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Smart Irrigation Input Dashboard</title>
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
  <style>
    * { box-sizing: border-box; font-family: 'Poppins', sans-serif; }
    body {
      margin: 0;
      min-height: 100vh;
      background: linear-gradient(rgba(0,0,0,0.5), rgba(0,60,0,0.5)), url('6.jpeg');
      background-size: cover;
      background-position: center;
      display: flex;
      justify-content: center;
      align-items: center;
    }
    .container {
      width: 480px;
      background: rgba(255,255,255,0.95);
      padding: 40px;
      border-radius: 18px;
      box-shadow: 0 8px 25px rgba(0,0,0,0.3);
    }
    h2 {
      text-align: center;
      color: #2e7d32;
      margin-bottom: 25px;
      font-weight: 700;
    }
    .input-group {
      margin-bottom: 15px;
    }
    .input-group input, .input-group select {
      width: 100%;
      padding: 12px 15px;
      border-radius: 10px;
      border: 1px solid #ccc;
      font-size: 15px;
      outline: none;
    }
    .input-group input:focus, .input-group select:focus {
      border-color: #43a047;
      box-shadow: 0 0 8px rgba(67,160,71,0.4);
    }
    button {
      width: 100%;
      padding: 12px;
      background: linear-gradient(135deg, #43a047, #2e7d32);
      border: none;
      border-radius: 10px;
      color: white;
      font-size: 16px;
      font-weight: 600;
      cursor: pointer;
    }
    button:hover {
      background: linear-gradient(135deg, #2e7d32, #1b5e20);
    }
    #acreWarning {
      color: red;
      font-weight: bold;
      margin-bottom: 10px;
    }
    #remainingLand {
      font-style: italic;
      margin-bottom: 15px;
    }
  </style>
</head>
<body>
  <div class="container">
    <h2>Welcome <%= user %></h2>
    <form action="IrrigationServlet" method="post">

      <!-- Crop Type -->
      <div class="input-group">
        <select name="crop" required>
          <option value="">--Select Crop--</option>
          <option value="rice">Rice</option>
          <option value="wheat">Wheat</option>
          <option value="maize">Maize</option>
          <option value="sugarcane">Sugarcane</option>
          <option value="cotton">Cotton</option>
        </select>
      </div>

      <!-- Soil Type -->
      <div class="input-group">
        <select name="soilType" required>
          <option value="">--Select Soil Type--</option>
          <option value="clay">Clay</option>
          <option value="sandy">Sandy</option>
          <option value="loamy">Loamy</option>
          <option value="black">Black (Regur)</option>
          <option value="red">Red</option>
          <option value="laterite">Laterite</option>
          <option value="alluvial">Alluvial</option>
        </select>
      </div>

      <!-- Location -->
      <div class="input-group">
        <input type="text" name="location" placeholder="Enter Location" required>
      </div>

      <!-- Soil Moisture & Temperature -->
      <div class="input-group">
        <input type="number" name="soilMoisture" placeholder="Soil Moisture (0-1023)" min="0" max="1023" required>
      </div>
      <div class="input-group">
        <input type="number" name="temperature" placeholder="Temperature (°C)" min="-10" max="60" required>
      </div>

      <!-- Land Info -->
      <div class="input-group">
        <input type="number" name="totalAcreLand" placeholder="Total Land (in acres)" step="0.1" min="0" required>
      </div>
      <div class="input-group">
        <input type="number" name="acreForCrop" placeholder="Acreage for this Crop" step="0.1" min="0" required>
      </div>

      <!-- Dynamic Crop Inputs -->
      <div id="cropContainer">
        <div class="input-group">
          <input type="text" name="multipleCrops[]" placeholder="Crop Name (e.g. Wheat)">
          <input type="number" name="cropAcreage[]" placeholder="Acreage (e.g. 10)" step="0.1" min="0" oninput="validateAcreage()">
        </div>
      </div>
      <button type="button" onclick="addCropField()">Add Another Crop</button>

      <!-- Acreage Feedback -->
      <div id="acreWarning"></div>
      <div id="remainingLand"></div>

      <!-- Motors -->
      <div class="input-group">
        <input type="number" name="numMotors" placeholder="Number of Motors" min="1" required>
      </div>
      <div class="input-group">
        <select name="motorFrequency" required>
          <option value="">--Select Motor Frequency--</option>
          <option value="once">Once per day</option>
          <option value="twice">Twice per day</option>
          <option value="weekly">Weekly</option>
          <option value="custom">Custom</option>
        </select>
      </div>

      <button type="submit">Check Irrigation</button>
    </form>
  </div>

  <!-- JavaScript for dynamic crop fields and acreage validation -->
  <script>
    function addCropField() {
      const container = document.getElementById('cropContainer');
      const newGroup = document.createElement('div');
      newGroup.className = 'input-group';
      newGroup.innerHTML = `
        <input type="text" name="multipleCrops[]" placeholder="Crop Name (e.g. Rice)">
        <input type="number" name="cropAcreage[]" placeholder="Acreage (e.g. 5)" step="0.1" min="0" oninput="validateAcreage()">
      `;
      container.appendChild(newGroup);
    }

    function validateAcreage() {
      const totalLand = parseFloat(document.querySelector('input[name="totalAcreLand"]').value) || 0;
      const acreForCrop = parseFloat(document.querySelector('input[name="acreForCrop"]').value) || 0;
      const cropAcreInputs = document.querySelectorAll('input[name="cropAcreage[]"]');
      let totalUsed = acreForCrop;

      cropAcreInputs.forEach(input => {
        totalUsed += parseFloat(input.value) || 0;
      });

      const remaining = totalLand - totalUsed;
      const warning = document.getElementById('acreWarning');
      const remainingDisplay = document.getElementById('remainingLand');

      if (remaining < 0) {
        warning.textContent = "⚠️ Total crop acreage exceeds available land by " + Math.abs(remaining).toFixed(1) + " acres.";
      } else {
        warning.textContent = "";
      }

      remainingDisplay.textContent = "Remaining land: " + remaining.toFixed(1) + " acres";
    }

    document.addEventListener('DOMContentLoaded', () => {
      document.querySelector('input[name="totalAcreLand"]').addEventListener('input', validateAcreage);
      document.querySelector('input[name="acreForCrop"]').addEventListener('input', validateAcreage);
    });
  </script>
</body>
</html>