package com.leave.management.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public class RegisterDTO {
    @NotBlank(message = "Username is required")
    @Size(min = 3, max = 50)
    private String username;
    @NotBlank(message = "Password is required")
    @Size(min = 6)
    private String password;
    @NotBlank(message = "Confirm password is required")
    private String confirmPassword;
    @NotBlank(message = "Email is required")
    @Email(message = "Please provide a valid email")
    private String email;
    public RegisterDTO() {}
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    public String getConfirmPassword() { return confirmPassword; }
    public void setConfirmPassword(String confirmPassword) { this.confirmPassword = confirmPassword; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
}
