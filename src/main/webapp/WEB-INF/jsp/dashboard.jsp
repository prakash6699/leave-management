<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Leave Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>body{background-color:#f8f9fa}.navbar{background:linear-gradient(135deg,#11998e 0%,#38ef7d 100%)!important}
    .stat-card{border:none;border-radius:15px;box-shadow:0 4px 15px rgba(0,0,0,0.1);transition:transform 0.2s}
    .stat-card:hover{transform:translateY(-5px)}.stat-icon{width:60px;height:60px;border-radius:15px;display:flex;align-items:center;justify-content:center;font-size:24px;color:white}
    
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
            <li class="nav-item"><a class="nav-link active" href="/dashboard"><i class="fas fa-home me-1"></i>Dashboard</a></li>
            <li class="nav-item"><a class="nav-link" href="/leaves"><i class="fas fa-calendar me-1"></i>My Leaves</a></li>
            <li class="nav-item"><a class="nav-link" href="/leaves/apply"><i class="fas fa-plus me-1"></i>Apply Leave</a></li>
            <c:if test="${sessionScope.userRole == 'ADMIN'}">
                <li class="nav-item"><a class="nav-link" href="/approval"><i class="fas fa-check-circle me-1"></i>Approvals</a></li>
            </c:if>
        </ul></div>
        <ul class="navbar-nav"><li class="nav-item dropdown"><a class="nav-link dropdown-toggle nav-user-pill" href="#" data-bs-toggle="dropdown"><i class="fas fa-user-circle me-1"></i>${sessionScope.username}</a>
            <ul class="dropdown-menu dropdown-menu-end"><li><a class="dropdown-item logout-btn" href="/logout"><i class="fas fa-sign-out-alt me-2"></i>Logout</a></li></ul>
        </li></ul>
    </div></nav>

    <div class="container py-4">
        <h2 class="mb-4"><i class="fas fa-chart-line me-2"></i>Dashboard</h2>
        <div class="row g-4 mb-4">
            <div class="col-md-4"><div class="card stat-card"><div class="card-body"><div class="d-flex align-items-center">
                <div class="stat-icon bg-primary"><i class="fas fa-clock"></i></div><div class="ms-3"><h3>${pendingCount}</h3><p class="text-muted mb-0">Pending Requests</p></div>
            </div></div></div></div>
            <div class="col-md-4"><div class="card stat-card"><div class="card-body"><div class="d-flex align-items-center">
                <div class="stat-icon bg-success"><i class="fas fa-check"></i></div><div class="ms-3"><h3>${approvedCount}</h3><p class="text-muted mb-0">Approved Leaves</p></div>
            </div></div></div></div>
            <div class="col-md-4"><div class="card stat-card"><div class="card-body"><div class="d-flex align-items-center">
                <div class="stat-icon bg-info"><i class="fas fa-calendar"></i></div><div class="ms-3"><h3>${balances.size()}</h3><p class="text-muted mb-0">Leave Types</p></div>
            </div></div></div></div>
        </div>

        <div class="card"><div class="card-header bg-white"><h5 class="mb-0"><i class="fas fa-balance-scale me-2"></i>Leave Balance</h5></div>
            <div class="card-body"><div class="table-responsive"><table class="table table-hover">
                <thead><tr><th>Leave Type</th><th>Total Days</th><th>Used Days</th><th>Remaining</th><th>Progress</th></tr></thead>
                <tbody><c:forEach items="${balances}" var="b"><tr>
                    <td><strong>${b.leaveType}</strong></td><td>${b.totalDays}</td><td>${b.usedDays}</td><td>${b.remainingDays}</td>
                    <td><div class="progress" style="height:20px;width:200px"><div class="progress-bar ${b.remainingDays < 3 ? 'bg-danger' : 'bg-success'}" style="width:${(b.usedDays * 100) / b.totalDays}%">${b.usedDays}/${b.totalDays}</div></div></td>
                </tr></c:forEach></tbody>
            </table></div></div>
        </div>

        <div class="card mt-4"><div class="card-header bg-white"><h5 class="mb-0"><i class="fas fa-bolt me-2"></i>Quick Actions</h5></div>
            <div class="card-body">
                <a href="/leaves/apply" class="btn btn-success me-2"><i class="fas fa-plus me-1"></i>Apply Leave</a>
                <a href="/leaves" class="btn btn-outline-success me-2"><i class="fas fa-list me-1"></i>View History</a>
                <c:if test="${sessionScope.userRole == 'ADMIN'}"><a href="/approval" class="btn btn-outline-primary"><i class="fas fa-check me-1"></i>Review Approvals</a></c:if>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
