package com.leave.management.controller;

import com.leave.management.dto.LoginDTO;
import com.leave.management.dto.RegisterDTO;
import com.leave.management.entity.User;
import com.leave.management.service.UserService;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
public class AuthController {
    @Autowired private UserService userService;

    @GetMapping("/login")
    public String showLoginPage(Model model) {
        model.addAttribute("loginDTO", new LoginDTO());
        return "login";
    }

    @PostMapping("/login")
    public String processLogin(@Valid @ModelAttribute LoginDTO loginDTO, BindingResult result,
                               HttpSession session, RedirectAttributes redirectAttributes) {
        if (result.hasErrors()) return "login";
        User user = userService.authenticate(loginDTO.getUsername(), loginDTO.getPassword());
        if (user == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "Invalid username or password");
            return "redirect:/login";
        }
        session.setAttribute("loggedInUser", user);
        session.setAttribute("username", user.getUsername());
        session.setAttribute("userRole", user.getRole());
        return "redirect:/dashboard";
    }

    @GetMapping("/register")
    public String showRegisterPage(Model model) {
        model.addAttribute("registerDTO", new RegisterDTO());
        return "register";
    }

    @PostMapping("/register")
    public String processRegister(@Valid @ModelAttribute RegisterDTO registerDTO, BindingResult result,
                                  RedirectAttributes redirectAttributes) {
        if (result.hasErrors()) return "register";
        if (!registerDTO.getPassword().equals(registerDTO.getConfirmPassword())) {
            result.rejectValue("confirmPassword", "error", "Passwords do not match");
            return "register";
        }
        try {
            userService.register(registerDTO);
            redirectAttributes.addFlashAttribute("successMessage", "Registration successful! Please login.");
            return "redirect:/login";
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/register";
        }
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }
}
