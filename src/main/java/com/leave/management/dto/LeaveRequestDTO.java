package com.leave.management.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import org.springframework.format.annotation.DateTimeFormat;
import java.time.LocalDate;

public class LeaveRequestDTO {
    private Long id;
    @NotBlank(message = "Leave type is required")
    private String leaveType;
    @NotNull(message = "From date is required")
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private LocalDate fromDate;
    @NotNull(message = "To date is required")
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private LocalDate toDate;
    @Size(max = 500, message = "Reason must not exceed 500 characters")
    private String reason;
    private String rejectionReason;
    public LeaveRequestDTO() {}
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getLeaveType() { return leaveType; }
    public void setLeaveType(String leaveType) { this.leaveType = leaveType; }
    public LocalDate getFromDate() { return fromDate; }
    public void setFromDate(LocalDate fromDate) { this.fromDate = fromDate; }
    public LocalDate getToDate() { return toDate; }
    public void setToDate(LocalDate toDate) { this.toDate = toDate; }
    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }
    public String getRejectionReason() { return rejectionReason; }
    public void setRejectionReason(String rejectionReason) { this.rejectionReason = rejectionReason; }
}
