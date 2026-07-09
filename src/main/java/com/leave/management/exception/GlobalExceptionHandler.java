package com.leave.management.exception;

import jakarta.servlet.http.HttpServletRequest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.ModelAndView;
import java.util.HashMap;
import java.util.Map;

@ControllerAdvice
public class GlobalExceptionHandler {
    private static final Logger logger = LoggerFactory.getLogger(GlobalExceptionHandler.class);

    @ExceptionHandler(ResourceNotFoundException.class)
    public Object handleResourceNotFound(ResourceNotFoundException ex, HttpServletRequest request) {
        logger.error("Resource not found: {}", ex.getMessage());
        if (isApiRequest(request)) {
            Map<String, String> error = new HashMap<>();
            error.put("message", ex.getMessage());
            return new ResponseEntity<>(error, HttpStatus.NOT_FOUND);
        }
        ModelAndView mv = new ModelAndView("error");
        mv.addObject("statusCode", 404);
        mv.addObject("errorMessage", ex.getMessage());
        mv.addObject("errorTitle", "Resource Not Found");
        return mv;
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public Object handleValidationExceptions(MethodArgumentNotValidException ex, HttpServletRequest request) {
        if (isApiRequest(request)) {
            Map<String, String> errors = new HashMap<>();
            ex.getBindingResult().getAllErrors().forEach(e -> errors.put(((FieldError) e).getField(), e.getDefaultMessage()));
            return new ResponseEntity<>(errors, HttpStatus.BAD_REQUEST);
        }
        ModelAndView mv = new ModelAndView("error");
        Map<String, String> errors = new HashMap<>();
        ex.getBindingResult().getAllErrors().forEach(e -> errors.put(((FieldError) e).getField(), e.getDefaultMessage()));
        mv.addObject("statusCode", 400);
        mv.addObject("errorMessage", "Validation failed");
        mv.addObject("errorTitle", "Validation Error");
        mv.addObject("errors", errors);
        return mv;
    }

    @ExceptionHandler(RuntimeException.class)
    public Object handleRuntimeException(RuntimeException ex, HttpServletRequest request) {
        logger.error("Runtime exception: {}", ex.getMessage(), ex);
        if (isApiRequest(request)) {
            Map<String, String> error = new HashMap<>();
            error.put("message", ex.getMessage());
            return new ResponseEntity<>(error, HttpStatus.BAD_REQUEST);
        }
        ModelAndView mv = new ModelAndView("error");
        mv.addObject("statusCode", 500);
        mv.addObject("errorMessage", ex.getMessage());
        mv.addObject("errorTitle", "Internal Server Error");
        return mv;
    }

    @ExceptionHandler(Exception.class)
    public ModelAndView handleGenericException(Exception ex) {
        logger.error("Unexpected exception: {}", ex.getMessage(), ex);
        ModelAndView mv = new ModelAndView("error");
        mv.addObject("statusCode", 500);
        mv.addObject("errorMessage", ex.getMessage());
        mv.addObject("errorTitle", "Internal Server Error");
        return mv;
    }

    private boolean isApiRequest(HttpServletRequest request) {
        if (request == null) return false;
        String accept = request.getHeader("Accept");
        return accept != null && (accept.contains(MediaType.APPLICATION_JSON_VALUE) || accept.contains(MediaType.APPLICATION_XML_VALUE));
    }
}
