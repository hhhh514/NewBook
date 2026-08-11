USE work;

DROP PROCEDURE IF EXISTS sp_get_public_user_by_id;
DROP PROCEDURE IF EXISTS sp_list_posts_by_user;

DELIMITER $$
CREATE PROCEDURE sp_get_public_user_by_id(IN p_user_id BIGINT)
BEGIN
    SELECT user_id, user_name, cover_image, biography
    FROM users
    WHERE user_id = p_user_id;
END$$

CREATE PROCEDURE sp_list_posts_by_user(IN p_user_id BIGINT)
BEGIN
    SELECT p.post_id, p.user_id, u.user_name, p.content, p.image, p.created_at
    FROM posts p
    JOIN users u ON u.user_id = p.user_id
    WHERE p.user_id = p_user_id
    ORDER BY p.created_at DESC;
END$$
DELIMITER ;
