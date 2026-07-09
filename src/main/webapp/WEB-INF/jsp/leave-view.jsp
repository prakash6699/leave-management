<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Leave Details - Leave Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>body{background-color:#f8f9fa}.navbar{background:linear-gradient(135deg,#11998e 0%,#38ef7d 100%)!important}
    .card{border:none;box-shadow:0 2px 15px rgba(0,0,0,0.1);border-radius:10px}
    
    /* Premium Username Pill Styling */
    .nav-user-pill {
        background: rgba(255, 255, 255, 0.18);
        border: 1px solid rgba(255, 255, 255, 0.35);
        border-radius: 50px;
        padding: 6px 16px !important;
        color: #ffffff !important;
        font-weight: 600;
        transition: all 0.3s ease;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
    }
    .nav-user-pill:hover, .nav-user-pill:focus, .show > .nav-user-pill {
        background: rgba(255, 255, 255, 0.3);
        border-color: rgba(255, 255, 255, 0.5);
        transform: translateY(-1px);
        box-shadow: 0 6px 12px rgba(0, 0, 0, 0.08);
    }
    
    /* Dropdown Menu Customization */
    .dropdown-menu {
        border: none;
        border-radius: 12px;
        box-shadow: 0 10px 30px rgba(0,0,0,0.15);
        padding: 8px;
        margin-top: 10px !important;
        min-width: 150px;
    }
    
    /* Premium Logout Button Styling */
    .logout-btn {
        color: #dc3545 !important;
        font-weight: 600;
        border-radius: 8px;
        padding: 10px 16px;
        transition: all 0.2s ease;
        display: flex;
        align-items: center;
    }
    .logout-btn:hover {
        background-color: #dc3545 !important;
        color: #ffffff !important;
    }
    .logout-btn i {
        transition: transform 0.2s ease;
    }
    .logout-btn:hover i {
        transform: translateX(3px);
    }
    </style>
    .status-badge{padding:5px 12px;border-radius:20px;font-size:12px;font-weight:600}
    .status-pending{background:#fff3cd;color:#856404}.status-approved{background:#d4edda;color:#155724}
    .status-rejected{background:#f8d7da;color:#721c24}.status-cancelled{background:#e2e3e5;color:#383d41}</style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark"><div class="container">
        <a class="navbar-brand" href="/dashboard"><i class="fas fa-calendar-check me-2"></i>LMS</a>
        <div class="collapse navbar-collapse"><ul class="navbar-nav me-auto">
            <li class="nav-item"><a class="nav-link" href="/dashboard"><i class="fas fa-home me-1"></i>Dashboard</a></li>
            <li class="nav-item"><a class="nav-link active" href="/leaves"><i class="fas fa-calendar me-1"></i>My Leaves</a></li>
        </ul></div>
        <ul class="navbar-nav"><li class="nav-item dropdown"><a class="nav-link dropdown-toggle nav-user-pill" href="#" data-bs-toggle="dropdown"><i class="fas fa-user-circle me-1"></i>${sessionScope.username}</a>
            <ul class="dropdown-menu dropdown-menu-end"><li><a class="dropdown-item logout-btn" href="/logout"><i class="fas fa-sign-out-alt me-2"></i>Logout</a></li></ul>
        </li></ul>
    </div></nav>
    <div class="container py-4">
        <div class="d-flex justify-content-between align-items-center mb-4"><h2><i class="fas fa-calendar me-2"></i>Leave Details #${leave.id}</h2><a href="/leaves" class="btn btn-secondary"><i class="fas fa-arrow-left me-1"></i>Back</a></div>
        <div class="row g-4"><div class="col-md-8"><div class="card"><div class="card-body">
            <table class="table table-borderless">
                <tr><td class="text-muted" style="width:35%">Employee</td><td><strong>${leave.employee.username}</strong></td></tr>
                <tr><td class="text-muted">Leave Type</td><td>${leave.leaveType}</td></tr>
                <tr><td class="text-muted">From Date</td><td>${leave.fromDate}</td></tr>
                <tr><td class="text-muted">To Date</td><td>${leave.toDate}</td></tr>
                <tr><td class="text-muted">Number of Days</td><td><strong>${leave.numberOfDays}</strong></td></tr>
                <tr><td class="text-muted">Reason</td><td>${leave.reason != null ? leave.reason : 'N/A'}</td></tr>
                <tr><td class="text-muted">Status</td><td><span class="status-badge status-${leave.status.toLowerCase()}">${leave.status}</span></td></tr>
                <c:if test="${leave.approvedBy != null}"><tr><td class="text-muted">Approved/Rejected By</td><td>${leave.approvedBy}</td></tr></c:if>
                <c:if test="${leave.rejectionReason != null}"><tr><td class="text-muted">Rejection Reason</td><td class="text-danger">${leave.rejectionReason}</td></tr></c:if>
                <tr><td class="text-muted">Applied On</td><td>${leave.createdAt}</td></tr>
            </table>
        </div></div></div>
        <div class="col-md-4"><div class="card"><div class="card-body text-center">
            <i class="fas fa-calendar-check fa-3x text-success mb-3"></i>
            <h5>${leave.numberOfDays}</h5><p class="text-muted">Days Requested</p>
            <c:if test="${leave.status == 'PENDING'}"><a href="/leaves/cancel/${leave.id}" class="btn btn-outline-danger w-100" onclick="return confirm('Cancel this leave?')"><i class="fas fa-times me-1"></i>Cancel Leave</a></c:if>
        </div></div></div></div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
