CREATE SCHEMA IF NOT EXISTS contacts;
SET SEARCH_PATH TO contacts;

-- contact table
DROP TABLE IF EXISTS call;
DROP TABLE IF EXISTS contact;

CREATE TABLE contact
(
    contact_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name       VARCHAR(50) NOT NULL,
    phone      VARCHAR(50),
    address    VARCHAR(100),
    email      VARCHAR(50)
);

-- error because contact_id always generated
-- INSERT INTO contact
-- VALUES (1, 'John Doe', '111-111-1111', 'Montreal', 'john@example.com');
INSERT INTO contact(name, phone, address, email)
VALUES ('John Doe', '111-111-1111', 'Montreal', 'john@example.com');
INSERT INTO contact(name, email, phone)
VALUES ('Jane Doe', 'jane@example.com', '333-333-3333');
INSERT INTO contact(name, email)
VALUES ('Alice', 'alice@example.com');

-- SELECT *
-- FROM contact;

-- call table

CREATE TABLE call
(
    call_id    INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    phone      VARCHAR(50)                         NOT NULL,
    datetime   TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    contact_id INTEGER REFERENCES contact (contact_id)
);

INSERT INTO call(phone, datetime, contact_id)
VALUES ('111-111-1111', '2020-01-01 01:01', 1);
INSERT INTO call(phone, datetime)
VALUES ('222-222-2222', '2019-12-22 22:22');
INSERT INTO call(phone, contact_id)
VALUES ('111-111-1111', 1);

-- SELECT *
-- FROM call;

COMMIT WORK;