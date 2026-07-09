package com.leave.management.service;

import com.leave.management.dto.RegisterDTO;
import com.leave.management.entity.User;
import com.leave.management.exception.ResourceNotFoundException;
import com.leave.management.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
public class UserService {
    @Autowired private UserRepository userRepository;
    @Autowired private PasswordEncoder passwordEncoder;

    @Transactional(readOnly = true)
    public User authenticate(String username, String password) {
        User user = userRepository.findByUsername(username);
        if (user != null && user.isEnabled() && passwordEncoder.matches(password, user.getPassword())) {
            return user;
        }
        return null;
    }

    public User register(RegisterDTO dto) {
        if (userRepository.existsByUsername(dto.getUsername())) throw new RuntimeException("Username already exists");
        if (userRepository.existsByEmail(dto.getEmail())) throw new RuntimeException("Email already exists");
        User user = new User();
        user.setUsername(dto.getUsername());
        user.setPassword(passwordEncoder.encode(dto.getPassword()));
        user.setEmail(dto.getEmail());
        user.setRole("EMPLOYEE");
        user.setEnabled(true);
        return userRepository.save(user);
    }

    @Transactional(readOnly = true)
    public User findByUsername(String username) {
        User user = userRepository.findByUsername(username);
        if (user == null) throw new ResourceNotFoundException("User not found: " + username);
        return user;
    }
}
