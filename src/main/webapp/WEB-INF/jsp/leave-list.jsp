<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Leaves - Leave Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>body{background-color:#f8f9fa}.navbar{background:linear-gradient(135deg,#11998e 0%,#38ef7d 100%)!important}
    .card{border:none;box-shadow:0 2px 15px rgba(0,0,0,0.1);border-radius:10px}.table th{background-color:#11998e;color:white;border:none}
    .status-badge{padding:5px 12px;border-radius:20px;font-size:12px;font-weight:600}
    .status-pending{background:#fff3cd;color:#856404}.status-approved{background:#d4edda;color:#155724}
    .status-rejected{background:#f8d7da;color:#721c24}.status-cancelled{background:#e2e3e5;color:#383d41}
    
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
            <li class="nav-item"><a class="nav-link active" href="/leaves"><i class="fas fa-calendar me-1"></i>My Leaves</a></li>
            <li class="nav-item"><a class="nav-link" href="/leaves/apply"><i class="fas fa-plus me-1"></i>Apply Leave</a></li>
            <c:if test="${sessionScope.userRole == 'ADMIN'}"><li class="nav-item"><a class="nav-link" href="/approval"><i class="fas fa-check-circle me-1"></i>Approvals</a></li></c:if>
        </ul></div>
        <ul class="navbar-nav"><li class="nav-item dropdown"><a class="nav-link dropdown-toggle nav-user-pill" href="#" data-bs-toggle="dropdown"><i class="fas fa-user-circle me-1"></i>${sessionScope.username}</a>
            <ul class="dropdown-menu dropdown-menu-end"><li><a class="dropdown-item logout-btn" href="/logout"><i class="fas fa-sign-out-alt me-2"></i>Logout</a></li></ul>
        </li></ul>
    </div></nav>
    <div class="container py-4">
        <c:if test="${not empty successMessage}"><div class="alert alert-success alert-dismissible fade show"><i class="fas fa-check-circle me-2"></i>${successMessage}<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div></c:if>
        <c:if test="${not empty errorMessage}"><div class="alert alert-danger alert-dismissible fade show"><i class="fas fa-exclamation-circle me-2"></i>${errorMessage}<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div></c:if>

        <c:if test="${isAdmin}">
        <div class="card mb-3"><div class="card-body"><form action="/leaves" method="get" class="row g-3">
            <div class="col-md-3"><label class="form-label">Status</label><select name="status" class="form-select"><option value="">All</option><option value="PENDING" ${'PENDING' == searchStatus ? 'selected' : ''}>Pending</option><option value="APPROVED" ${'APPROVED' == searchStatus ? 'selected' : ''}>Approved</option><option value="REJECTED" ${'REJECTED' == searchStatus ? 'selected' : ''}>Rejected</option></select></div>
            <div class="col-md-3"><label class="form-label">Leave Type</label><select name="leaveType" class="form-select"><option value="">All</option><option value="Annual" ${'Annual' == searchLeaveType ? 'selected' : ''}>Annual</option><option value="Sick" ${'Sick' == searchLeaveType ? 'selected' : ''}>Sick</option><option value="Personal" ${'Personal' == searchLeaveType ? 'selected' : ''}>Personal</option></select></div>
            <div class="col-md-2"><label class="form-label">&nbsp;</label><button type="submit" class="btn btn-success w-100"><i class="fas fa-search me-1"></i>Search</button></div>
            <div class="col-md-2"><label class="form-label">&nbsp;</label><a href="/leaves" class="btn btn-secondary w-100"><i class="fas fa-times me-1"></i>Clear</a></div>
        </form></div></div>
        </c:if>

        <div class="card"><div class="card-header d-flex justify-content-between align-items-center">
            <h5 class="mb-0"><i class="fas fa-calendar me-2"></i>Leave History <span class="badge bg-success ms-2">${totalElements}</span></h5>
            <a href="/leaves/apply" class="btn btn-success"><i class="fas fa-plus me-1"></i>Apply Leave</a>
        </div><div class="card-body"><div class="table-responsive">
            <table class="table table-hover"><thead><tr><th>ID</th><th>Employee</th><th>Type</th><th>From</th><th>To</th><th>Days</th><th>Status</th><th>Actions</th></tr></thead>
            <tbody><c:forEach items="${leaves}" var="leave"><tr>
                <td>${leave.id}</td><td>${leave.employee.username}</td><td>${leave.leaveType}</td>
                <td>${leave.fromDate}</td><td>${leave.toDate}</td><td>${leave.numberOfDays}</td>
                <td><span class="status-badge status-${leave.status.toLowerCase()}">${leave.status}</span></td>
                <td>
                    <a href="/leaves/view/${leave.id}" class="btn btn-info btn-sm"><i class="fas fa-eye"></i></a>
                    <c:if test="${leave.status == 'PENDING'}">
                        <a href="/leaves/edit/${leave.id}" class="btn btn-warning btn-sm"><i class="fas fa-edit"></i></a>
                        <a href="/leaves/cancel/${leave.id}" class="btn btn-danger btn-sm" onclick="return confirm('Cancel this leave?')"><i class="fas fa-times"></i></a>
                    </c:if>
                </td>
            </tr></c:forEach>
            <c:if test="${empty leaves}"><tr><td colspan="8" class="text-center py-4"><i class="fas fa-inbox fa-3x text-muted mb-3"></i><p class="text-muted">No leave requests found</p></td></tr></c:if>
            </tbody></table></div>
            <c:if test="${totalPages > 1}"><nav><ul class="pagination justify-content-center">
                <li class="page-item ${currentPage == 0 ? 'disabled' : ''}"><a class="page-link" href="/leaves?page=${currentPage - 1}"><i class="fas fa-chevron-left"></i></a></li>
                <c:forEach begin="0" end="${totalPages - 1}" var="i"><li class="page-item ${currentPage == i ? 'active' : ''}"><a class="page-link" href="/leaves?page=${i}">${i + 1}</a></li></c:forEach>
                <li class="page-item ${currentPage == totalPages - 1 ? 'disabled' : ''}"><a class="page-link" href="/leaves?page=${currentPage + 1}"><i class="fas fa-chevron-right"></i></a></li>
            </ul></nav></c:if>
        </div></div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
