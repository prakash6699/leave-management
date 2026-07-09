package com.leave.management.config;

import com.leave.management.entity.LeaveBalance;
import com.leave.management.entity.LeaveRequest;
import com.leave.management.entity.User;
import com.leave.management.repository.LeaveBalanceRepository;
import com.leave.management.repository.LeaveRequestRepository;
import com.leave.management.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;
import java.time.LocalDate;

@Component
public class DataInitializer implements CommandLineRunner {
    @Autowired private UserRepository userRepository;
    @Autowired private LeaveBalanceRepository leaveBalanceRepository;
    @Autowired private LeaveRequestRepository leaveRequestRepository;
    @Autowired private PasswordEncoder passwordEncoder;

    @Override
    public void run(String... args) {
        if (userRepository.findByUsername("admin") == null) {
            User admin = new User();
            admin.setUsername("admin");
            admin.setPassword(passwordEncoder.encode("admin123"));
            admin.setEmail("admin@company.com");
            admin.setRole("ADMIN");
            admin.setEnabled(true);
            userRepository.save(admin);
            System.out.println("Admin created: admin/admin123");
        }

        if (userRepository.findByUsername("jothi") == null) {
            User jothi = new User();
            jothi.setUsername("jothi");
            jothi.setPassword(passwordEncoder.encode("Jothi@123"));
            jothi.setEmail("jothi@company.com");
            jothi.setRole("EMPLOYEE");
            jothi.setEnabled(true);
            userRepository.save(jothi);

            int year = LocalDate.now().getYear();
            leaveBalanceRepository.save(new LeaveBalance(jothi, "Annual", 20, year));
            leaveBalanceRepository.save(new LeaveBalance(jothi, "Sick", 10, year));
            leaveBalanceRepository.save(new LeaveBalance(jothi, "Personal", 5, year));
            System.out.println("Employee created: jothi/Jothi@123");
        }
    }
}
