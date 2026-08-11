package com.example.social.common;

import java.util.Map;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
public class ApiExceptionHandler {
    @ExceptionHandler({IllegalArgumentException.class, DataIntegrityViolationException.class})
    ResponseEntity<?> badRequest(Exception exception) {
        return ResponseEntity.badRequest().body(Map.of("message", "請確認輸入資料是否正確或帳號是否重複"));
    }

    @ExceptionHandler(SecurityException.class)
    ResponseEntity<?> forbidden() {
        return ResponseEntity.status(HttpStatus.FORBIDDEN).body(Map.of("message", "沒有操作權限"));
    }
}
