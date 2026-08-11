USE work;
DROP PROCEDURE IF EXISTS sp_get_user_by_phone;
DROP PROCEDURE IF EXISTS sp_get_user_by_id;
DROP PROCEDURE IF EXISTS sp_list_posts;
DROP PROCEDURE IF EXISTS sp_list_comments;
DROP PROCEDURE IF EXISTS sp_post_exists;
DROP PROCEDURE IF EXISTS sp_delete_post;
DELIMITER $$
CREATE PROCEDURE sp_get_user_by_phone(IN p_phone VARCHAR(20)) BEGIN SELECT user_id,phone_number,password_hash FROM users WHERE phone_number=p_phone; END$$
CREATE PROCEDURE sp_get_user_by_id(IN p_user_id BIGINT) BEGIN SELECT user_id,phone_number,user_name,email,cover_image,biography FROM users WHERE user_id=p_user_id; END$$
CREATE PROCEDURE sp_list_posts() BEGIN SELECT p.post_id,p.user_id,u.user_name,p.content,p.image,p.created_at FROM posts p JOIN users u ON u.user_id=p.user_id ORDER BY p.created_at DESC; END$$
CREATE PROCEDURE sp_list_comments(IN p_post_id BIGINT) BEGIN SELECT c.comment_id,c.user_id,u.user_name,c.content,c.created_at FROM comments c JOIN users u ON u.user_id=c.user_id WHERE c.post_id=p_post_id ORDER BY c.created_at; END$$
CREATE PROCEDURE sp_post_exists(IN p_post_id BIGINT) BEGIN SELECT EXISTS(SELECT 1 FROM posts WHERE post_id=p_post_id) AS exists_flag; END$$
CREATE PROCEDURE sp_delete_post(IN p_post_id BIGINT, IN p_user_id BIGINT)
BEGIN
  DELETE c FROM comments c JOIN posts p ON p.post_id=c.post_id WHERE p.post_id=p_post_id AND p.user_id=p_user_id;
  DELETE FROM posts WHERE post_id=p_post_id AND user_id=p_user_id;
  SELECT ROW_COUNT() AS changed;
END$$
DELIMITER ;
