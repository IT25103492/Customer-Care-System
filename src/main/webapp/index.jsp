<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Care System - Support & Helpdesk</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=Outfit:wght@500;600;700;800;900&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
    
    <style>
        :root {
            --bg-accent: #eef2ff;
            --bg-accent-soft: #f5f7ff;
            --primary-blue: #4f46e5;
            --primary-blue-hover: #4338ca;
            --primary-blue-light: #e0e7ff;
            --text-dark: #0f172a;
            --text-muted: #64748b;
            --bubble-blue: #818cf8;
            --bubble-coral: #f43f5e;
            --card-bg: #ffffff;
            --transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background-color: #ffffff;
            color: var(--text-dark);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            overflow-x: hidden;
        }

        /* Top Notification Bar / Header Container */
        .page-header {
            background-color: var(--bg-accent);
            padding: 1.25rem 4rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
            position: sticky;
            top: 0;
            z-index: 100;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.03);
        }

        /* Logo */
        .brand-logo {
            display: flex;
            align-items: center;
            gap: 10px;
            text-decoration: none;
            color: var(--text-dark);
            font-family: 'Outfit', sans-serif;
            font-weight: 800;
            font-size: 1.55rem;
            letter-spacing: -0.5px;
        }

        .brand-logo .logo-icon {
            width: 38px;
            height: 38px;
            background: var(--primary-blue);
            color: white;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2rem;
            box-shadow: 0 4px 10px rgba(79, 70, 229, 0.25);
        }

        .header-right {
            display: flex;
            align-items: center;
            gap: 2.2rem;
            margin-left: auto;
        }

        /* Navigation Links */
        .nav-menu {
            display: flex;
            align-items: center;
            gap: 1.8rem;
            list-style: none;
        }

        .nav-link {
            text-decoration: none;
            color: #3f4d63;
            font-size: 0.98rem;
            font-weight: 600;
            transition: var(--transition);
            cursor: pointer;
            position: relative;
        }

        .nav-link:hover {
            color: var(--primary-blue);
        }

        .nav-link::after {
            content: '';
            position: absolute;
            bottom: -4px;
            left: 0;
            width: 0%;
            height: 2px;
            background-color: var(--primary-blue);
            transition: width 0.25s ease;
        }

        .nav-link:hover::after {
            width: 100%;
        }

        /* Header Right Controls */
        .header-actions {
            display: flex;
            align-items: center;
            gap: 1.4rem;
        }

        .btn-contact {
            text-decoration: none;
            color: var(--primary-blue);
            border: 1.8px solid #c7d2fe;
            background: rgba(255, 255, 255, 0.7);
            padding: 0.6rem 1.6rem;
            border-radius: 12px;
            font-weight: 600;
            font-size: 0.95rem;
            transition: var(--transition);
            display: inline-flex;
            align-items: center;
            gap: 6px;
            backdrop-filter: blur(4px);
        }

        .btn-contact:hover {
            background: var(--primary-blue);
            color: white;
            border-color: var(--primary-blue);
            box-shadow: 0 4px 14px rgba(79, 70, 229, 0.25);
            transform: translateY(-1px);
        }

        .lang-dropdown {
            display: flex;
            align-items: center;
            gap: 4px;
            color: #4a5568;
            font-size: 0.95rem;
            font-weight: 600;
            cursor: pointer;
            padding: 6px 10px;
            border-radius: 8px;
            transition: var(--transition);
        }

        .lang-dropdown:hover {
            background: rgba(0, 0, 0, 0.04);
            color: var(--primary-blue);
        }

        /* Hero Section */
        .hero-section {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: space-between;
            max-width: 1320px;
            margin: 0 auto;
            width: 100%;
            padding: 3.5rem 3rem 4.5rem;
            gap: 4rem;
        }

        .hero-content {
            flex: 1;
            max-width: 580px;
        }

        .hero-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: var(--primary-blue-light);
            color: var(--primary-blue);
            font-size: 0.85rem;
            font-weight: 700;
            padding: 6px 14px;
            border-radius: 20px;
            margin-bottom: 1.5rem;
            letter-spacing: 0.3px;
        }

        .hero-badge i {
            font-size: 1rem;
        }

        .hero-title {
            font-family: 'Outfit', sans-serif;
            font-size: 4.2rem;
            line-height: 1.08;
            font-weight: 800;
            color: #0f172a;
            letter-spacing: -1.5px;
            margin-bottom: 1.6rem;
        }

        .hero-description {
            font-size: 1.08rem;
            line-height: 1.7;
            color: #64748b;
            margin-bottom: 2.4rem;
            font-weight: 400;
        }

        .action-group {
            display: flex;
            align-items: center;
            gap: 1.2rem;
            flex-wrap: wrap;
        }

        /* Login Button matching the requested design */
        .btn-login {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            background: var(--primary-blue);
            color: #ffffff;
            text-decoration: none;
            font-size: 1.05rem;
            font-weight: 700;
            padding: 0.95rem 2.5rem;
            border-radius: 10px;
            box-shadow: 0 8px 20px rgba(79, 70, 229, 0.28);
            transition: var(--transition);
            border: 2px solid transparent;
        }

        .btn-login:hover {
            background: var(--primary-blue-hover);
            transform: translateY(-2px);
            box-shadow: 0 12px 26px rgba(79, 70, 229, 0.38);
            color: #ffffff;
        }

        .btn-register-secondary {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            background: #ffffff;
            color: #334155;
            text-decoration: none;
            font-size: 1.02rem;
            font-weight: 600;
            padding: 0.95rem 2rem;
            border-radius: 10px;
            border: 1.8px solid #e2e8f0;
            transition: var(--transition);
        }

        .btn-register-secondary:hover {
            border-color: var(--primary-blue);
            color: var(--primary-blue);
            background: #f8fafc;
            transform: translateY(-2px);
        }

        /* Hero Graphic / Illustration Container */
        .hero-visual {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            position: relative;
            min-height: 480px;
        }

        .illustration-container {
            width: 100%;
            max-width: 580px;
            position: relative;
        }

        /* Floating elements animation */
        @keyframes floatSlow {
            0%, 100% { transform: translateY(0px); }
            50% { transform: translateY(-10px); }
        }

        @keyframes floatReverse {
            0%, 100% { transform: translateY(0px); }
            50% { transform: translateY(8px); }
        }

        @keyframes pulseGlow {
            0%, 100% { opacity: 0.9; transform: scale(1); }
            50% { opacity: 1; transform: scale(1.05); }
        }

        .floating-chat-left {
            animation: floatSlow 4.5s ease-in-out infinite;
        }

        .floating-chat-right {
            animation: floatReverse 5s ease-in-out infinite;
        }

        .floating-heart {
            animation: floatSlow 3.8s ease-in-out infinite 0.5s;
        }

        /* Quick Info Highlights */
        .features-strip {
            background: #f8faff;
            border-top: 1px solid #eef2ff;
            border-bottom: 1px solid #eef2ff;
            padding: 2.5rem 2rem;
        }

        .features-container {
            max-width: 1200px;
            margin: 0 auto;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
            gap: 2rem;
        }

        .feature-card {
            display: flex;
            align-items: flex-start;
            gap: 1.1rem;
            background: white;
            padding: 1.5rem;
            border-radius: 14px;
            border: 1px solid #e2e8f0;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.02);
            transition: var(--transition);
        }

        .feature-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 10px 25px rgba(79, 70, 229, 0.1);
            border-color: #c7d2fe;
        }

        .feature-icon-box {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            background: var(--primary-blue-light);
            color: var(--primary-blue);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.4rem;
            flex-shrink: 0;
        }

        .feature-info h4 {
            font-size: 1.05rem;
            font-weight: 700;
            color: var(--text-dark);
            margin-bottom: 0.3rem;
        }

        .feature-info p {
            font-size: 0.88rem;
            color: var(--text-muted);
            line-height: 1.5;
        }

        /* Modal Styles */
        .modal-overlay {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(15, 23, 42, 0.6);
            backdrop-filter: blur(6px);
            z-index: 1000;
            align-items: center;
            justify-content: center;
            padding: 20px;
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .modal-overlay.active {
            display: flex;
            opacity: 1;
        }

        .modal-card {
            background: #ffffff;
            border-radius: 20px;
            width: 100%;
            max-width: 540px;
            padding: 2.2rem;
            box-shadow: 0 25px 50px rgba(0,0,0,0.25);
            position: relative;
            transform: scale(0.95);
            transition: transform 0.3s ease;
        }

        .modal-overlay.active .modal-card {
            transform: scale(1);
        }

        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
        }

        .modal-title {
            font-family: 'Outfit', sans-serif;
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--text-dark);
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .modal-close {
            background: #f1f5f9;
            border: none;
            width: 36px;
            height: 36px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2rem;
            color: #64748b;
            cursor: pointer;
            transition: var(--transition);
        }

        .modal-close:hover {
            background: #e2e8f0;
            color: #0f172a;
        }

        /* Responsive Breakpoints */
        @media (max-width: 1024px) {
            .page-header {
                padding: 1rem 2rem;
            }
            .hero-section {
                flex-direction: column-reverse;
                text-align: center;
                padding: 2rem 1.5rem;
                gap: 2.5rem;
            }
            .hero-content {
                max-width: 100%;
            }
            .hero-title {
                font-size: 3.2rem;
            }
            .action-group {
                justify-content: center;
            }
            .nav-menu {
                gap: 1.5rem;
            }
        }

        @media (max-width: 768px) {
            .nav-menu {
                display: none;
            }
            .hero-title {
                font-size: 2.6rem;
            }
            .hero-description {
                font-size: 0.98rem;
            }
            .btn-login, .btn-register-secondary {
                width: 100%;
            }
        }
    </style>
</head>
<body>

    <!-- Header Navigation -->
    <header class="page-header">
        <a href="index.jsp" class="brand-logo">
            <div class="logo-icon">
                <i class="ri-customer-service-2-fill"></i>
            </div>
            <span>Customer Care</span>
        </a>

        <!-- Right Side Nav and Actions -->
        <div class="header-right">
            <ul class="nav-menu">
                <li><a href="#about" class="nav-link" onclick="openModal('aboutModal')">About Us</a></li>
                <li><a href="#faq" class="nav-link" onclick="openModal('faqModal')">FAQ</a></li>
            </ul>

            <div class="header-actions">
                <a href="javascript:void(0)" class="btn-contact" onclick="openModal('contactModal')">
                    <i class="ri-mail-send-line"></i> Contact Us
                </a>
                <div class="lang-dropdown" title="Change Language">
                    <span>Eng</span>
                    <i class="ri-arrow-down-s-line"></i>
                </div>
            </div>
        </div>
    </header>

    <!-- Main Hero Section -->
    <main class="hero-section">
        <!-- Left Content Column -->
        <div class="hero-content">
            <div class="hero-badge">
                <i class="ri-shield-check-fill"></i> 24/7 Dedicated Support Helpdesk
            </div>
            <h1 class="hero-title">Customer<br>Service</h1>
            <p class="hero-description">
                Experience prompt, reliable, and intelligent customer care. Submit inquiries, track your support tickets, and get real-time assistance with seamless resolution.
            </p>
            
            <div class="action-group">
                <!-- Login Button placed in place of 'Read more' as requested -->
                <a href="login.jsp" class="btn-login" id="loginBtn">
                    <i class="ri-login-circle-line"></i> Login
                </a>
                <a href="register.jsp" class="btn-register-secondary" id="registerBtn">
                    <i class="ri-user-add-line"></i> Register
                </a>
            </div>
        </div>

        <!-- Right Graphic / Exact Vector Representation -->
        <div class="hero-visual">
            <div class="illustration-container">
                <svg viewBox="0 0 600 520" fill="none" xmlns="http://www.w3.org/2000/svg" style="width: 100%; height: auto; display: block;">
                    <defs>
                        <!-- Soft Gradient for Blob -->
                        <linearGradient id="blobGrad" x1="150" y1="50" x2="520" y2="480" gradientUnits="userSpaceOnUse">
                            <stop stop-color="#e0e7ff" />
                            <stop offset="1" stop-color="#eef2ff" />
                        </linearGradient>
                        
                        <!-- Indigo/Blue Shirt Grad -->
                        <linearGradient id="agentShirt" x1="220" y1="280" x2="380" y2="460" gradientUnits="userSpaceOnUse">
                            <stop stop-color="#6366f1" />
                            <stop offset="1" stop-color="#4f46e5" />
                        </linearGradient>

                        <!-- Laptop Body Grad -->
                        <linearGradient id="laptopGrad" x1="220" y1="360" x2="380" y2="480" gradientUnits="userSpaceOnUse">
                            <stop stop-color="#1e1b4b" />
                            <stop offset="1" stop-color="#0f172a" />
                        </linearGradient>

                        <!-- Shadow Filter -->
                        <filter id="softShadow" x="-10%" y="-10%" width="130%" height="130%">
                            <feDropShadow dx="0" dy="6" stdDeviation="6" flood-color="#1e293b" flood-opacity="0.08" />
                        </filter>
                    </defs>

                    <!-- Background Soft Organic Blob -->
                    <path d="M 460,140 C 530,190 560,300 510,380 C 460,460 350,470 260,460 C 180,450 120,400 130,320 C 140,240 210,180 280,130 C 350,80 410,100 460,140 Z" fill="url(#blobGrad)"/>

                    <!-- Base Platform Shadow -->
                    <ellipse cx="300" cy="468" rx="200" ry="10" fill="#e2e8f0" opacity="0.6"/>

                    <!-- Support Representative Agent Group -->
                    <g id="agentFigure">
                        <!-- Upper Body / Shoulders -->
                        <path d="M 180,460 C 180,360 230,300 300,300 C 370,300 420,360 420,460 Z" fill="url(#agentShirt)"/>
                        
                        <!-- Collar Trim / Shirt detail -->
                        <path d="M 275,302 C 290,318 310,318 325,302 L 325,320 C 310,332 290,332 275,320 Z" fill="#4338ca"/>

                        <!-- Neck -->
                        <rect x="282" y="255" width="36" height="50" rx="8" fill="#f8b688"/>

                        <!-- Head -->
                        <ellipse cx="300" cy="225" rx="42" ry="52" fill="#f8b688"/>

                        <!-- Hair -->
                        <path d="M 260,210 C 260,170 275,152 300,152 C 325,152 340,170 340,210 C 330,195 315,190 300,190 C 285,190 270,195 260,210 Z" fill="#9c5636"/>
                        <path d="M 265,195 C 275,175 325,175 335,195 C 325,185 275,185 265,195 Z" fill="#7a3f24"/>

                        <!-- Headset Band (Indigo) -->
                        <path d="M 252,225 C 252,160 348,160 348,225" stroke="#4f46e5" stroke-width="9" stroke-linecap="round" fill="none"/>
                        
                        <!-- Headset Ear Cushion Left -->
                        <rect x="244" y="205" width="16" height="42" rx="8" fill="#4f46e5"/>
                        <rect x="248" y="210" width="8" height="32" rx="4" fill="#ffffff" opacity="0.3"/>

                        <!-- Headset Ear Cushion Right -->
                        <rect x="340" y="205" width="16" height="42" rx="8" fill="#4f46e5"/>
                        <rect x="344" y="210" width="8" height="32" rx="4" fill="#ffffff" opacity="0.3"/>

                        <!-- Headset Microphone Boom & Tip -->
                        <path d="M 345,235 C 340,265 318,272 308,272" stroke="#ffffff" stroke-width="4" stroke-linecap="round" fill="none"/>
                        <circle cx="305" cy="272" r="5" fill="#f8f9fa"/>
                    </g>

                    <!-- Laptop Group (Front of Agent) -->
                    <g id="laptop">
                        <!-- Laptop Display Back Screen -->
                        <rect x="210" y="350" width="180" height="115" rx="10" fill="url(#laptopGrad)" filter="url(#softShadow)"/>
                        
                        <!-- Laptop Screen Rim & Camera -->
                        <circle cx="300" cy="358" r="2" fill="#818cf8"/>

                        <!-- Laptop Logo/Emblem on back -->
                        <circle cx="300" cy="405" r="14" fill="#4f46e5" opacity="0.95"/>

                        <!-- Laptop Keyboard Base Plate -->
                        <path d="M 195,465 L 405,465 L 390,474 L 210,474 Z" fill="#0f172a"/>
                        <!-- Touchpad notch -->
                        <rect x="282" y="468" width="36" height="4" rx="2" fill="#334155"/>
                    </g>

                    <!-- Floating Left Speech Bubble (Message lines) -->
                    <g class="floating-chat-left" filter="url(#softShadow)">
                        <path d="M 150,205 C 150,195 158,188 168,188 L 262,188 C 272,188 280,195 280,205 L 280,240 C 280,250 272,258 262,258 L 170,258 L 150,270 L 150,205 Z" fill="#6366f1"/>
                        <!-- White Message Placeholder Bars -->
                        <rect x="168" y="206" width="94" height="6" rx="3" fill="#ffffff" opacity="0.9"/>
                        <rect x="168" y="222" width="75" height="6" rx="3" fill="#ffffff" opacity="0.9"/>
                        <rect x="168" y="238" width="50" height="6" rx="3" fill="#ffffff" opacity="0.75"/>
                    </g>

                    <!-- Floating Right Speech Bubble (With Checkmark) -->
                    <g class="floating-chat-right" filter="url(#softShadow)">
                        <path d="M 370,195 C 370,185 378,178 388,178 L 482,178 C 492,178 500,185 500,195 L 500,230 C 500,240 492,248 482,248 L 400,248 L 380,260 L 380,248 L 388,248 C 378,248 370,240 370,230 Z" fill="#818cf8"/>
                        <!-- White Message Placeholder Bars -->
                        <rect x="388" y="196" width="94" height="6" rx="3" fill="#ffffff" opacity="0.9"/>
                        <rect x="388" y="212" width="80" height="6" rx="3" fill="#ffffff" opacity="0.9"/>
                        <rect x="388" y="228" width="55" height="6" rx="3" fill="#ffffff" opacity="0.75"/>
                        
                        <!-- Verified Checkmark Badge -->
                        <circle cx="498" cy="180" r="14" fill="#4f46e5" stroke="#ffffff" stroke-width="2.5"/>
                        <path d="M 492,180 L 496,184 L 504,175" stroke="#ffffff" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" fill="none"/>
                    </g>

                    <!-- Floating Heart Bubble Reaction -->
                    <g class="floating-heart" filter="url(#softShadow)">
                        <!-- Speech bubble shape for heart -->
                        <path d="M 440,290 C 440,278 450,268 462,268 L 498,268 C 510,268 520,278 520,290 L 520,316 C 520,328 510,338 498,338 L 455,338 L 440,350 L 440,290 Z" fill="#f43f5e"/>
                        <!-- White Heart Vector -->
                        <path d="M 480,314 C 480,314 464,302 464,291 C 464,284 469,280 475,280 C 478,280 480,282 480,282 C 480,282 482,280 485,280 C 491,280 496,284 496,291 C 496,302 480,314 480,314 Z" fill="#ffffff"/>
                    </g>
                </svg>
            </div>
        </div>
    </main>

    <!-- Key Feature Highlights -->
    <section class="features-strip">
        <div class="features-container">
            <div class="feature-card">
                <div class="feature-icon-box">
                    <i class="ri-ticket-2-line"></i>
                </div>
                <div class="feature-info">
                    <h4>Smart Ticketing</h4>
                    <p>Instant submission and automated priority routing for all technical & customer queries.</p>
                </div>
            </div>

            <div class="feature-card">
                <div class="feature-icon-box">
                    <i class="ri-time-line"></i>
                </div>
                <div class="feature-info">
                    <h4>Real-time Tracking</h4>
                    <p>Live escalation updates, staff responses, and instant status monitoring.</p>
                </div>
            </div>

            <div class="feature-card">
                <div class="feature-icon-box">
                    <i class="ri-chat-smile-2-line"></i>
                </div>
                <div class="feature-info">
                    <h4>Direct Feedback</h4>
                    <p>Transparent communication with dedicated support representatives at every step.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- About Us Modal -->
    <div class="modal-overlay" id="aboutModal" onclick="closeModalOutside(event, 'aboutModal')">
        <div class="modal-card">
            <div class="modal-header">
                <div class="modal-title">
                    <i class="ri-information-line" style="color: var(--primary-blue);"></i> About Our System
                </div>
                <button class="modal-close" onclick="closeModal('aboutModal')">&times;</button>
            </div>
            <p style="color: #4b5563; line-height: 1.7; margin-bottom: 1.2rem;">
                The Customer Care Management System is designed to provide end-to-end customer support, inquiry resolution, ticket escalation, and transparent communication between customers, support agents, supervisors, and managers.
            </p>
            <div style="background: #f8fafc; padding: 1rem; border-radius: 12px; border-left: 4px solid var(--primary-blue); margin-bottom: 1.5rem;">
                <h5 style="color: #0f172a; margin-bottom: 4px;">Role-Based Architecture</h5>
                <p style="font-size: 0.88rem; color: #64748b;">Specialized portals for Customers, Support Staff, Technical Teams, Supervisors, and System Administrators.</p>
            </div>
            <button onclick="closeModal('aboutModal')" style="width: 100%; padding: 0.8rem; background: var(--primary-blue); color: white; border: none; border-radius: 8px; font-weight: 600; cursor: pointer;">
                Got it
            </button>
        </div>
    </div>

    <!-- FAQ Modal -->
    <div class="modal-overlay" id="faqModal" onclick="closeModalOutside(event, 'faqModal')">
        <div class="modal-card">
            <div class="modal-header">
                <div class="modal-title">
                    <i class="ri-question-line" style="color: var(--primary-blue);"></i> Frequently Asked Questions
                </div>
                <button class="modal-close" onclick="closeModal('faqModal')">&times;</button>
            </div>
            <div style="display: flex; flex-direction: column; gap: 1rem; margin-bottom: 1.5rem;">
                <div style="background: #f8fafc; padding: 1rem; border-radius: 10px;">
                    <strong style="color: #1e293b; display: block; margin-bottom: 4px;">How do I submit a new inquiry or ticket?</strong>
                    <p style="font-size: 0.88rem; color: #64748b;">Simply register or log in to your customer account and click "New Ticket" to submit your request.</p>
                </div>
                <div style="background: #f8fafc; padding: 1rem; border-radius: 10px;">
                    <strong style="color: #1e293b; display: block; margin-bottom: 4px;">How fast will my query be answered?</strong>
                    <p style="font-size: 0.88rem; color: #64748b;">Our dedicated support team reviews and responds to high priority tickets within 15-30 minutes.</p>
                </div>
                <div style="background: #f8fafc; padding: 1rem; border-radius: 10px;">
                    <strong style="color: #1e293b; display: block; margin-bottom: 4px;">Can I escalate an unresolved issue?</strong>
                    <p style="font-size: 0.88rem; color: #64748b;">Yes, if your ticket has not received a response within the SLA, you can request an escalation to supervisors.</p>
                </div>
            </div>
            <button onclick="closeModal('faqModal')" style="width: 100%; padding: 0.8rem; background: var(--primary-blue); color: white; border: none; border-radius: 8px; font-weight: 600; cursor: pointer;">
                Close FAQ
            </button>
        </div>
    </div>

    <!-- Contact Us Modal -->
    <div class="modal-overlay" id="contactModal" onclick="closeModalOutside(event, 'contactModal')">
        <div class="modal-card">
            <div class="modal-header">
                <div class="modal-title">
                    <i class="ri-customer-service-fill" style="color: var(--primary-blue);"></i> Contact Support
                </div>
                <button class="modal-close" onclick="closeModal('contactModal')">&times;</button>
            </div>
            <div style="display: flex; flex-direction: column; gap: 1rem; margin-bottom: 1.5rem;">
                <div style="display: flex; align-items: center; gap: 12px; background: #eef2ff; padding: 12px; border-radius: 10px;">
                    <i class="ri-mail-line" style="font-size: 1.3rem; color: var(--primary-blue);"></i>
                    <div>
                        <div style="font-size: 0.8rem; color: #4338ca; font-weight: 600;">Email Helpdesk</div>
                        <div style="font-size: 0.95rem; color: #1e293b; font-weight: 600;">support@customercare.com</div>
                    </div>
                </div>
                <div style="display: flex; align-items: center; gap: 12px; background: #eef2ff; padding: 12px; border-radius: 10px;">
                    <i class="ri-phone-line" style="font-size: 1.3rem; color: var(--primary-blue);"></i>
                    <div>
                        <div style="font-size: 0.8rem; color: #4338ca; font-weight: 600;">Hotline (24/7)</div>
                        <div style="font-size: 0.95rem; color: #1e293b; font-weight: 600;">+1 (800) 555-CARE</div>
                    </div>
                </div>
                <div style="display: flex; align-items: center; gap: 12px; background: #eef2ff; padding: 12px; border-radius: 10px;">
                    <i class="ri-map-pin-line" style="font-size: 1.3rem; color: var(--primary-blue);"></i>
                    <div>
                        <div style="font-size: 0.8rem; color: #4338ca; font-weight: 600;">Headquarters</div>
                        <div style="font-size: 0.92rem; color: #1e293b; font-weight: 500;">Customer Care Tower, Suite 400</div>
                    </div>
                </div>
            </div>
            <a href="login.jsp" style="display: block; text-align: center; width: 100%; padding: 0.85rem; background: var(--primary-blue); color: white; border-radius: 8px; font-weight: 600; text-decoration: none; box-sizing: border-box;">
                Log In to Open Support Ticket
            </a>
        </div>
    </div>

    <!-- Interactive Script -->
    <script>
        function openModal(modalId) {
            const modal = document.getElementById(modalId);
            if (modal) {
                modal.classList.add('active');
            }
        }

        function closeModal(modalId) {
            const modal = document.getElementById(modalId);
            if (modal) {
                modal.classList.remove('active');
            }
        }

        function closeModalOutside(event, modalId) {
            if (event.target.id === modalId) {
                closeModal(modalId);
            }
        }

        // Close modal on Escape key
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape') {
                document.querySelectorAll('.modal-overlay').forEach(modal => {
                    modal.classList.remove('active');
                });
            }
        });
    </script>
</body>
</html>