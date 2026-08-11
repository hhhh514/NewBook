package com.example.social.data;
import com.example.social.api.ApiModels.CommentRequest;
import com.example.social.api.ApiModels.CommentView;
import com.example.social.api.ApiModels.PostRequest;
import com.example.social.api.ApiModels.PostView;
import com.example.social.api.ApiModels.PublicUserView;
import com.example.social.api.ApiModels.RegisterRequest;
import com.example.social.api.ApiModels.UserView;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

@Repository
public class SocialRepository {
    private final JdbcTemplate database;

    public SocialRepository(JdbcTemplate database) {
        this.database = database;
    }

    public Optional<Map<String, Object>> findUser(String account) {
        return database.query("CALL sp_get_user_by_account(?)",
                resultSet -> resultSet.next() ? Optional.of(loginUser(resultSet)) : Optional.empty(), account);
    }

    public Optional<UserView> user(long userId) {
        return database.query("CALL sp_get_user_by_id(?)",
                resultSet -> resultSet.next() ? Optional.of(userView(resultSet)) : Optional.empty(), userId);
    }

    public Optional<PublicUserView> publicUser(long userId) {
        return database.query("CALL sp_get_public_user_by_id(?)",
                resultSet -> resultSet.next() ? Optional.of(publicUserView(resultSet)) : Optional.empty(), userId);
    }

    public long createUser(RegisterRequest request, String passwordHash) {
        return database.queryForObject("CALL sp_create_user(?,?,?,?,?,?)", Long.class,
                request.phoneNumber(), request.userName(), request.email(), passwordHash,
                request.coverImage(), request.biography());
    }

    public long createPost(long userId, PostRequest request) {
        return database.queryForObject("CALL sp_create_post(?,?,?)", Long.class,
                userId, request.content(), request.image());
    }

    public int updatePost(long postId, long userId, PostRequest request) {
        return database.queryForObject("CALL sp_update_post(?,?,?,?)", Integer.class,
                postId, userId, request.content(), request.image());
    }

    public int deletePost(long postId, long userId) {
        return database.queryForObject("CALL sp_delete_post(?,?)", Integer.class, postId, userId);
    }

    public long createComment(long userId, long postId, CommentRequest request) {
        return database.queryForObject("CALL sp_create_comment(?,?,?)", Long.class,
                userId, postId, request.content());
    }

    public boolean postExists(long postId) {
        return Boolean.TRUE.equals(database.queryForObject("CALL sp_post_exists(?)", Boolean.class, postId));
    }

    public List<PostView> posts() {
        return database.query("CALL sp_list_posts()", (resultSet, rowNum) -> postView(resultSet));
    }

    public List<PostView> postsByUser(long userId) {
        return database.query("CALL sp_list_posts_by_user(?)", (resultSet, rowNum) -> postView(resultSet), userId);
    }

    private List<CommentView> comments(long postId) {
        return database.query("CALL sp_list_comments(?)", (resultSet, rowNum) -> new CommentView(
                resultSet.getLong("comment_id"),
                resultSet.getLong("user_id"),
                resultSet.getString("user_name"),
                resultSet.getString("content"),
                resultSet.getTimestamp("created_at").toLocalDateTime()), postId);
    }

    private static Map<String, Object> loginUser(ResultSet resultSet) throws SQLException {
        Map<String, Object> user = new HashMap<>();
        user.put("user_id", resultSet.getLong("user_id"));
        user.put("phone_number", resultSet.getString("phone_number"));
        user.put("password_hash", resultSet.getString("password_hash"));
        return user;
    }

    private static UserView userView(ResultSet resultSet) throws SQLException {
        return new UserView(
                resultSet.getLong("user_id"),
                resultSet.getString("phone_number"),
                resultSet.getString("user_name"),
                resultSet.getString("email"),
                resultSet.getString("cover_image"),
                resultSet.getString("biography"));
    }

    private PostView postView(ResultSet resultSet) throws SQLException {
        long postId = resultSet.getLong("post_id");
        return new PostView(
                postId,
                resultSet.getLong("user_id"),
                resultSet.getString("user_name"),
                resultSet.getString("content"),
                resultSet.getString("image"),
                resultSet.getTimestamp("created_at").toLocalDateTime(),
                comments(postId));
    }

    private static PublicUserView publicUserView(ResultSet resultSet) throws SQLException {
        return new PublicUserView(
                resultSet.getLong("user_id"),
                resultSet.getString("user_name"),
                resultSet.getString("cover_image"),
                resultSet.getString("biography"));
    }
}
