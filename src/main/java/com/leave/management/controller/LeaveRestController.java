package com.leave.management.controller;

import com.leave.management.dto.LeaveRequestDTO;
import com.leave.management.entity.LeaveRequest;
import com.leave.management.entity.User;
import com.leave.management.service.LeaveBalanceService;
import com.leave.management.service.LeaveRequestService;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/leaves")
@CrossOrigin(origins = "*")
public class LeaveRestController {
    @Autowired private LeaveRequestService leaveRequestService;
    @Autowired private LeaveBalanceService leaveBalanceService;

    @GetMapping
    public ResponseEntity<Page<LeaveRequest>> getAllLeaves(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(defaultValue = "createdAt") String sortBy,
            @RequestParam(defaultValue = "desc") String sortDir) {
        return ResponseEntity.ok(leaveRequestService.getAllLeaves(page, size, sortBy, sortDir));
    }

    @GetMapping("/{id}")
    public ResponseEntity<LeaveRequest> getLeaveById(@PathVariable Long id) {
        return ResponseEntity.ok(leaveRequestService.getLeaveById(id));
    }

    @PostMapping
    public ResponseEntity<LeaveRequest> createLeave(@Valid @RequestBody LeaveRequestDTO dto, HttpSession session) {
        User user = (User) session.getAttribute("loggedInUser");
        if (user == null) return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        return ResponseEntity.status(HttpStatus.CREATED).body(leaveRequestService.createLeave(dto, user, null));
    }

    @PutMapping("/{id}")
    public ResponseEntity<LeaveRequest> updateLeave(@PathVariable Long id, @Valid @RequestBody LeaveRequestDTO dto, HttpSession session) {
        User user = (User) session.getAttribute("loggedInUser");
        if (user == null) return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        return ResponseEntity.ok(leaveRequestService.updateLeave(id, dto, user));
    }

    @PostMapping("/{id}/approve")
    public ResponseEntity<Map<String, String>> approveLeave(@PathVariable Long id, HttpSession session) {
        String username = (String) session.getAttribute("username");
        leaveRequestService.approveLeave(id, username, null);
        Map<String, String> response = new HashMap<>();
        response.put("message", "Leave approved successfully");
        return ResponseEntity.ok(response);
    }

    @PostMapping("/{id}/reject")
    public ResponseEntity<Map<String, String>> rejectLeave(@PathVariable Long id, @RequestBody(required = false) Map<String, String> body, HttpSession session) {
        String username = (String) session.getAttribute("username");
        String reason = body != null ? body.get("reason") : "No reason provided";
        leaveRequestService.rejectLeave(id, username, reason);
        Map<String, String> response = new HashMap<>();
        response.put("message", "Leave rejected successfully");
        return ResponseEntity.ok(response);
    }

    @PostMapping("/{id}/cancel")
    public ResponseEntity<Map<String, String>> cancelLeave(@PathVariable Long id, HttpSession session) {
        User user = (User) session.getAttribute("loggedInUser");
        if (user == null) return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        leaveRequestService.cancelLeave(id, user);
        Map<String, String> response = new HashMap<>();
        response.put("message", "Leave cancelled successfully");
        return ResponseEntity.ok(response);
    }
}
