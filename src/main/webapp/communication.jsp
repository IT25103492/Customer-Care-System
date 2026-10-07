<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%@ page import="model.Ticket" %>
<%@ page import="model.Message" %>
<%@ page import="dao.TicketDAO" %>
<%@ page import="dao.MessageDAO" %>
<%@ page import="dao.UserDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    boolean isCustomer = "Customer".equalsIgnoreCase(user.getRole());

    String ticketIdStr = request.getParameter("ticketId");
    String chatUserIdStr = request.getParameter("userId");
    
    int ticketId = (ticketIdStr != null && !ticketIdStr.trim().isEmpty()) ? Integer.parseInt(ticketIdStr.trim()) : 0;
    int chatUserId = (chatUserIdStr != null && !chatUserIdStr.trim().isEmpty()) ? Integer.parseInt(chatUserIdStr.trim()) : 0;

    TicketDAO ticketDAO = new TicketDAO();
    UserDAO userDAO = new UserDAO();
    MessageDAO messageDAO = new MessageDAO();

    List<Ticket> allUserTickets = null;
    if (isCustomer) {
        allUserTickets = ticketDAO.getTicketsByUserId(user.getUserId());
    } else {
        allUserTickets = ticketDAO.getAllTickets();
    }

    List<Integer> directChatPartnerIds = messageDAO.getDirectChatUserIds(user.getUserId());
    List<User> directChatPartners = new ArrayList<>();
    if (directChatPartnerIds != null) {
        for (Integer pid : directChatPartnerIds) {
            User u = userDAO.getUserById(pid);
            if (u != null) {
                directChatPartners.add(u);
            }
        }
    }

    // All registered users for the "Start New Chat" modal
    List<User> allRegisteredUsers = userDAO.getAllUsers();

    Ticket activeTicket = null;
    User activeChatUser = null;
    List<Message> chatMessages = null;

    if (chatUserId > 0) {
        activeChatUser = userDAO.getUserById(chatUserId);
        chatMessages = messageDAO.getDirectMessages(user.getUserId(), chatUserId);
    } else if (ticketId > 0) {
        activeTicket = ticketDAO.getTicketById(ticketId);
        chatMessages = messageDAO.getMessagesByTicketId(ticketId);
    } else if (allUserTickets != null && !allUserTickets.isEmpty()) {
        activeTicket = allUserTickets.get(0);
        ticketId = activeTicket.getTicketId();
        chatMessages = messageDAO.getMessagesByTicketId(ticketId);
    } else if (!directChatPartners.isEmpty()) {
        activeChatUser = directChatPartners.get(0);
        chatUserId = activeChatUser.getUserId();
        chatMessages = messageDAO.getDirectMessages(user.getUserId(), chatUserId);
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Communication Hub - CustomerCare</title>
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
    <link rel="stylesheet" href="style.css">
    <style>
        .msg-action-btn {
            background: none;
            border: none;
            cursor: pointer;
            padding: 2px 6px;
            font-size: 0.82rem;
            opacity: 0.6;
            transition: all 0.2s;
            color: inherit;
        }
        .msg-action-btn:hover {
            opacity: 1;
            transform: scale(1.1);
        }
        .chat-bubble {
            position: relative;
            margin-bottom: 14px;
            max-width: 75%;
            word-wrap: break-word;
        }
        .chat-bubble .msg-actions {
            display: none;
            position: absolute;
            top: -10px;
            right: 10px;
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 14px;
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1);
            padding: 2px 6px;
            gap: 4px;
            z-index: 5;
        }
        .chat-bubble:hover .msg-actions {
            display: inline-flex;
        }
        .tab-btn {
            padding: 8px 12px;
            border: none;
            background: none;
            font-weight: 700;
            font-size: 0.85rem;
            color: #64748b;
            cursor: pointer;
            border-bottom: 2px solid transparent;
            transition: all 0.2s;
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .tab-btn.active {
            color: #4f46e5;
            border-bottom-color: #4f46e5;
        }
    </style>
</head>
<body>
    <div class="app-container">
        <!-- Universal Sidebar Navigation -->
        <aside class="sidebar">
            <div>
                <div class="brand-title">
                    <i class="ri-customer-service-2-fill"></i>
                    <span>CustomerCare</span>
                    <span class="role-tag"><%= user.getRole() %></span>
                </div>
                <ul class="nav-links">
                    <% if (isCustomer) { %>
                        <li><a href="customer_dashboard.jsp"><i class="ri-dashboard-line"></i> Dashboard</a></li>
                        <li><a href="tickets.jsp"><i class="ri-ticket-2-line"></i> Support Tickets</a></li>
                        <li><a href="new_enquiry.jsp"><i class="ri-question-line"></i> General Enquiries</a></li>
                        <li><a href="escalation.jsp"><i class="ri-alarm-warning-line"></i> Issue Escalations</a></li>
                        <li><a href="feedback.jsp"><i class="ri-star-smile-line"></i> My Feedback</a></li>
                    <% } else { %>
                        <% if ("Customer Support Officer".equalsIgnoreCase(user.getRole())) { %>
                            <li><a href="support_dashboard.jsp"><i class="ri-dashboard-line"></i> Officer Dashboard</a></li>
                        <% } else if ("Team Supervisor".equalsIgnoreCase(user.getRole())) { %>
                            <li><a href="supervisor_dashboard.jsp"><i class="ri-dashboard-line"></i> Supervisor Dashboard</a></li>
                        <% } else if ("Technical Staff".equalsIgnoreCase(user.getRole())) { %>
                            <li><a href="technical_dashboard.jsp"><i class="ri-dashboard-line"></i> Tech Dashboard</a></li>
                        <% } else if ("Customer Care Manager".equalsIgnoreCase(user.getRole())) { %>
                            <li><a href="manager_dashboard.jsp"><i class="ri-dashboard-line"></i> Manager Dashboard</a></li>
                        <% } else if ("System Administrator".equalsIgnoreCase(user.getRole())) { %>
                            <li><a href="admin_dashboard.jsp"><i class="ri-dashboard-line"></i> Admin Dashboard</a></li>
                        <% } %>
                        <li><a href="manage_tickets.jsp"><i class="ri-ticket-2-line"></i> Ticket Management</a></li>
                        <li><a href="manage_enquiries.jsp"><i class="ri-question-answer-line"></i> Enquiry Management</a></li>
                        <li><a href="escalation.jsp"><i class="ri-alarm-warning-line"></i> Escalation Hub</a></li>
                    <% } %>
                    <li><a href="communication.jsp" class="active"><i class="ri-chat-3-fill"></i> Communication Hub</a></li>
                    <li><a href="profile.jsp"><i class="ri-user-settings-line"></i> Profile Settings</a></li>
                </ul>
            </div>
            <div class="sidebar-user">
                <div class="user-avatar"><%= user.getFullName().substring(0, 1) %></div>
                <div class="user-info">
                    <div class="name"><%= user.getFullName() %></div>
                    <div class="role"><%= user.getEmail() %></div>
                </div>
                <a href="LogoutServlet" style="margin-left: auto; color: #ef4444; font-size: 1.2rem;" title="Logout"><i class="ri-logout-box-r-line"></i></a>
            </div>
        </aside>

        <!-- Main Content -->
        <main class="main-content">
            <div class="top-bar">
                <div class="page-header">
                    <h1>Communication Hub & Live Messaging</h1>
                    <p>Direct staff-to-customer and staff-to-staff messaging, ticket threads, read receipts with notifications, message editing, and chat history management.</p>
                </div>
                <div class="top-actions">
                    <button onclick="document.getElementById('newDirectChatModal').classList.add('show')" class="btn btn-primary btn-sm">
                        <i class="ri-chat-new-line"></i> + Start New Chat
                    </button>
                </div>
            </div>

            <div style="display: grid; grid-template-columns: 340px 1fr; gap: 20px;">
                <!-- Thread Selector Column -->
                <div class="card" style="padding: 16px; display:flex; flex-direction:column; height:750px;">
                    <!-- Navigation Tabs: Ticket Threads vs Direct Chats -->
                    <div style="display: flex; border-bottom: 1px solid #e2e8f0; margin-bottom: 12px;">
                        <button id="tabTicketsBtn" class="tab-btn <%= (activeTicket != null) ? "active" : "" %>" onclick="switchChatTab('tickets')">
                            <i class="ri-ticket-line"></i> Ticket Threads (<%= allUserTickets != null ? allUserTickets.size() : 0 %>)
                        </button>
                        <button id="tabDirectBtn" class="tab-btn <%= (activeChatUser != null) ? "active" : "" %>" onclick="switchChatTab('direct')">
                            <i class="ri-user-voice-line"></i> Direct Chats (<%= directChatPartners.size() %>)
                        </button>
                    </div>

                    <input type="text" id="threadFilterInput" onkeyup="filterThreads()" placeholder="Search conversations..." class="form-control" style="font-size:0.8rem; margin-bottom:12px; padding:6px 10px;">

                    <!-- Ticket Threads List -->
                    <div id="ticketThreadsContainer" style="display: <%= (activeTicket != null || (activeChatUser == null && !directChatPartners.isEmpty() == false)) ? "flex" : "none" %>; flex-direction: column; gap: 8px; overflow-y: auto; flex:1;">
                        <% if (allUserTickets != null && !allUserTickets.isEmpty()) {
                            for (Ticket t : allUserTickets) {
                                boolean isActive = (activeTicket != null && t.getTicketId() == activeTicket.getTicketId());
                        %>
                            <a href="communication.jsp?ticketId=<%= t.getTicketId() %>" style="text-decoration: none;" class="thread-item">
                                <div style="padding: 12px; border-radius: 10px; border: 1px solid <%= isActive ? "#4f46e5" : "#e2e8f0" %>; background: <%= isActive ? "#e0e7ff" : "#ffffff" %>; transition: all 0.2s;">
                                    <div style="display: flex; justify-content: space-between; font-size: 0.8rem; font-weight: 700; color: #1e293b;">
                                        <span><%= t.getTicketNumber() != null ? t.getTicketNumber() : "#TCK-" + t.getTicketId() %></span>
                                        <span class="badge badge-open" style="font-size:0.68rem; padding:2px 6px;"><%= t.getStatus() %></span>
                                    </div>
                                    <div style="font-size: 0.85rem; color: #334155; font-weight: 600; margin-top: 4px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
                                        <%= t.getSubject() %>
                                    </div>
                                    <div style="font-size: 0.75rem; color: #64748b; margin-top: 4px;">
                                        <i class="ri-user-line"></i> <%= t.getCustomerName() != null ? t.getCustomerName() : "Customer" %>
                                    </div>
                                </div>
                            </a>
                        <%  }
                           } else { %>
                            <p style="color:#94a3b8; font-size:0.85rem; text-align:center; padding:30px;">No support ticket threads found.</p>
                        <% } %>
                    </div>

                    <!-- Direct Chats List -->
                    <div id="directChatsContainer" style="display: <%= (activeChatUser != null) ? "flex" : "none" %>; flex-direction: column; gap: 8px; overflow-y: auto; flex:1;">
                        <% if (!directChatPartners.isEmpty()) {
                            for (User partner : directChatPartners) {
                                boolean isActive = (activeChatUser != null && partner.getUserId() == activeChatUser.getUserId());
                        %>
                            <a href="communication.jsp?userId=<%= partner.getUserId() %>" style="text-decoration: none;" class="thread-item">
                                <div style="padding: 12px; border-radius: 10px; border: 1px solid <%= isActive ? "#4f46e5" : "#e2e8f0" %>; background: <%= isActive ? "#e0e7ff" : "#ffffff" %>; display:flex; align-items:center; gap:10px; transition: all 0.2s;">
                                    <div style="width:36px; height:36px; border-radius:50%; background:#4f46e5; color:#fff; display:flex; align-items:center; justify-content:center; font-weight:700; font-size:0.9rem;">
                                        <%= partner.getFullName().substring(0, 1) %>
                                    </div>
                                    <div style="flex:1; overflow:hidden;">
                                        <div style="font-weight:700; font-size:0.85rem; color:#1e293b; white-space:nowrap; overflow:hidden; text-overflow:ellipsis;">
                                            <%= partner.getFullName() %>
                                        </div>
                                        <div style="font-size:0.72rem; color:#64748b;">
                                            <%= partner.getRole() %>
                                        </div>
                                    </div>
                                </div>
                            </a>
                        <%  }
                           } else { %>
                            <div style="color:#94a3b8; font-size:0.85rem; text-align:center; padding:30px;">
                                <p>No direct chats yet.</p>
                                <button onclick="document.getElementById('newDirectChatModal').classList.add('show')" class="btn btn-sm btn-primary" style="margin-top:8px;">Start New Chat</button>
                            </div>
                        <% } %>
                    </div>
                </div>

                <!-- Chat Box Column -->
                <div class="chat-box" style="display:flex; flex-direction:column; height:750px; background:#fff; border-radius:16px; border:1px solid #e2e8f0; overflow:hidden;">
                    <% if (activeTicket != null) { %>
                        <!-- Ticket Chat Header -->
                        <div class="chat-header" style="padding:16px 20px; border-bottom:1px solid #e2e8f0; display:flex; justify-content:space-between; align-items:center; background:#f8fafc;">
                            <div>
                                <h3 style="font-size: 1.05rem; font-weight: 800; color: #0f172a; margin:0;">
                                    <%= activeTicket.getTicketNumber() %>: <%= activeTicket.getSubject() %>
                                </h3>
                                <p style="font-size: 0.8rem; color: #64748b; margin:4px 0 0 0;">
                                    Customer: <strong><%= activeTicket.getCustomerName() %></strong> | 
                                    Assigned: <strong><%= activeTicket.getAssignedToName() != null ? activeTicket.getAssignedToName() : "Support Team" %></strong>
                                </p>
                            </div>
                            <div style="display:flex; align-items:center; gap:8px;">
                                <% if (!isCustomer) { %>
                                    <!-- MARK AS READ BUTTON: triggers customer notification -->
                                    <form action="MessageServlet" method="post" style="display:inline-flex;">
                                        <input type="hidden" name="action" value="mark_read">
                                        <input type="hidden" name="ticketId" value="<%= activeTicket.getTicketId() %>">
                                        <button type="submit" class="btn btn-sm" style="background:#ecfdf5; color:#059669; border:1px solid #a7f3d0; font-weight:600;" title="Mark messages as read and notify customer">
                                            <i class="ri-check-double-line"></i> Mark as Read (Notify Customer)
                                        </button>
                                    </form>
                                <% } %>

                                <% if (!isCustomer) { %>
                                <!-- CLEAR CHAT ACTION -->
                                <form action="MessageServlet" method="post" style="display:inline-flex;" onsubmit="return confirm('Are you sure you want to clear/delete all chat history for this ticket?');">
                                    <input type="hidden" name="action" value="delete_chat">
                                    <input type="hidden" name="ticketId" value="<%= activeTicket.getTicketId() %>">
                                    <button type="submit" class="btn btn-danger btn-sm" title="Delete All Chat Messages">
                                        <i class="ri-delete-bin-line"></i> Clear Chat
                                    </button>
                                </form>
                                <% } %>

                                <span class="badge badge-open"><%= activeTicket.getStatus() %></span>
                            </div>
                        </div>

                        <!-- Chat Messages View -->
                        <div class="chat-messages" id="chatMessagesContainer" style="flex:1; padding:20px; overflow-y:auto; background:#f8fafc;">
                            <!-- Initial Ticket Description Bubble -->
                            <div class="chat-bubble received" style="background:#ffffff; border:1px solid #cbd5e1;">
                                <div style="font-weight:700; font-size:0.8rem; color:#4f46e5; margin-bottom:4px;">
                                    <i class="ri-information-line"></i> <%= activeTicket.getCustomerName() %> (Customer Initial Description)
                                </div>
                                <div style="color:#334155; font-size:0.9rem;"><%= activeTicket.getDescription() %></div>
                                <div class="meta" style="margin-top:6px; font-size:0.75rem; color:#94a3b8;">
                                    <span><%= activeTicket.getCreatedAt() != null ? activeTicket.getCreatedAt().toString().substring(0, 16) : "" %></span>
                                </div>
                            </div>

                            <% if (chatMessages != null && !chatMessages.isEmpty()) {
                                for (Message msg : chatMessages) {
                                    boolean isSelf = (msg.getSenderId() == user.getUserId());
                            %>
                                <div class="chat-bubble <%= isSelf ? "sent" : "received" %>">
                                    <!-- Action Buttons on Message (Edit / Delete / Mark Read) -->
                                    <div class="msg-actions">
                                        <% if (isSelf) { %>
                                            <button onclick="openEditMessageModal(<%= msg.getMessageId() %>, '<%= msg.getMessageText().replace("'", "\\'").replace("\"", "&quot;").replace("\n", " ") %>')" class="msg-action-btn" title="Edit Message" style="color:#4f46e5;">
                                                <i class="ri-edit-line"></i>
                                            </button>
                                        <% } %>
                                        <% if (!isSelf && !isCustomer && !msg.isRead()) { %>
                                            <form action="MessageServlet" method="post" style="display:inline;">
                                                <input type="hidden" name="action" value="mark_read">
                                                <input type="hidden" name="messageId" value="<%= msg.getMessageId() %>">
                                                <input type="hidden" name="ticketId" value="<%= activeTicket.getTicketId() %>">
                                                <button type="submit" class="msg-action-btn" title="Mark this message as read & notify customer" style="color:#059669;">
                                                    <i class="ri-check-line"></i>
                                                </button>
                                            </form>
                                        <% } %>
                                        <form action="MessageServlet" method="post" style="display:inline;" onsubmit="return confirm('Delete this message?');">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="messageId" value="<%= msg.getMessageId() %>">
                                            <input type="hidden" name="ticketId" value="<%= activeTicket.getTicketId() %>">
                                            <button type="submit" class="msg-action-btn" title="Delete Message" style="color:#ef4444;">
                                                <i class="ri-delete-bin-line"></i>
                                            </button>
                                        </form>
                                    </div>

                                    <div style="font-weight:700; font-size:0.78rem; opacity:0.9; margin-bottom:4px;">
                                        <%= msg.getSenderName() %> (<%= msg.getSenderRole() != null ? msg.getSenderRole() : "User" %>)
                                    </div>

                                    <div style="font-size:0.92rem; line-height:1.4;"><%= msg.getMessageText() %></div>

                                    <div class="meta" style="display:flex; justify-content:space-between; align-items:center; gap:8px; margin-top:6px; font-size:0.72rem; opacity:0.8;">
                                        <span><%= msg.getSentAt() != null ? msg.getSentAt().toString().substring(11, 16) : "" %></span>
                                        <span>
                                            <% if (msg.isEdited()) { %>
                                                <em style="font-size:0.7rem; color:#64748b;">(edited)</em>
                                            <% } %>
                                            <% if (msg.isRead()) { %>
                                                <span style="color:#059669; font-weight:700; margin-left:4px;" title="Read by recipient"><i class="ri-check-double-line"></i> Read</span>
                                            <% } else { %>
                                                <span style="color:#94a3b8; margin-left:4px;" title="Unread"><i class="ri-check-line"></i> Sent</span>
                                            <% } %>
                                        </span>
                                    </div>
                                </div>
                            <%  }
                               } else { %>
                                <div style="text-align:center; padding:40px; color:#94a3b8;">
                                    <i class="ri-chat-smile-3-line" style="font-size:2.5rem; display:block; margin-bottom:8px;"></i>
                                    No chat messages yet for this ticket. Type a message below to start communicating!
                                </div>
                            <% } %>
                        </div>

                        <!-- Ticket Chat Input Form -->
                        <form action="MessageServlet" method="post" class="chat-input" style="padding:16px 20px; background:#ffffff; border-top:1px solid #e2e8f0; display:flex; gap:12px; align-items:center;">
                            <input type="hidden" name="ticketId" value="<%= activeTicket.getTicketId() %>">
                            <input type="hidden" name="receiverId" value="<%= isCustomer ? (activeTicket.getAssignedTo() > 0 ? activeTicket.getAssignedTo() : 0) : activeTicket.getUserId() %>">
                            <input type="text" name="messageText" class="form-control" placeholder="Type your reply message..." required style="flex:1; border-radius:10px; font-size:0.9rem;">
                            <button type="submit" class="btn btn-primary" style="border-radius:10px; padding:10px 20px;">
                                <i class="ri-send-plane-fill"></i> Send
                            </button>
                        </form>

                    <% } else if (activeChatUser != null) { %>
                        <!-- Direct Chat Header -->
                        <div class="chat-header" style="padding:16px 20px; border-bottom:1px solid #e2e8f0; display:flex; justify-content:space-between; align-items:center; background:#f8fafc;">
                            <div style="display:flex; align-items:center; gap:12px;">
                                <div style="width:42px; height:42px; border-radius:50%; background:#4f46e5; color:#fff; display:flex; align-items:center; justify-content:center; font-weight:800; font-size:1.1rem;">
                                    <%= activeChatUser.getFullName().substring(0, 1) %>
                                </div>
                                <div>
                                    <h3 style="font-size: 1.05rem; font-weight: 800; color: #0f172a; margin:0;">
                                        <%= activeChatUser.getFullName() %>
                                    </h3>
                                    <p style="font-size: 0.8rem; color: #64748b; margin:2px 0 0 0;">
                                        Role: <strong><%= activeChatUser.getRole() %></strong> | Email: <%= activeChatUser.getEmail() %>
                                    </p>
                                </div>
                            </div>
                            <div style="display:flex; align-items:center; gap:8px;">
                                <!-- MARK AS READ BUTTON FOR DIRECT CHAT -->
                                <form action="MessageServlet" method="post" style="display:inline-flex;">
                                    <input type="hidden" name="action" value="mark_read">
                                    <input type="hidden" name="chatUserId" value="<%= activeChatUser.getUserId() %>">
                                    <button type="submit" class="btn btn-sm" style="background:#ecfdf5; color:#059669; border:1px solid #a7f3d0; font-weight:600;" title="Mark messages as read and notify sender">
                                        <i class="ri-check-double-line"></i> Mark as Read
                                    </button>
                                </form>

                                <% if (!isCustomer) { %>
                                <!-- CLEAR DIRECT CHAT -->
                                <form action="MessageServlet" method="post" style="display:inline-flex;" onsubmit="return confirm('Are you sure you want to delete all messages with <%= activeChatUser.getFullName() %>?');">
                                    <input type="hidden" name="action" value="delete_chat">
                                    <input type="hidden" name="chatUserId" value="<%= activeChatUser.getUserId() %>">
                                    <button type="submit" class="btn btn-danger btn-sm" title="Clear Conversation">
                                        <i class="ri-delete-bin-line"></i> Clear Chat
                                    </button>
                                </form>
                                <% } %>
                            </div>
                        </div>

                        <!-- Direct Chat Messages View -->
                        <div class="chat-messages" id="chatMessagesContainer" style="flex:1; padding:20px; overflow-y:auto; background:#f8fafc;">
                            <% if (chatMessages != null && !chatMessages.isEmpty()) {
                                for (Message msg : chatMessages) {
                                    boolean isSelf = (msg.getSenderId() == user.getUserId());
                            %>
                                <div class="chat-bubble <%= isSelf ? "sent" : "received" %>">
                                    <!-- Action Buttons on Message (Edit / Delete) -->
                                    <div class="msg-actions">
                                        <% if (isSelf) { %>
                                            <button onclick="openEditMessageModal(<%= msg.getMessageId() %>, '<%= msg.getMessageText().replace("'", "\\'").replace("\"", "&quot;").replace("\n", " ") %>')" class="msg-action-btn" title="Edit Message" style="color:#4f46e5;">
                                                <i class="ri-edit-line"></i>
                                            </button>
                                        <% } %>
                                        <form action="MessageServlet" method="post" style="display:inline;" onsubmit="return confirm('Delete this message?');">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="messageId" value="<%= msg.getMessageId() %>">
                                            <input type="hidden" name="chatUserId" value="<%= activeChatUser.getUserId() %>">
                                            <button type="submit" class="msg-action-btn" title="Delete Message" style="color:#ef4444;">
                                                <i class="ri-delete-bin-line"></i>
                                            </button>
                                        </form>
                                    </div>

                                    <div style="font-weight:700; font-size:0.78rem; opacity:0.9; margin-bottom:4px;">
                                        <%= msg.getSenderName() %> (<%= msg.getSenderRole() != null ? msg.getSenderRole() : "User" %>)
                                    </div>

                                    <div style="font-size:0.92rem; line-height:1.4;"><%= msg.getMessageText() %></div>

                                    <div class="meta" style="display:flex; justify-content:space-between; align-items:center; gap:8px; margin-top:6px; font-size:0.72rem; opacity:0.8;">
                                        <span><%= msg.getSentAt() != null ? msg.getSentAt().toString().substring(11, 16) : "" %></span>
                                        <span>
                                            <% if (msg.isEdited()) { %>
                                                <em style="font-size:0.7rem; color:#64748b;">(edited)</em>
                                            <% } %>
                                            <% if (msg.isRead()) { %>
                                                <span style="color:#059669; font-weight:700; margin-left:4px;" title="Read by recipient"><i class="ri-check-double-line"></i> Read</span>
                                            <% } else { %>
                                                <span style="color:#94a3b8; margin-left:4px;" title="Unread"><i class="ri-check-line"></i> Sent</span>
                                            <% } %>
                                        </span>
                                    </div>
                                </div>
                            <%  }
                               } else { %>
                                <div style="text-align:center; padding:40px; color:#94a3b8;">
                                    <i class="ri-chat-1-line" style="font-size:2.5rem; display:block; margin-bottom:8px;"></i>
                                    No direct messages yet with <%= activeChatUser.getFullName() %>. Send a message below to start chatting!
                                </div>
                            <% } %>
                        </div>

                        <!-- Direct Chat Input Form -->
                        <form action="MessageServlet" method="post" class="chat-input" style="padding:16px 20px; background:#ffffff; border-top:1px solid #e2e8f0; display:flex; gap:12px; align-items:center;">
                            <input type="hidden" name="receiverId" value="<%= activeChatUser.getUserId() %>">
                            <input type="hidden" name="chatUserId" value="<%= activeChatUser.getUserId() %>">
                            <input type="text" name="messageText" class="form-control" placeholder="Type direct message to <%= activeChatUser.getFullName() %>..." required style="flex:1; border-radius:10px; font-size:0.9rem;">
                            <button type="submit" class="btn btn-primary" style="border-radius:10px; padding:10px 20px;">
                                <i class="ri-send-plane-fill"></i> Send
                            </button>
                        </form>
                    <% } else { %>
                        <div style="display:flex; flex-direction:column; align-items:center; justify-content:center; height:100%; color:#94a3b8; padding:40px;">
                            <i class="ri-chat-smile-2-line" style="font-size:4rem; margin-bottom:12px; color:#cbd5e1;"></i>
                            <h3 style="font-size:1.1rem; color:#475569; font-weight:700;">Communication Workspace</h3>
                            <p style="text-align:center; max-width:400px; font-size:0.88rem; margin-top:6px;">Select any ticket thread or direct contact from the left list, or click "+ Start New Chat" to begin communicating with customers or staff.</p>
                            <button onclick="document.getElementById('newDirectChatModal').classList.add('show')" class="btn btn-primary" style="margin-top:16px;">
                                <i class="ri-chat-new-line"></i> Start New Chat
                            </button>
                        </div>
                    <% } %>
                </div>
            </div>

            <!-- Modal: Start New Direct Chat -->
            <div class="modal-backdrop" id="newDirectChatModal">
                <div class="modal-card">
                    <div class="modal-header">
                        <h3 style="font-weight: 800; font-size: 1.1rem;"><i class="ri-chat-new-line" style="color:#4f46e5;"></i> Start New Direct Chat</h3>
                        <button onclick="document.getElementById('newDirectChatModal').classList.remove('show')" style="border:none; background:none; font-size:1.2rem; cursor:pointer;"><i class="ri-close-line"></i></button>
                    </div>
                    <form action="MessageServlet" method="post">
                        <div class="modal-body">
                            <div class="form-group">
                                <label for="receiverIdSelect">Select Customer or Staff Member</label>
                                <select name="receiverId" id="receiverIdSelect" class="form-control" required>
                                    <option value="">-- Choose User to Chat With --</option>
                                    <optgroup label="Registered Users">
                                        <% if (allRegisteredUsers != null) {
                                            for (User u : allRegisteredUsers) {
                                                if (u.getUserId() != user.getUserId()) {
                                        %>
                                            <option value="<%= u.getUserId() %>"><%= u.getFullName() %> (<%= u.getRole() %> - <%= u.getEmail() %>)</option>
                                        <%      }
                                            }
                                           } %>
                                    </optgroup>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="initialMsgText">Initial Message</label>
                                <textarea name="messageText" id="initialMsgText" class="form-control" rows="3" placeholder="Type your initial message..." required></textarea>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" onclick="document.getElementById('newDirectChatModal').classList.remove('show')" class="btn btn-secondary">Cancel</button>
                            <button type="submit" class="btn btn-primary"><i class="ri-send-plane-fill"></i> Start Conversation</button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Modal: Edit Message -->
            <div class="modal-backdrop" id="editMessageModal">
                <div class="modal-card">
                    <div class="modal-header">
                        <h3 style="font-weight: 800; font-size: 1.1rem;"><i class="ri-edit-line" style="color:#4f46e5;"></i> Edit Sent Message</h3>
                        <button onclick="document.getElementById('editMessageModal').classList.remove('show')" style="border:none; background:none; font-size:1.2rem; cursor:pointer;"><i class="ri-close-line"></i></button>
                    </div>
                    <form action="MessageServlet" method="post">
                        <input type="hidden" name="action" value="edit">
                        <input type="hidden" name="messageId" id="editMsgId">
                        <input type="hidden" name="ticketId" value="<%= (activeTicket != null) ? activeTicket.getTicketId() : 0 %>">
                        <input type="hidden" name="chatUserId" value="<%= (activeChatUser != null) ? activeChatUser.getUserId() : 0 %>">
                        <div class="modal-body">
                            <div class="form-group">
                                <label for="editMsgText">Message Content</label>
                                <textarea name="messageText" id="editMsgText" class="form-control" rows="4" required></textarea>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" onclick="document.getElementById('editMessageModal').classList.remove('show')" class="btn btn-secondary">Cancel</button>
                            <button type="submit" class="btn btn-primary"><i class="ri-save-line"></i> Save Edit</button>
                        </div>
                    </form>
                </div>
            </div>

        </main>
    </div>

    <script>
        // Auto scroll chat box to bottom
        const container = document.getElementById('chatMessagesContainer');
        if (container) {
            container.scrollTop = container.scrollHeight;
        }

        function switchChatTab(tab) {
            const ticketTab = document.getElementById('tabTicketsBtn');
            const directTab = document.getElementById('tabDirectBtn');
            const ticketBox = document.getElementById('ticketThreadsContainer');
            const directBox = document.getElementById('directChatsContainer');

            if (tab === 'tickets') {
                ticketTab.classList.add('active');
                directTab.classList.remove('active');
                ticketBox.style.display = 'flex';
                directBox.style.display = 'none';
            } else {
                directTab.classList.add('active');
                ticketTab.classList.remove('active');
                ticketBox.style.display = 'none';
                directBox.style.display = 'flex';
            }
        }

        function openEditMessageModal(msgId, text) {
            document.getElementById('editMsgId').value = msgId;
            document.getElementById('editMsgText').value = text;
            document.getElementById('editMessageModal').classList.add('show');
        }

        function filterThreads() {
            var input = document.getElementById("threadFilterInput");
            var filter = input.value.toUpperCase();
            var items = document.getElementsByClassName("thread-item");

            for (var i = 0; i < items.length; i++) {
                var text = items[i].textContent || items[i].innerText;
                if (text.toUpperCase().indexOf(filter) > -1) {
                    items[i].style.display = "";
                } else {
                    items[i].style.display = "none";
                }
            }
        }
    </script>
</body>
</html>