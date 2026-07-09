package com.leave.management.controller;

import com.leave.management.entity.LeaveRequest;
import com.leave.management.service.LeaveRequestService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/approval")
public class LeaveApprovalController {
    @Autowired private LeaveRequestService leaveRequestService;

    @GetMapping
    public String showApprovalPage(@RequestParam(defaultValue = "0") int page,
                                   @RequestParam(defaultValue = "10") int size,
                                   Model model, HttpSession session) {
        if (session.getAttribute("loggedInUser") == null) return "redirect:/login";
        if (!"ADMIN".equals(session.getAttribute("userRole"))) return "redirect:/dashboard";

        model.addAttribute("leaves", leaveRequestService.searchLeaves(null, "PENDING", null, page, size, "createdAt", "desc").getContent());
        model.addAttribute("currentPage", page);
        return "approval-list";
    }

    @PostMapping("/approve/{id}")
    public String approveLeave(@PathVariable Long id, RedirectAttributes redirectAttributes, HttpSession session) {
        if (session.getAttribute("loggedInUser") == null) return "redirect:/login";
        try {
            String username = (String) session.getAttribute("username");
            leaveRequestService.approveLeave(id, username, null);
            redirectAttributes.addFlashAttribute("successMessage", "Leave approved successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }
        return "redirect:/approval";
    }

    @PostMapping("/reject/{id}")
    public String rejectLeave(@PathVariable Long id,
                              @RequestParam(required = false) String rejectionReason,
                              RedirectAttributes redirectAttributes, HttpSession session) {
        if (session.getAttribute("loggedInUser") == null) return "redirect:/login";
        try {
            String username = (String) session.getAttribute("username");
            leaveRequestService.rejectLeave(id, username, rejectionReason != null ? rejectionReason : "No reason provided");
            redirectAttributes.addFlashAttribute("successMessage", "Leave rejected successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }
        return "redirect:/approval";
    }
}
