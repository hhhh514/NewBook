package com.example.social.api;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import java.time.LocalDateTime;
import java.util.List;

public final class ApiModels {
    private ApiModels() {
    }

    public record RegisterRequest(
            @NotBlank @Pattern(regexp = "^[0-9+ -]{8,20}$") String phoneNumber,
            @NotBlank @Size(max = 100) String userName,
            @NotBlank @Email String email,
            @NotBlank @Size(min = 8, max = 72) String password,
            @Pattern(regexp = "^(https?://[^\\s]{1,990})?$") String coverImage,
            @Size(max = 1000) String biography) {
    }

    public record LoginRequest(@NotBlank @Size(max = 255) String account, @NotBlank String password) {
    }

    public record AuthResponse(String token, UserView user) {
    }

    public record UserView(long userId, String phoneNumber, String userName, String email,
                           String coverImage, String biography) {
    }

    public record PublicUserView(long userId, String userName, String coverImage, String biography) {
    }

    public record PostRequest(@NotBlank @Size(max = 5000) String content,
                              @Pattern(regexp = "^(https?://[^\\s]{1,990})?$") String image) {
    }

    public record CommentRequest(@NotBlank @Size(max = 2000) String content) {
    }

    public record CommentView(long commentId, long userId, String userName, String content,
                              LocalDateTime createdAt) {
    }

    public record PostView(long postId, long userId, String userName, String content,
                           String image, LocalDateTime createdAt, List<CommentView> comments) {
    }
}
