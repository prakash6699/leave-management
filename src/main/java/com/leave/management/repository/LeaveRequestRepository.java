package com.leave.management.repository;

import com.leave.management.entity.LeaveRequest;
import com.leave.management.entity.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface LeaveRequestRepository extends JpaRepository<LeaveRequest, Long> {
    Page<LeaveRequest> findByEmployeeOrderByCreatedAtDesc(User employee, Pageable pageable);
    Page<LeaveRequest> findByStatusOrderByCreatedAtDesc(String status, Pageable pageable);
    Page<LeaveRequest> findAllByOrderByCreatedAtDesc(Pageable pageable);

    @Query("SELECT lr FROM LeaveRequest lr WHERE " +
           "(:employeeId IS NULL OR lr.employee.id = :employeeId) AND " +
           "(:status IS NULL OR lr.status = :status) AND " +
           "(:leaveType IS NULL OR lr.leaveType = :leaveType)")
    Page<LeaveRequest> searchLeaves(@Param("employeeId") Long employeeId,
                                     @Param("status") String status,
                                     @Param("leaveType") String leaveType,
                                     Pageable pageable);

    @Query("SELECT COALESCE(SUM(lr.numberOfDays), 0) FROM LeaveRequest lr WHERE lr.employee.id = :employeeId AND lr.leaveType = :leaveType AND lr.status = 'APPROVED' AND lr.fromDate BETWEEN :fromDate AND :toDate")
    int sumApprovedDays(@Param("employeeId") Long employeeId, @Param("leaveType") String leaveType,
                        @Param("fromDate") java.time.LocalDate fromDate, @Param("toDate") java.time.LocalDate toDate);
}
