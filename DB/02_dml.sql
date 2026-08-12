USE work;
SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

INSERT INTO users (
    phone_number,
    user_name,
    email,
    password_hash,
    cover_image,
    biography
) VALUES
    (
        '0912345678',
        '王小明',
        'ming@example.com',
        '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
        'https://picsum.photos/seed/ming/1200/400',
        '喜歡攝影、旅行和咖啡。'
    ),
    (
        '0923456789',
        '陳美玲',
        'meiling@example.com',
        '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
        'https://picsum.photos/seed/meiling/1200/400',
        '熱愛料理，也喜歡分享生活。'
    ),
    (
        '0934567890',
        '林志豪',
        'zhihao@example.com',
        '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
        'https://picsum.photos/seed/zhihao/1200/400',
        '軟體工程師，假日喜歡爬山。'
    );

INSERT INTO posts (user_id, content, image, created_at) VALUES
    ((SELECT user_id FROM users WHERE email = 'ming@example.com'),
     '週末去了陽明山走走，天氣很好，沿途的風景也很漂亮！',
     'https://picsum.photos/seed/yangmingshan/900/600',
     '2026-08-10 09:15:00'),
    ((SELECT user_id FROM users WHERE email = 'ming@example.com'),
     '今天找到一間很舒服的咖啡店，手沖咖啡香氣十足。',
     'https://picsum.photos/seed/coffee-shop/900/600',
     '2026-08-11 14:30:00'),
    ((SELECT user_id FROM users WHERE email = 'meiling@example.com'),
     '第一次挑戰自己做巴斯克乳酪蛋糕，成果比想像中成功！',
     'https://picsum.photos/seed/cheesecake/900/600',
     '2026-08-10 11:20:00'),
    ((SELECT user_id FROM users WHERE email = 'meiling@example.com'),
     '分享今天的晚餐：番茄燉牛肉，配白飯真的很適合。',
     'https://picsum.photos/seed/beef-stew/900/600',
     '2026-08-12 18:40:00'),
    ((SELECT user_id FROM users WHERE email = 'zhihao@example.com'),
     '終於完成手邊的專案，準備好好休息一個週末。',
     NULL,
     '2026-08-09 20:10:00'),
    ((SELECT user_id FROM users WHERE email = 'zhihao@example.com'),
     '清晨登上山頂看到日出，早起的一切都值得了。',
     'https://picsum.photos/seed/sunrise-hike/900/600',
     '2026-08-12 06:25:00');


INSERT INTO comments (user_id, post_id, content, created_at) VALUES
    ((SELECT user_id FROM users WHERE email = 'ming@example.com'),
     (SELECT post_id FROM posts WHERE content LIKE '第一次挑戰自己做巴斯克%' LIMIT 1),
     '看起來超好吃，可以分享食譜嗎？',
     '2026-08-10 12:05:00'),
    ((SELECT user_id FROM users WHERE email = 'ming@example.com'),
     (SELECT post_id FROM posts WHERE content LIKE '終於完成手邊的專案%' LIMIT 1),
     '辛苦了，週末好好放鬆！',
     '2026-08-10 20:35:00'),
    ((SELECT user_id FROM users WHERE email = 'ming@example.com'),
     (SELECT post_id FROM posts WHERE content LIKE '清晨登上山頂看到日出%' LIMIT 1),
     '這個日出太美了，下次也想去。',
     '2026-08-12 07:10:00'),
    ((SELECT user_id FROM users WHERE email = 'meiling@example.com'),
     (SELECT post_id FROM posts WHERE content LIKE '週末去了陽明山走走%' LIMIT 1),
     '照片拍得真漂亮，天氣看起來很舒服！',
     '2026-08-10 10:00:00'),
    ((SELECT user_id FROM users WHERE email = 'meiling@example.com'),
     (SELECT post_id FROM posts WHERE content LIKE '今天找到一間很舒服的咖啡店%' LIMIT 1),
     '這間店感覺很棒，已經收藏了。',
     '2026-08-11 15:10:00'),
    ((SELECT user_id FROM users WHERE email = 'meiling@example.com'),
     (SELECT post_id FROM posts WHERE content LIKE '清晨登上山頂看到日出%' LIMIT 1),
     '能看到這樣的景色真的很值得！',
     '2026-08-12 07:25:00'),
    ((SELECT user_id FROM users WHERE email = 'zhihao@example.com'),
     (SELECT post_id FROM posts WHERE content LIKE '週末去了陽明山走走%' LIMIT 1),
     '陽明山很適合週末散步。',
     '2026-08-10 10:20:00'),
    ((SELECT user_id FROM users WHERE email = 'zhihao@example.com'),
     (SELECT post_id FROM posts WHERE content LIKE '第一次挑戰自己做巴斯克%' LIMIT 1),
     '第一次就做得這麼漂亮，太厲害了！',
     '2026-08-10 12:30:00'),
    ((SELECT user_id FROM users WHERE email = 'zhihao@example.com'),
     (SELECT post_id FROM posts WHERE content LIKE '分享今天的晚餐%' LIMIT 1),
     '番茄燉牛肉看起來很下飯！',
     '2026-08-12 19:05:00');
