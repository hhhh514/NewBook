-- 已建立資料庫時，執行此檔即可支援以手機號碼或 Email 登入。
USE work;

DROP PROCEDURE IF EXISTS sp_get_user_by_account;

DELIMITER $$
CREATE PROCEDURE sp_get_user_by_account(IN p_account VARCHAR(255))
BEGIN
    SELECT user_id, phone_number, password_hash
    FROM users
    WHERE phone_number = p_account OR email = p_account;
END$$
DELIMITER ;
