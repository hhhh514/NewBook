CREATE DATABASE IF NOT EXISTS work
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE work;
CREATE TABLE users (
    user_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    phone_number VARCHAR(20) NOT NULL UNIQUE,
    user_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(100) NOT NULL,
    cover_image VARCHAR(1000) NULL,
    biography VARCHAR(1000) NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE posts (
    post_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    content VARCHAR(5000) NOT NULL,
    image VARCHAR(1000) NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_posts_user
        FOREIGN KEY (user_id) REFERENCES users(user_id),
    INDEX ix_posts_created_at (created_at)
);
CREATE TABLE comments (
    comment_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    post_id BIGINT NOT NULL,
    content VARCHAR(2000) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_comments_user
        FOREIGN KEY (user_id) REFERENCES users(user_id),
    CONSTRAINT fk_comments_post
        FOREIGN KEY (post_id) REFERENCES posts(post_id) ON DELETE CASCADE,
    INDEX ix_comments_post_created (post_id, created_at)
);
DELIMITER $$
CREATE PROCEDURE sp_create_user(
    IN p_phone VARCHAR(20),
    IN p_name VARCHAR(100),
    IN p_email VARCHAR(255),
    IN p_password VARCHAR(100),
    IN p_cover VARCHAR(1000),
    IN p_bio VARCHAR(1000)
)
BEGIN
    INSERT INTO users (
        phone_number,
        user_name,
        email,
        password_hash,
        cover_image,
        biography
    ) VALUES (
        p_phone,
        p_name,
        p_email,
        p_password,
        p_cover,
        p_bio
    );

    SELECT LAST_INSERT_ID() AS user_id;
END$$
CREATE PROCEDURE sp_get_user_by_phone(IN p_phone VARCHAR(20))
BEGIN
    SELECT user_id, phone_number, password_hash
    FROM users
    WHERE phone_number = p_phone;
END$$
CREATE PROCEDURE sp_get_user_by_account(IN p_account VARCHAR(255))
BEGIN
    SELECT user_id, phone_number, password_hash
    FROM users
    WHERE phone_number = p_account OR email = p_account;
END$$
CREATE PROCEDURE sp_get_user_by_id(IN p_user_id BIGINT)
BEGIN
    SELECT user_id, phone_number, user_name, email, cover_image, biography
    FROM users
    WHERE user_id = p_user_id;
END$$
CREATE PROCEDURE sp_get_public_user_by_id(IN p_user_id BIGINT)
BEGIN
    SELECT user_id, user_name, cover_image, biography
    FROM users
    WHERE user_id = p_user_id;
END$$
CREATE PROCEDURE sp_create_post(
    IN p_user_id BIGINT,
    IN p_content VARCHAR(5000),
    IN p_image VARCHAR(1000)
)
BEGIN
    INSERT INTO posts (user_id, content, image)
    VALUES (p_user_id, p_content, p_image);

    SELECT LAST_INSERT_ID() AS post_id;
END$$
CREATE PROCEDURE sp_list_posts()
BEGIN
    SELECT p.post_id, p.user_id, u.user_name, p.content, p.image, p.created_at
    FROM posts p
    JOIN users u ON u.user_id = p.user_id
    ORDER BY p.created_at DESC;
END$$
CREATE PROCEDURE sp_list_posts_by_user(IN p_user_id BIGINT)
BEGIN
    SELECT p.post_id, p.user_id, u.user_name, p.content, p.image, p.created_at
    FROM posts p
    JOIN users u ON u.user_id = p.user_id
    WHERE p.user_id = p_user_id
    ORDER BY p.created_at DESC;
END$$
CREATE PROCEDURE sp_list_comments(IN p_post_id BIGINT)
BEGIN
    SELECT c.comment_id, c.user_id, u.user_name, c.content, c.created_at
    FROM comments c
    JOIN users u ON u.user_id = c.user_id
    WHERE c.post_id = p_post_id
    ORDER BY c.created_at;
END$$

CREATE PROCEDURE sp_update_post(
    IN p_post_id BIGINT,
    IN p_user_id BIGINT,
    IN p_content VARCHAR(5000),
    IN p_image VARCHAR(1000)
)
BEGIN
    UPDATE posts
    SET content = p_content,
        image = p_image
    WHERE post_id = p_post_id
      AND user_id = p_user_id;

    SELECT ROW_COUNT() AS changed;
END$$

CREATE PROCEDURE sp_delete_post(
    IN p_post_id BIGINT,
    IN p_user_id BIGINT
)
BEGIN
    DELETE c
    FROM comments c
    JOIN posts p ON p.post_id = c.post_id
    WHERE p.post_id = p_post_id
      AND p.user_id = p_user_id;

    DELETE FROM posts
    WHERE post_id = p_post_id
      AND user_id = p_user_id;

    SELECT ROW_COUNT() AS changed;
END$$

CREATE PROCEDURE sp_create_comment(
    IN p_user_id BIGINT,
    IN p_post_id BIGINT,
    IN p_content VARCHAR(2000)
)
BEGIN
    INSERT INTO comments (user_id, post_id, content)
    VALUES (p_user_id, p_post_id, p_content);

    SELECT LAST_INSERT_ID() AS comment_id;
END$$

CREATE PROCEDURE sp_post_exists(IN p_post_id BIGINT)
BEGIN
    SELECT EXISTS(
        SELECT 1
        FROM posts
        WHERE post_id = p_post_id
    ) AS exists_flag;
END$$

DELIMITER ;
