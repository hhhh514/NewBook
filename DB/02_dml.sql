USE work;

-- 範例使用者；密碼為 password，資料庫中只保存 BCrypt 雜湊值。
INSERT INTO users (
    phone_number,
    user_name,
    email,
    password_hash,
    biography
) VALUES (
    '0912345678',
    'Demo User',
    'demo@example.com',
    '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
    'Hello!'
);
