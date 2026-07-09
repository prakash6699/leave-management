package com.leave.management.controller;

import com.leave.management.dto.LeaveRequestDTO;
import com.leave.management.entity.LeaveRequest;
import com.leave.management.entity.User;
import com.leave.management.service.LeaveBalanceService;
import com.leave.management.service.LeaveRequestService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import java.time.LocalDate;
import java.util.List;

@Controller
@RequestMapping("/leaves")
public class LeaveController {
    @Autowired private LeaveRequestService leaveRequestService;
    @Autowired private LeaveBalanceService leaveBalanceService;

    @GetMapping
    public String listLeaves(@RequestParam(defaultValue = "0") int page,
                             @RequestParam(defaultValue = "10") int size,
                             @RequestParam(defaultValue = "createdAt") String sortBy,
                             @RequestParam(defaultValue = "desc") String sortDir,
                             @RequestParam(required = false) String status,
                             @RequestParam(required = false) String leaveType,
                             Model model, HttpSession session) {
        if (session.getAttribute("loggedInUser") == null) return "redirect:/login";
        User user = (User) session.getAttribute("loggedInUser");
        boolean isAdmin = "ADMIN".equals(session.getAttribute("userRole"));

        Page<LeaveRequest> leavePage;
        if (isAdmin) {
            leavePage = leaveRequestService.searchLeaves(null, status, leaveType, page, size, sortBy, sortDir);
        } else {
            leavePage = leaveRequestService.getLeavesByEmployee(user, page, size);
        }

        model.addAttribute("leaves", leavePage.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", leavePage.getTotalPages());
        model.addAttribute("totalElements", leavePage.getTotalElements());
        model.addAttribute("sortBy", sortBy);
        model.addAttribute("sortDir", sortDir);
        model.addAttribute("reverseSortDir", sortDir.equals("asc") ? "desc" : "asc");
        model.addAttribute("searchStatus", status);
        model.addAttribute("searchLeaveType", leaveType);
        model.addAttribute("isAdmin", isAdmin);
        return "leave-list";
    }

    @GetMapping("/apply")
    public String showApplyForm(Model model, HttpSession session) {
        if (session.getAttribute("loggedInUser") == null) return "redirect:/login";
        User user = (User) session.getAttribute("loggedInUser");
        model.addAttribute("leaveDTO", new LeaveRequestDTO());
        model.addAttribute("leaveTypes", List.of("Annual", "Sick", "Personal", "Maternity", "Paternity", "Unpaid"));
        model.addAttribute("balances", leaveBalanceService.getBalances(user, LocalDate.now().getYear()));
        return "leave-form";
    }

    @PostMapping("/save")
    public String saveLeave(@Valid @ModelAttribute("leaveDTO") LeaveRequestDTO leaveDTO, BindingResult result,
                            Model model, RedirectAttributes redirectAttributes,
                            HttpSession session, HttpServletRequest request) {
        if (session.getAttribute("loggedInUser") == null) return "redirect:/login";
        if (result.hasErrors()) {
            User user = (User) session.getAttribute("loggedInUser");
            model.addAttribute("leaveTypes", List.of("Annual", "Sick", "Personal", "Maternity", "Paternity", "Unpaid"));
            model.addAttribute("balances", leaveBalanceService.getBalances(user, LocalDate.now().getYear()));
            return "leave-form";
        }
        try {
            User user = (User) session.getAttribute("loggedInUser");
            if (leaveDTO.getId() == null) {
                leaveRequestService.createLeave(leaveDTO, user, request);
                redirectAttributes.addFlashAttribute("successMessage", "Leave applied successfully!");
            } else {
                leaveRequestService.updateLeave(leaveDTO.getId(), leaveDTO, user);
                redirectAttributes.addFlashAttribute("successMessage", "Leave updated successfully!");
            }
            return "redirect:/leaves";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/leaves";
        }
    }

    @GetMapping("/view/{id}")
    public String viewLeave(@PathVariable Long id, Model model, HttpSession session) {
        if (session.getAttribute("loggedInUser") == null) return "redirect:/login";
        model.addAttribute("leave", leaveRequestService.getLeaveById(id));
        return "leave-view";
    }

    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable Long id, Model model, HttpSession session) {
        if (session.getAttribute("loggedInUser") == null) return "redirect:/login";
        User user = (User) session.getAttribute("loggedInUser");
        LeaveRequest leave = leaveRequestService.getLeaveById(id);

        if ("APPROVED".equals(leave.getStatus())) {
            model.addAttribute("errorMessage", "Approved leave cannot be modified");
            return "redirect:/leaves";
        }
        if (!leave.getEmployee().getId().equals(user.getId())) {
            model.addAttribute("errorMessage", "You can only edit your own leave requests");
            return "redirect:/leaves";
        }

        LeaveRequestDTO dto = new LeaveRequestDTO();
        dto.setId(leave.getId());
        dto.setLeaveType(leave.getLeaveType());
        dto.setFromDate(leave.getFromDate());
        dto.setToDate(leave.getToDate());
        dto.setReason(leave.getReason());

        model.addAttribute("leaveDTO", dto);
        model.addAttribute("leaveTypes", List.of("Annual", "Sick", "Personal", "Maternity", "Paternity", "Unpaid"));
        model.addAttribute("balances", leaveBalanceService.getBalances(user, LocalDate.now().getYear()));
        return "leave-form";
    }

    @GetMapping("/cancel/{id}")
    public String cancelLeave(@PathVariable Long id, RedirectAttributes redirectAttributes, HttpSession session) {
        if (session.getAttribute("loggedInUser") == null) return "redirect:/login";
        try {
            User user = (User) session.getAttribute("loggedInUser");
            leaveRequestService.cancelLeave(id, user);
            redirectAttributes.addFlashAttribute("successMessage", "Leave cancelled successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }
        return "redirect:/leaves";
    }
}
