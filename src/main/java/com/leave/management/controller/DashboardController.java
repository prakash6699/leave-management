package com.leave.management.controller;

import com.leave.management.entity.LeaveBalance;
import com.leave.management.entity.User;
import com.leave.management.service.LeaveBalanceService;
import com.leave.management.service.LeaveRequestService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import java.time.LocalDate;
import java.util.List;

@Controller
public class DashboardController {
    @Autowired private LeaveBalanceService leaveBalanceService;
    @Autowired private LeaveRequestService leaveRequestService;

    @GetMapping("/dashboard")
    public String showDashboard(Model model, HttpSession session) {
        if (session.getAttribute("loggedInUser") == null) return "redirect:/login";
        User user = (User) session.getAttribute("loggedInUser");
        int year = LocalDate.now().getYear();
        List<LeaveBalance> balances = leaveBalanceService.getBalances(user, year);
        model.addAttribute("balances", balances);
        model.addAttribute("pendingCount", leaveRequestService.getLeavesByEmployee(user, 0, 1000).getContent().stream().filter(l -> "PENDING".equals(l.getStatus())).count());
        model.addAttribute("approvedCount", leaveRequestService.getLeavesByEmployee(user, 0, 1000).getContent().stream().filter(l -> "APPROVED".equals(l.getStatus())).count());
        return "dashboard";
    }
}
