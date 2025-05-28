CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone VARCHAR(255)
);

CREATE TABLE courses (id SERIAL PRIMARY KEY, duration INTERVAL NOT NULL);

CREATE TABLE user_courses (
    user_id INTEGER NOT NULL REFERENCES users (id),
    course_id INTEGER NOT NULL REFERENCES courses (id),
    PRIMARY KEY (user_id, course_id)
);

CREATE TABLE drugs (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    price NUMERIC(10, 2) NOT NULL,
    expiration_date DATE NOT NULL
);

CREATE TABLE user_drugs (
    user_id INTEGER NOT NULL REFERENCES users (id),
    drug_id INTEGER NOT NULL REFERENCES drugs (id),
    PRIMARY KEY (user_id, drug_id)
);
