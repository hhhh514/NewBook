package com.example.social.service;
import com.example.social.api.ApiModels.AuthResponse;
import com.example.social.api.ApiModels.CommentRequest;
import com.example.social.api.ApiModels.LoginRequest;
import com.example.social.api.ApiModels.PostRequest;
import com.example.social.api.ApiModels.PostView;
import com.example.social.api.ApiModels.PublicUserView;
import com.example.social.api.ApiModels.RegisterRequest;
import com.example.social.data.SocialRepository;
import com.example.social.security.JwtService;
import java.util.List;
import java.util.Map;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class SocialService {
    private final SocialRepository repository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;

    public SocialService(SocialRepository repository, PasswordEncoder passwordEncoder, JwtService jwtService) {
        this.repository = repository;
        this.passwordEncoder = passwordEncoder;
        this.jwtService = jwtService;
    }

    @Transactional
    public AuthResponse register(RegisterRequest request) {
        long userId = repository.createUser(request, passwordEncoder.encode(request.password()));
        return new AuthResponse(jwtService.create(userId), repository.user(userId).orElseThrow());
    }

    public AuthResponse login(LoginRequest request) {
        Map<String, Object> user = repository.findUser(request.account())
                .filter(value -> passwordEncoder.matches(request.password(), (String) value.get("password_hash")))
                .orElseThrow(() -> new IllegalArgumentException("登入失敗"));
        long userId = (long) user.get("user_id");
        return new AuthResponse(jwtService.create(userId), repository.user(userId).orElseThrow());
    }

    public List<PostView> posts() {
        return repository.posts();
    }

    public PublicUserView publicUser(long userId) {
        return repository.publicUser(userId).orElseThrow(() -> new IllegalArgumentException("使用者不存在"));
    }

    public List<PostView> postsByUser(long userId) {
        return repository.postsByUser(userId);
    }

    @Transactional
    public long createPost(long userId, PostRequest request) {
        return repository.createPost(userId, request);
    }

    @Transactional
    public void updatePost(long userId, long postId, PostRequest request) {
        if (repository.updatePost(postId, userId, request) == 0) throw new SecurityException();
    }

    @Transactional
    public void deletePost(long userId, long postId) {
        if (repository.deletePost(postId, userId) == 0) throw new SecurityException();
    }

    @Transactional
    public long comment(long userId, long postId, CommentRequest request) {
        if (!repository.postExists(postId)) throw new IllegalArgumentException("文章不存在");
        return repository.createComment(userId, postId, request);
    }
}
