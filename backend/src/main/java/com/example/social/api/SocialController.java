package com.example.social.api;

import com.example.social.api.ApiModels.AuthResponse;
import com.example.social.api.ApiModels.CommentRequest;
import com.example.social.api.ApiModels.LoginRequest;
import com.example.social.api.ApiModels.PostRequest;
import com.example.social.api.ApiModels.PostView;
import com.example.social.api.ApiModels.PublicUserView;
import com.example.social.api.ApiModels.RegisterRequest;
import com.example.social.service.SocialService;
import jakarta.validation.Valid;
import java.util.List;
import java.util.Map;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api")
@CrossOrigin(origins = "http://localhost:5173")
public class SocialController {
    private final SocialService service;

    public SocialController(SocialService service) {
        this.service = service;
    }

    private long me(Authentication authentication) {
        if (authentication == null || !(authentication.getPrincipal() instanceof Long)) {
            throw new SecurityException();
        }
        return (Long) authentication.getPrincipal();
    }

    @PostMapping("/auth/register")
    @ResponseStatus(HttpStatus.CREATED)
    AuthResponse register(@Valid @RequestBody RegisterRequest request) {
        return service.register(request);
    }

    @PostMapping("/auth/login")
    AuthResponse login(@Valid @RequestBody LoginRequest request) {
        return service.login(request);
    }

    @GetMapping("/posts")
    List<PostView> posts() {
        return service.posts();
    }

    @GetMapping("/users/{id}")
    PublicUserView user(@PathVariable long id) {
        return service.publicUser(id);
    }

    @GetMapping("/users/{id}/posts")
    List<PostView> postsByUser(@PathVariable long id) {
        return service.postsByUser(id);
    }

    @PostMapping("/posts")
    @ResponseStatus(HttpStatus.CREATED)
    Map<String, Long> create(@Valid @RequestBody PostRequest request, Authentication authentication) {
        return Map.of("postId", service.createPost(me(authentication), request));
    }

    @PutMapping("/posts/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    void update(@PathVariable long id, @Valid @RequestBody PostRequest request, Authentication authentication) {
        service.updatePost(me(authentication), id, request);
    }

    @DeleteMapping("/posts/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    void delete(@PathVariable long id, Authentication authentication) {
        service.deletePost(me(authentication), id);
    }

    @PostMapping("/posts/{id}/comments")
    @ResponseStatus(HttpStatus.CREATED)
    Map<String, Long> comment(@PathVariable long id, @Valid @RequestBody CommentRequest request,
                              Authentication authentication) {
        return Map.of("commentId", service.comment(me(authentication), id, request));
    }
}
