<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Leave Approvals - Leave Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>body{background-color:#f8f9fa}.navbar{background:linear-gradient(135deg,#11998e 0%,#38ef7d 100%)!important}
    .card{border:none;box-shadow:0 2px 15px rgba(0,0,0,0.1);border-radius:10px}.table th{background-color:#11998e;color:white;border:none}
    
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
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark"><div class="container">
        <a class="navbar-brand" href="/dashboard"><i class="fas fa-calendar-check me-2"></i>LMS</a>
        <div class="collapse navbar-collapse"><ul class="navbar-nav me-auto">
            <li class="nav-item"><a class="nav-link" href="/dashboard"><i class="fas fa-home me-1"></i>Dashboard</a></li>
            <li class="nav-item"><a class="nav-link" href="/leaves"><i class="fas fa-calendar me-1"></i>My Leaves</a></li>
            <li class="nav-item"><a class="nav-link active" href="/approval"><i class="fas fa-check-circle me-1"></i>Approvals</a></li>
        </ul></div>
        <ul class="navbar-nav"><li class="nav-item dropdown"><a class="nav-link dropdown-toggle nav-user-pill" href="#" data-bs-toggle="dropdown"><i class="fas fa-user-circle me-1"></i>${sessionScope.username}</a>
            <ul class="dropdown-menu dropdown-menu-end"><li><a class="dropdown-item logout-btn" href="/logout"><i class="fas fa-sign-out-alt me-2"></i>Logout</a></li></ul>
        </li></ul>
    </div></nav>
    <div class="container py-4">
        <c:if test="${not empty successMessage}"><div class="alert alert-success alert-dismissible fade show"><i class="fas fa-check-circle me-2"></i>${successMessage}<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div></c:if>
        <c:if test="${not empty errorMessage}"><div class="alert alert-danger alert-dismissible fade show"><i class="fas fa-exclamation-circle me-2"></i>${errorMessage}<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div></c:if>

        <div class="card"><div class="card-header"><h5 class="mb-0"><i class="fas fa-check-circle me-2"></i>Pending Leave Approvals</h5></div>
        <div class="card-body"><div class="table-responsive">
            <table class="table table-hover"><thead><tr><th>ID</th><th>Employee</th><th>Type</th><th>From</th><th>To</th><th>Days</th><th>Reason</th><th>Actions</th></tr></thead>
            <tbody><c:forEach items="${leaves}" var="leave"><tr>
                <td>${leave.id}</td><td>${leave.employee.username}</td><td>${leave.leaveType}</td>
                <td>${leave.fromDate}</td><td>${leave.toDate}</td><td>${leave.numberOfDays}</td><td>${leave.reason}</td>
                <td>
                    <form action="/approval/approve/${leave.id}" method="post" style="display:inline"><button type="submit" class="btn btn-success btn-sm" onclick="return confirm('Approve this leave?')"><i class="fas fa-check"></i> Approve</button></form>
                    <button type="button" class="btn btn-danger btn-sm" data-bs-toggle="modal" data-bs-target="#rejectModal${leave.id}"><i class="fas fa-times"></i> Reject</button>
                    <div class="modal fade" id="rejectModal${leave.id}" tabindex="-1"><div class="modal-dialog"><div class="modal-content">
                        <div class="modal-header"><h5 class="modal-title">Reject Leave #${leave.id}</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
                        <form action="/approval/reject/${leave.id}" method="post"><div class="modal-body">
                            <p>Reject leave request from <strong>${leave.employee.username}</strong>?</p>
                            <div class="mb-3"><label class="form-label">Rejection Reason</label><textarea name="rejectionReason" class="form-control" rows="3" placeholder="Enter reason"></textarea></div>
                        </div><div class="modal-footer"><button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button><button type="submit" class="btn btn-danger">Reject</button></div></form>
                    </div></div></div>
                </td>
            </tr></c:forEach>
            <c:if test="${empty leaves}"><tr><td colspan="8" class="text-center py-4"><i class="fas fa-check-circle fa-3x text-muted mb-3"></i><p class="text-muted">No pending leave requests</p></td></tr></c:if>
            </tbody></table></div>
        </div></div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
