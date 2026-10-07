<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Register - CustomerCare System</title>
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
    <link rel="stylesheet" href="style.css">
    <style>
        body {
            background: linear-gradient(135deg, #0f172a 0%, #1e1b4b 50%, #31104b 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            padding: 24px;
        }
        .register-card {
            background: rgba(255, 255, 255, 0.97);
            backdrop-filter: blur(14px);
            border-radius: 22px;
            width: 100%;
            max-width: 520px;
            padding: 40px;
            box-shadow: 0 28px 56px -12px rgba(0,0,0,0.45);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }
        .logo-box {
            text-align: center;
            margin-bottom: 24px;
        }
        .logo-box .icon-wrap {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 60px;
            height: 60px;
            border-radius: 16px;
            font-size: 1.8rem;
            transition: background 0.3s, color 0.3s;
        }
        .logo-box h2 {
            font-weight: 800;
            color: #0f172a;
            margin-top: 12px;
            font-size: 1.4rem;
        }
        .logo-box p {
            color: #64748b;
            font-size: 0.88rem;
            margin-top: 4px;
        }

        /* Role Picker Tiles */
        .role-picker-label {
            font-size: 0.86rem;
            font-weight: 700;
            color: #0f172a;
            margin-bottom: 10px;
            display: block;
        }
        .role-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 10px;
            margin-bottom: 20px;
        }
        .role-tile {
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            padding: 12px 8px;
            text-align: center;
            cursor: pointer;
            transition: all 0.2s ease;
            background: #f8fafc;
        }
        .role-tile:hover {
            border-color: #4f46e5;
            background: #eef2ff;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(79,70,229,0.15);
        }
        .role-tile.selected {
            border-color: #4f46e5;
            background: linear-gradient(135deg, #4f46e5, #6366f1);
            color: #ffffff;
            box-shadow: 0 6px 16px rgba(79,70,229,0.35);
            transform: translateY(-2px);
        }
        .role-tile.selected .role-emoji,
        .role-tile.selected .role-name {
            color: #ffffff;
        }
        .role-emoji {
            font-size: 1.6rem;
            display: block;
            margin-bottom: 4px;
            line-height: 1;
        }
        .role-name {
            font-size: 0.72rem;
            font-weight: 700;
            color: #334155;
            line-height: 1.2;
        }

        /* Role badge badge next to title */
        .selected-role-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: #e0e7ff;
            color: #3730a3;
            border-radius: 20px;
            padding: 4px 12px;
            font-size: 0.78rem;
            font-weight: 700;
            margin-left: 8px;
            transition: all 0.2s;
        }
    </style>
</head>
<body>
    <div class="register-card">
        <a href="index.jsp" style="display: inline-flex; align-items: center; gap: 6px; color: #64748b; font-size: 0.85rem; font-weight: 600; text-decoration: none; margin-bottom: 16px; transition: color 0.2s;">
            <i class="ri-arrow-left-line"></i> Back to Home
        </a>

        <!-- Dynamic Header based on selected role -->
        <div class="logo-box">
            <div class="icon-wrap" id="headerIcon" style="background:#e0e7ff; color:#4f46e5;">
                <i class="ri-user-add-line"></i>
            </div>
            <h2 id="headerTitle">Create New Account
                <span class="selected-role-badge" id="roleBadge">Customer</span>
            </h2>
            <p id="headerSubtitle">Select your role below and fill in your details.</p>
        </div>

        <!-- Error Message -->
        <%
            String error = request.getParameter("error");
            if ("failed".equals(error)) {
        %>
            <div style="background: #fee2e2; color: #991b1b; padding: 12px 16px; border-radius: 10px; font-size: 0.88rem; margin-bottom: 20px; font-weight: 600;">
                <i class="ri-error-warning-line"></i> Registration failed. Email may already be in use. Please try again.
            </div>
        <%  } %>

        <form action="RegisterServlet" method="post" id="registerForm">
            <!-- Hidden field that gets updated by JS when tile is clicked -->
            <input type="hidden" name="role" id="roleInput" value="Customer">

            <!-- Role Selector Tiles -->
            <label class="role-picker-label"><i class="ri-shield-keyhole-line"></i> Select Account Role</label>
            <div class="role-grid">
                <div class="role-tile selected" onclick="selectRole('Customer', '👤', 'Customer Portal', 'Access support tickets, enquiries & feedback.', '#e0e7ff', '#4f46e5', 'ri-user-line')" id="tile-Customer">
                    <span class="role-emoji">👤</span>
                    <span class="role-name">Customer</span>
                </div>
                <div class="role-tile" onclick="selectRole('Customer Support Officer', '🎧', 'Support Officer', 'Handle tickets, respond to enquiries & assist customers.', '#dbeafe', '#1d4ed8', 'ri-headphone-line')" id="tile-Customer Support Officer">
                    <span class="role-emoji">🎧</span>
                    <span class="role-name">Support Officer</span>
                </div>
                <div class="role-tile" onclick="selectRole('Team Supervisor', '👨‍💼', 'Team Supervisor', 'Manage escalations & oversee support team workload.', '#f3e8ff', '#7c3aed', 'ri-group-line')" id="tile-Team Supervisor">
                    <span class="role-emoji">👨‍💼</span>
                    <span class="role-name">Team Supervisor</span>
                </div>
                <div class="role-tile" onclick="selectRole('Technical Staff', '🛠️', 'Technical Staff', 'Resolve assigned technical issues & update task progress.', '#d1fae5', '#065f46', 'ri-tools-line')" id="tile-Technical Staff">
                    <span class="role-emoji">🛠️</span>
                    <span class="role-name">Technical Staff</span>
                </div>
                <div class="role-tile" onclick="selectRole('Customer Care Manager', '📊', 'Care Manager', 'Monitor CSAT, feedback & service quality analytics.', '#fef3c7', '#92400e', 'ri-line-chart-line')" id="tile-Customer Care Manager">
                    <span class="role-emoji">📊</span>
                    <span class="role-name">Care Manager</span>
                </div>
                <div class="role-tile" onclick="selectRole('System Administrator', '⚙️', 'System Admin', 'Full user management & system administration access.', '#ffe4e6', '#9f1239', 'ri-admin-line')" id="tile-System Administrator">
                    <span class="role-emoji">⚙️</span>
                    <span class="role-name">System Admin</span>
                </div>
            </div>

            <!-- Form Fields -->
            <div class="form-group">
                <label for="fullName"><i class="ri-user-line"></i> Full Name</label>
                <input type="text" id="fullName" name="fullName" class="form-control" placeholder="John Doe" required>
            </div>

            <div class="form-group">
                <label for="email"><i class="ri-mail-line"></i> Email Address</label>
                <input type="email" id="email" name="email" class="form-control" placeholder="john@example.com" required>
            </div>

            <div class="form-group">
                <label for="contactNo"><i class="ri-phone-line"></i> Contact Number</label>
                <input type="text" id="contactNo" name="contactNo" class="form-control" placeholder="077 123 4567" required>
            </div>

            <div class="form-group">
                <label for="password"><i class="ri-lock-password-line"></i> Password</label>
                <input type="password" id="password" name="password" class="form-control" placeholder="Minimum 6 characters" required minlength="6">
            </div>

            <button type="submit" class="btn btn-primary" id="submitBtn" style="width: 100%; padding: 13px; font-size: 0.95rem; justify-content: center; margin-top: 8px;">
                <i class="ri-checkbox-circle-line"></i> Create Account
            </button>
        </form>

        <p style="text-align: center; margin-top: 18px; font-size: 0.88rem; color: #64748b;">
            Already have an account?
            <a href="login.jsp" style="color: #4f46e5; font-weight: 700; text-decoration: none;">Sign In</a>
        </p>

    </div>

    <script>
        // Role metadata for dynamic header changes
        const roleMeta = {
            'Customer':               { emoji: '👤', badge: 'Customer',        subtitle: 'Access support tickets, enquiries, chat & feedback.',         iconBg: '#e0e7ff', iconColor: '#4f46e5' },
            'Customer Support Officer':{ emoji: '🎧', badge: 'Support Officer', subtitle: 'Handle tickets, respond to enquiries & assist customers.',       iconBg: '#dbeafe', iconColor: '#1d4ed8' },
            'Team Supervisor':        { emoji: '👨‍💼', badge: 'Team Supervisor',  subtitle: 'Manage escalations & oversee support team workload.',           iconBg: '#f3e8ff', iconColor: '#7c3aed' },
            'Technical Staff':        { emoji: '🛠️', badge: 'Technical Staff',  subtitle: 'Resolve assigned technical issues & update task progress.',      iconBg: '#d1fae5', iconColor: '#065f46' },
            'Customer Care Manager':  { emoji: '📊', badge: 'Care Manager',     subtitle: 'Monitor CSAT, feedback & service quality analytics.',            iconBg: '#fef3c7', iconColor: '#92400e' },
            'System Administrator':   { emoji: '⚙️', badge: 'System Admin',     subtitle: 'Full user management & system administration access.',           iconBg: '#ffe4e6', iconColor: '#9f1239' },
        };

        function selectRole(role, emoji, shortLabel, subtitle, iconBg, iconColor, iconClass) {
            // Update hidden input
            document.getElementById('roleInput').value = role;

            // Remove selected from all tiles
            document.querySelectorAll('.role-tile').forEach(t => t.classList.remove('selected'));

            // Select clicked tile
            document.getElementById('tile-' + role).classList.add('selected');

            // Update header dynamically
            const meta = roleMeta[role];
            document.getElementById('roleBadge').textContent = meta.badge;
            document.getElementById('headerSubtitle').textContent = meta.subtitle;
            document.getElementById('headerIcon').style.background = iconBg;
            document.getElementById('headerIcon').style.color = iconColor;
            document.getElementById('headerIcon').innerHTML = '<i class="' + iconClass + '"></i>';

            // Update submit button color to match role
            document.getElementById('submitBtn').style.background = iconColor;
        }
    </script>
</body>
</html>