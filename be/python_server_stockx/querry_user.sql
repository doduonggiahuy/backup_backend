CREATE TABLE "user" (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    full_name VARCHAR(100),
    phone_number BIGINT,
    address VARCHAR(255),
    google_id VARCHAR(255),
    device_key VARCHAR(255),
    avatar_url VARCHAR(255),
    role_code INT,
    refresh_token TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


SELECT * FROM public."user"

INSERT INTO "user" (username, password_hash, email, full_name, phone_number, address, google_id, device_key, avatar_url, role_code, refresh_token) 
                                   VALUES ('Huy', '12345678', 'huy@gmail.com', 'Do Duong Gia Huy', 0914143565, 'Hoa Phuoc, Hoa Vang, Da Nẵng', '', '', '', 0, '12345678')