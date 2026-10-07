<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login - Customer Care System</title>
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
    <link rel="stylesheet" href="style.css">
    <style>
        body {
            background: linear-gradient(135deg, #0f172a 0%, #1e1b4b 50%, #31104b 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            padding: 20px;
        }
        .login-card {
            background: rgba(255, 255, 255, 0.96);
            backdrop-filter: blur(12px);
            border-radius: 20px;
            width: 100%;
            max-width: 440px;
            padding: 40px;
            box-shadow: 0 25px 50px -12px rgba(0,0,0,0.4);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }
        .logo-box {
            text-align: center;
            margin-bottom: 28px;
        }
        .logo-box i {
            font-size: 2.8rem;
            color: #4f46e5;
            background: #e0e7ff;
            padding: 14px;
            border-radius: 16px;
            display: inline-block;
        }
        .logo-box h2 {
            font-weight: 800;
            color: #0f172a;
            margin-top: 14px;
            font-size: 1.5rem;
        }
    </style>
</head>
<body>
    <div class="login-card">
        <a href="index.jsp" style="display: inline-flex; align-items: center; gap: 6px; color: #64748b; font-size: 0.85rem; font-weight: 600; text-decoration: none; margin-bottom: 16px; transition: color 0.2s;">
            <i class="ri-arrow-left-line"></i> Back to Home
        </a>
        <div class="logo-box">
            <i class="ri-customer-service-2-fill"></i>
            <h2>CustomerCare System</h2>
            <p style="color: #64748b; font-size: 0.88rem; margin-top: 4px;">Sign in to access your portal</p>
        </div>

        <%
            String error = request.getParameter("error");
            String success = request.getParameter("success");
            String msg = request.getParameter("msg");
            if ("invalid".equals(error)) {
        %>
            <div style="background: #fee2e2; color: #991b1b; padding: 12px 16px; border-radius: 10px; font-size: 0.88rem; margin-bottom: 20px; font-weight: 600;">
                <i class="ri-error-warning-line"></i> Invalid Email or Password. Please try again.
            </div>
        <%  } else if ("registered".equals(success)) { %>
            <div style="background: #d1fae5; color: #065f46; padding: 12px 16px; border-radius: 10px; font-size: 0.88rem; margin-bottom: 20px; font-weight: 600;">
                <i class="ri-checkbox-circle-line"></i> Registration successful! You can now log in.
            </div>
        <%  } else if ("account_deactivated".equals(msg)) { %>
            <div style="background: #fffbe0; color: #b45309; padding: 12px 16px; border-radius: 10px; font-size: 0.88rem; margin-bottom: 20px; font-weight: 600;">
                <i class="ri-information-line"></i> Account deactivated successfully.
            </div>
        <%  } %>

        <form action="LoginServlet" method="post" id="loginForm">
            <div class="form-group">
                <label for="email"><i class="ri-mail-line"></i> Email Address</label>
                <input type="email" id="email" name="email" class="form-control" placeholder="name@example.com" required>
            </div>

            <div class="form-group">
                <label for="password"><i class="ri-lock-password-line"></i> Password</label>
                <input type="password" id="password" name="password" class="form-control" placeholder="••••••••" required>
            </div>

            <button type="submit" class="btn btn-primary" style="width: 100%; padding: 12px; font-size: 0.95rem; justify-content: center; margin-top: 8px;">
                <i class="ri-login-box-line"></i> Sign In
            </button>
        </form>

        <p style="text-align: center; margin-top: 24px; font-size: 0.88rem; color: #64748b;">
            Don't have an account? <a href="register.jsp" style="color: #4f46e5; font-weight: 700; text-decoration: none;">Register Now</a>
        </p>
    </div>
</body>
</html>