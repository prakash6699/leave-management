package com.leave.management.entity;

import jakarta.persistence.*;
import java.time.Year;

@Entity
@Table(name = "leave_balances", uniqueConstraints = {
    @UniqueConstraint(columnNames = {"employee_id", "leave_type", "leave_year"})
})
public class LeaveBalance {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "employee_id", nullable = false)
    private User employee;

    @Column(name = "leave_type", nullable = false, length = 50)
    private String leaveType;

    @Column(name = "total_days", nullable = false)
    private int totalDays;

    @Column(name = "used_days", nullable = false)
    private int usedDays;

    @Column(name = "leave_year", nullable = false)
    private int year;

    public LeaveBalance() {}
    public LeaveBalance(User employee, String leaveType, int totalDays, int year) {
        this.employee = employee;
        this.leaveType = leaveType;
        this.totalDays = totalDays;
        this.usedDays = 0;
        this.year = year;
    }

    public int getRemainingDays() { return totalDays - usedDays; }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public User getEmployee() { return employee; }
    public void setEmployee(User employee) { this.employee = employee; }
    public String getLeaveType() { return leaveType; }
    public void setLeaveType(String leaveType) { this.leaveType = leaveType; }
    public int getTotalDays() { return totalDays; }
    public void setTotalDays(int totalDays) { this.totalDays = totalDays; }
    public int getUsedDays() { return usedDays; }
    public void setUsedDays(int usedDays) { this.usedDays = usedDays; }
    public int getYear() { return year; }
    public void setYear(int year) { this.year = year; }
}
