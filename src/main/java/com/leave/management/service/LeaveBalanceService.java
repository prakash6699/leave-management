package com.leave.management.service;

import com.leave.management.entity.LeaveBalance;
import com.leave.management.entity.User;
import com.leave.management.repository.LeaveBalanceRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDate;
import java.util.List;

@Service
@Transactional
public class LeaveBalanceService {
    @Autowired private LeaveBalanceRepository leaveBalanceRepository;

    @Transactional(readOnly = true)
    public List<LeaveBalance> getBalances(User employee, int year) {
        return leaveBalanceRepository.findByEmployeeAndYear(employee, year);
    }

    @Transactional(readOnly = true)
    public LeaveBalance getBalance(User employee, String leaveType, int year) {
        return leaveBalanceRepository.findByEmployeeAndLeaveTypeAndYear(employee, leaveType, year)
            .orElseGet(() -> {
                int defaultDays = getDefaultDays(leaveType);
                LeaveBalance balance = new LeaveBalance(employee, leaveType, defaultDays, year);
                return leaveBalanceRepository.save(balance);
            });
    }

    public void updateUsedDays(User employee, String leaveType, int days, int year) {
        LeaveBalance balance = getBalance(employee, leaveType, year);
        balance.setUsedDays(balance.getUsedDays() + days);
        leaveBalanceRepository.save(balance);
    }

    public void revertUsedDays(User employee, String leaveType, int days, int year) {
        LeaveBalance balance = getBalance(employee, leaveType, year);
        balance.setUsedDays(Math.max(0, balance.getUsedDays() - days));
        leaveBalanceRepository.save(balance);
    }

    public boolean hasEnoughBalance(User employee, String leaveType, int days) {
        int year = LocalDate.now().getYear();
        LeaveBalance balance = getBalance(employee, leaveType, year);
        return balance.getRemainingDays() >= days;
    }

    private int getDefaultDays(String leaveType) {
        return switch (leaveType) {
            case "Annual" -> 20;
            case "Sick" -> 10;
            case "Personal" -> 5;
            case "Maternity", "Paternity" -> 30;
            default -> 10;
        };
    }
}
