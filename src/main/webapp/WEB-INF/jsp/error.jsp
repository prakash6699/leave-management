<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error - LMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>body{background-color:#f8f9fa;min-height:100vh;display:flex;align-items:center;justify-content:center}
    .error-card{background:white;border-radius:15px;box-shadow:0 10px 40px rgba(0,0,0,0.1);padding:40px;text-align:center;max-width:500px}</style>
</head>
<body>
    <div class="error-card">
        <i class="fas fa-exclamation-triangle" style="font-size:80px;color:#dc3545"></i>
        <div style="font-size:72px;font-weight:700;color:#11998e">${statusCode != null ? statusCode : 500}</div>
        <h2>${errorTitle != null ? errorTitle : 'Something went wrong'}</h2>
        <p class="text-muted mb-4">${errorMessage != null ? errorMessage : 'An unexpected error occurred.'}</p>
        <a href="/dashboard" class="btn btn-success"><i class="fas fa-home me-1"></i>Dashboard</a>
    </div>
</body>
</html>
