<!DOCTYPE html>
<html>
<head>
    <title>Sign Up - Smart Irrigation</title>
    <style>
       body {
    font-family: Arial, sans-serif;
    margin: 0;
    height: 100vh;
    display: flex;
    justify-content: center;
    align-items: center;
    background-image: url("crops.webp"), linear-gradient(-45deg, #a8e6cf, #dcedc1, #ffd3b6, #ffaaa5);
    background-size: cover, 400% 400%;
    background-blend-mode: overlay;
    animation: gradientBG 15s ease infinite;
}
       
        @keyframes gradientBG {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }

        .signup-box {
            background: rgba(255, 255, 255, 0.9);
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.2);
            width: 320px;
            text-align: center;
            transition: transform 0.3s ease;
        }

        .signup-box:hover {
            transform: scale(1.02);
        }

        input, button {
            width: 100%;
            padding: 12px;
            margin-top: 12px;
            border-radius: 8px;
            border: 1px solid #ccc;
            font-size: 14px;
        }

        button {
            background: #2e7d32;
            color: white;
            border: none;
            cursor: pointer;
            transition: background 0.3s ease;
        }

        button:hover {
            background: #1b5e20;
        }

        a {
            color: #2e7d32;
            text-decoration: none;
        }

        a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="signup-box">
        <h2>Sign Up</h2>
        <form action="SignupServlet" method="post">
            <input type="text" name="username" placeholder="Choose a username" required>
            <input type="tel" name="phonenumber" placeholder="Enter your phone number" 
         pattern="[6-9]{1}[0-9]{9}" 
         title="Enter a valid 10-digit Indian mobile number starting with 6-9" required>
         <input type="email" name="email" placeholder="Enter your email address" 
         pattern="[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$" 
         title="Enter a valid email address" required>
         <input type="password" name="password" placeholder="Choose a password" 
         pattern="(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=!]).{8,}" 
         title="Password must be at least 8 characters long and include uppercase, lowercase, number, and special character" required>
         
            <button type="submit">Register</button>
        </form>
        <p style="margin-top:10px;">
            Already have an account? <a href="irrigationjsp.jsp">Login</a>
        </p>
    </div>
</body>
</html>