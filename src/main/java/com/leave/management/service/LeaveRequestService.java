package com.leave.management.service;

import com.leave.management.dto.LeaveRequestDTO;
import com.leave.management.entity.LeaveBalance;
import com.leave.management.entity.LeaveRequest;
import com.leave.management.entity.User;
import com.leave.management.exception.ResourceNotFoundException;
import com.leave.management.repository.LeaveRequestRepository;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

@Service
@Transactional
public class LeaveRequestService {
    @Autowired private LeaveRequestRepository leaveRequestRepository;
    @Autowired private LeaveBalanceService leaveBalanceService;

    @Transactional(readOnly = true)
    public Page<LeaveRequest> getAllLeaves(int page, int size, String sortBy, String sortDir) {
        Sort sort = sortDir.equalsIgnoreCase("desc") ? Sort.by(sortBy).descending() : Sort.by(sortBy).ascending();
        return leaveRequestRepository.findAllByOrderByCreatedAtDesc(PageRequest.of(page, size, sort));
    }

    @Transactional(readOnly = true)
    public Page<LeaveRequest> searchLeaves(Long employeeId, String status, String leaveType, int page, int size, String sortBy, String sortDir) {
        Sort sort = sortDir.equalsIgnoreCase("desc") ? Sort.by(sortBy).descending() : Sort.by(sortBy).ascending();
        return leaveRequestRepository.searchLeaves(employeeId, status, leaveType, PageRequest.of(page, size, sort));
    }

    @Transactional(readOnly = true)
    public Page<LeaveRequest> getLeavesByEmployee(User employee, int page, int size) {
        return leaveRequestRepository.findByEmployeeOrderByCreatedAtDesc(employee, PageRequest.of(page, size));
    }

    @Transactional(readOnly = true)
    public LeaveRequest getLeaveById(Long id) {
        return leaveRequestRepository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Leave request not found with id: " + id));
    }

    public LeaveRequest createLeave(LeaveRequestDTO dto, User employee, HttpServletRequest request) {
        if (dto.getToDate().isBefore(dto.getFromDate())) {
            throw new RuntimeException("End date cannot precede start date");
        }

        int days = (int) ChronoUnit.DAYS.between(dto.getFromDate(), dto.getToDate()) + 1;

        if (!leaveBalanceService.hasEnoughBalance(employee, dto.getLeaveType(), days)) {
            LeaveBalance balance = leaveBalanceService.getBalance(employee, dto.getLeaveType(), LocalDate.now().getYear());
            throw new RuntimeException("Insufficient leave balance. Remaining: " + balance.getRemainingDays() + " days");
        }

        LeaveRequest leave = new LeaveRequest();
        leave.setEmployee(employee);
        leave.setLeaveType(dto.getLeaveType());
        leave.setFromDate(dto.getFromDate());
        leave.setToDate(dto.getToDate());
        leave.setNumberOfDays(days);
        leave.setReason(dto.getReason());
        leave.setStatus("PENDING");

        return leaveRequestRepository.save(leave);
    }

    public LeaveRequest updateLeave(Long id, LeaveRequestDTO dto, User employee) {
        LeaveRequest existing = getLeaveById(id);

        if ("APPROVED".equals(existing.getStatus())) {
            throw new RuntimeException("Approved leave cannot be modified");
        }

        if (!existing.getEmployee().getId().equals(employee.getId())) {
            throw new RuntimeException("You can only edit your own leave requests");
        }

        if (dto.getToDate().isBefore(dto.getFromDate())) {
            throw new RuntimeException("End date cannot precede start date");
        }

        int newDays = (int) ChronoUnit.DAYS.between(dto.getFromDate(), dto.getToDate()) + 1;
        int dayDiff = newDays - existing.getNumberOfDays();

        if (dayDiff > 0 && !leaveBalanceService.hasEnoughBalance(employee, dto.getLeaveType(), dayDiff)) {
            throw new RuntimeException("Insufficient leave balance for additional days");
        }

        existing.setLeaveType(dto.getLeaveType());
        existing.setFromDate(dto.getFromDate());
        existing.setToDate(dto.getToDate());
        existing.setNumberOfDays(newDays);
        existing.setReason(dto.getReason());

        return leaveRequestRepository.save(existing);
    }

    public void cancelLeave(Long id, User employee) {
        LeaveRequest leave = getLeaveById(id);
        if (!leave.getEmployee().getId().equals(employee.getId())) {
            throw new RuntimeException("You can only cancel your own leave requests");
        }
        if ("APPROVED".equals(leave.getStatus())) {
            leaveBalanceService.revertUsedDays(employee, leave.getLeaveType(), leave.getNumberOfDays(), LocalDate.now().getYear());
        }
        leave.setStatus("CANCELLED");
        leaveRequestRepository.save(leave);
    }

    public LeaveRequest approveLeave(Long id, String approver, HttpServletRequest request) {
        LeaveRequest leave = getLeaveById(id);
        if (!"PENDING".equals(leave.getStatus())) {
            throw new RuntimeException("Only pending leaves can be approved");
        }
        leave.setStatus("APPROVED");
        leave.setApprovedBy(approver);
        leave.setApprovedAt(java.time.LocalDateTime.now());
        leaveBalanceService.updateUsedDays(leave.getEmployee(), leave.getLeaveType(), leave.getNumberOfDays(), LocalDate.now().getYear());

        System.out.println("Email Notification: Leave approved for " + leave.getEmployee().getUsername() +
            " | Type: " + leave.getLeaveType() + " | Days: " + leave.getNumberOfDays());

        return leaveRequestRepository.save(leave);
    }

    public LeaveRequest rejectLeave(Long id, String approver, String rejectionReason) {
        LeaveRequest leave = getLeaveById(id);
        if (!"PENDING".equals(leave.getStatus())) {
            throw new RuntimeException("Only pending leaves can be rejected");
        }
        leave.setStatus("REJECTED");
        leave.setApprovedBy(approver);
        leave.setRejectionReason(rejectionReason);

        System.out.println("Email Notification: Leave rejected for " + leave.getEmployee().getUsername() +
            " | Reason: " + rejectionReason);

        return leaveRequestRepository.save(leave);
    }
}
