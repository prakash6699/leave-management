<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Leave Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>body{background:linear-gradient(135deg,#11998e 0%,#38ef7d 100%);min-height:100vh;display:flex;align-items:center;justify-content:center}
    .card{background:white;border-radius:15px;box-shadow:0 10px 40px rgba(0,0,0,0.2);padding:40px;width:100%;max-width:450px}
    .btn-success{background:linear-gradient(135deg,#11998e 0%,#38ef7d 100%);border:none;padding:12px;font-weight:600}</style>
</head>
<body>
    <div class="card">
        <div class="text-center mb-4"><i class="fas fa-user-plus" style="font-size:50px;color:#11998e"></i><h3>Create Account</h3></div>
        <c:if test="${not empty errorMessage}"><div class="alert alert-danger">${errorMessage}</div></c:if>
        <form:form action="/register" method="post" modelAttribute="registerDTO">
            <div class="mb-3"><label class="form-label">Username</label><form:input path="username" class="form-control" placeholder="Enter username"/><form:errors path="username" cssClass="text-danger small"/></div>
            <div class="mb-3"><label class="form-label">Email</label><form:input path="email" type="email" class="form-control" placeholder="Enter email"/><form:errors path="email" cssClass="text-danger small"/></div>
            <div class="mb-3"><label class="form-label">Password</label><form:password path="password" class="form-control" placeholder="Enter password"/><form:errors path="password" cssClass="text-danger small"/></div>
            <div class="mb-3"><label class="form-label">Confirm Password</label><form:password path="confirmPassword" class="form-control" placeholder="Confirm password"/><form:errors path="confirmPassword" cssClass="text-danger small"/></div>
            <button type="submit" class="btn btn-success w-100"><i class="fas fa-user-plus me-2"></i>Register</button>
        </form:form>
        <div class="text-center mt-3"><p>Already have an account? <a href="/login">Login here</a></p></div>
    </div>
</body>
</html>
