<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${leaveDTO.id != null ? 'Edit' : 'Apply'} Leave</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>body{background-color:#f8f9fa}.navbar{background:linear-gradient(135deg,#11998e 0%,#38ef7d 100%)!important}
    .card{border:none;box-shadow:0 2px 15px rgba(0,0,0,0.1);border-radius:10px}
    .btn-success{background:linear-gradient(135deg,#11998e 0%,#38ef7d 100%);border:none}
    
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
        </ul></div>
        <ul class="navbar-nav"><li class="nav-item dropdown"><a class="nav-link dropdown-toggle nav-user-pill" href="#" data-bs-toggle="dropdown"><i class="fas fa-user-circle me-1"></i>${sessionScope.username}</a>
            <ul class="dropdown-menu dropdown-menu-end"><li><a class="dropdown-item logout-btn" href="/logout"><i class="fas fa-sign-out-alt me-2"></i>Logout</a></li></ul>
        </li></ul>
    </div></nav>
    <div class="container py-4"><div class="row justify-content-center"><div class="col-md-8">
        <div class="card"><div class="card-header"><h5 class="mb-0"><i class="fas fa-${leaveDTO.id != null ? 'edit' : 'plus'} me-2"></i>${leaveDTO.id != null ? 'Edit' : 'Apply'} Leave</h5></div>
        <div class="card-body">
            <c:if test="${not empty balances}">
            <div class="alert alert-info"><h6><i class="fas fa-info-circle me-2"></i>Leave Balance</h6><div class="row">
                <c:forEach items="${balances}" var="b"><div class="col-md-4 mb-2"><strong>${b.leaveType}:</strong> ${b.remainingDays} days remaining</div></c:forEach>
            </div></div></c:if>

            <form:form action="/leaves/save" method="post" modelAttribute="leaveDTO">
                <form:hidden path="id"/>
                <div class="mb-3"><label class="form-label">Leave Type *</label>
                    <form:select path="leaveType" class="form-select"><form:option value="">Select Type</form:option><c:forEach items="${leaveTypes}" var="t"><form:option value="${t}">${t}</form:option></c:forEach></form:select>
                    <form:errors path="leaveType" cssClass="text-danger small"/></div>
                <div class="row"><div class="col-md-6 mb-3"><label class="form-label">From Date *</label><form:input path="fromDate" type="date" class="form-control"/><form:errors path="fromDate" cssClass="text-danger small"/></div>
                    <div class="col-md-6 mb-3"><label class="form-label">To Date *</label><form:input path="toDate" type="date" class="form-control"/><form:errors path="toDate" cssClass="text-danger small"/></div></div>
                <div class="mb-3"><label class="form-label">Reason</label><form:textarea path="reason" class="form-control" rows="3" placeholder="Enter reason for leave"/><form:errors path="reason" cssClass="text-danger small"/></div>
                <div class="d-flex gap-2"><button type="submit" class="btn btn-success"><i class="fas fa-save me-1"></i>Submit</button><a href="/leaves" class="btn btn-secondary"><i class="fas fa-times me-1"></i>Cancel</a></div>
            </form:form>
        </div></div>
    </div></div></div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
