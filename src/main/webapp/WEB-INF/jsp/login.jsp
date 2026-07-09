<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Leave Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>body{background:linear-gradient(135deg,#11998e 0%,#38ef7d 100%);min-height:100vh;display:flex;align-items:center;justify-content:center}
    .login-card{background:white;border-radius:15px;box-shadow:0 10px 40px rgba(0,0,0,0.2);padding:40px;width:100%;max-width:400px}
    .login-header{text-align:center;margin-bottom:30px}.login-header i{font-size:50px;color:#11998e;margin-bottom:15px}
    .btn-success{background:linear-gradient(135deg,#11998e 0%,#38ef7d 100%);border:none;padding:12px;font-weight:600}
    .btn-success:hover{background:linear-gradient(135deg,#0e8a7f 0%,#2fd36e 100%)}
    .form-label { color: #11998e; font-weight: 600; }</style>
</head>
<body>
    <div class="login-card">
        <div class="login-header"><i class="fas fa-calendar-check"></i><h3>Leave Management</h3><p class="text-muted">Please login to continue</p></div>
        <c:if test="${not empty errorMessage}"><div class="alert alert-danger"><i class="fas fa-exclamation-circle me-2"></i>${errorMessage}</div></c:if>
        <c:if test="${not empty successMessage}"><div class="alert alert-success"><i class="fas fa-check-circle me-2"></i>${successMessage}</div></c:if>
        <form:form action="/login" method="post" modelAttribute="loginDTO">
            <div class="mb-3"><label class="form-label"><i class="fas fa-user me-2"></i>Username</label>
                <form:input path="username" type="text" class="form-control" placeholder="Enter username" required="required"/></div>
            <div class="mb-3"><label class="form-label"><i class="fas fa-lock me-2"></i>Password</label>
                <form:password path="password" class="form-control" placeholder="Enter password" required="required"/></div>
            <button type="submit" class="btn btn-success w-100"><i class="fas fa-sign-in-alt me-2"></i>Login</button>
        </form:form>
        <div class="text-center mt-3"><p>Don't have an account? <a href="/register">Register here</a></p></div>
        <div class="text-center mt-2"><small class="text-muted">Admin: admin/admin123 | Employee: jothi/Jothi@123</small></div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
