<%@ page session="true" %>
<%
    String user = (String) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.html");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Smart Irrigation</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: url('crops.webp') no-repeat center center fixed;
            background-size: cover;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .container {
            background: white;
            padding: 35px;
            border-radius: 25px;
            width: 420px;
            text-align: center;
            box-shadow: 0 15px 40px rgba(0,0,0,0.2);
        }
        input, label, select, button {
            width: 100%;
            padding: 12px;
            margin-top: 10px;
            border-radius: 10px;
            border: 1px solid #ccc;
            font-size: 16px;
        }
        button {
            background: #2e7d32;
            color: white;
            border: none;
            font-weight: bold;
            cursor: pointer;
            transition: 0.3s;
        }
        button:hover {
            background: #1b5e20;
            transform: scale(1.05);
        }
        h1 {
            color: #2e7d32;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🌱 Welcome, <%= user %>!</h1>
        <form action="IrrigationServlet" method="post">
            <label>Soil Moisture</label>
            <input type="number" name="soilMoisture" min="0" max="1023" required>

            <label>Temperature (°C)</label>
            <input type="number" name="temperature" min="-10" max="60" required>

            <label>Tank Capacity (L)</label>
            <input type="number" name="tankCapacity" required>

            <label>Tank Level (L)</label>
            <input type="number" name="tankLevel" required>

            <label>Location</label>
            <input type="text" name="location" required>

            <label>Crop Type</label>
            <select name="crop" required>
                <option value="rice">Rice</option>
                <option value="cotton">Cotton</option>
                <option value="wheat">Wheat</option>
                <option value="millet">Millet</option>
                <option value="chickpea">Chickpea</option>
            </select>

            <label>Soil Type</label>
            <select name="soilType" required>
                <option value="sandy">Sandy</option>
                <option value="clay">Clay</option>
                <option value="loamy">Loamy</option>
            </select>

            <button type="submit">Check Irrigation</button>
        </form>
    </div>
</body>
</html>