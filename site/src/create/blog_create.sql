create schema blog;
set search_path to blog;

create table "user"
(
    user_id  integer generated always as identity
        primary key,
    nickname varchar(16) not null
        unique
        constraint user_nickname_check
            check (length((nickname)::text) >= 3),
    email    text        not null
        unique
        constraint user_email_check
            check ((length(email) >= 6) AND (email ~~* '%@%.%'::text))
);

INSERT INTO blog."user" (nickname, email) VALUES ('denis', 'denis@example.com');
INSERT INTO blog."user" (nickname, email) VALUES ('bob', 'bob@example.com');


create table blogpost
(
    blogpost_id integer generated always as identity
        primary key,
    title       text               not null,
    contents    text               not null,
    date        date default now() not null,
    user_id     integer
        references "user"
);

INSERT INTO blog.blogpost (title, contents, date, user_id) VALUES ('select', 'how to use select statement', '2023-02-14', 1);
INSERT INTO blog.blogpost (title, contents, date, user_id) VALUES ('flask', 'intro to flask', '2023-02-14', 1);

create table topic
(
    topic_id    integer generated always as identity
        primary key,
    name        varchar(32) not null,
    description text
);

INSERT INTO blog.topic (name, description) VALUES ('DB', 'Database');
INSERT INTO blog.topic (name, description) VALUES ('Python', 'Python programming');

create table blogpost_topic
(
    blogpost_id integer not null
        references blogpost,
    topic_id    integer not null
        references topic,
    primary key (blogpost_id, topic_id)
);

INSERT INTO blog.blogpost_topic (blogpost_id, topic_id) VALUES (1, 1);
INSERT INTO blog.blogpost_topic (blogpost_id, topic_id) VALUES (2, 2);
INSERT INTO blog.blogpost_topic (blogpost_id, topic_id) VALUES (2, 1);


create table comment
(
    comment_id  integer generated always as identity
        primary key,
    contents    text               not null,
    date        date default now() not null,
    blogpost_id integer
        references blogpost,
    user_id     integer            not null
        references "user",
    reply_to_id integer
        references comment,
    constraint comment_check
        check ((blogpost_id IS NOT NULL) OR (reply_to_id IS NOT NULL))
);

INSERT INTO blog.comment (contents, date, blogpost_id, user_id, reply_to_id) VALUES ('nice article', '2023-02-14', 1, 2, null);
INSERT INTO blog.comment (contents, date, blogpost_id, user_id, reply_to_id) VALUES ('thank you', '2023-02-14', 1, 1, 1);
INSERT INTO blog.comment (contents, date, blogpost_id, user_id, reply_to_id) VALUES ('needs more details', '2023-02-14', 2, 2, null);
INSERT INTO blog.comment (contents, date, blogpost_id, user_id, reply_to_id) VALUES ('you''re welcome', '2023-02-14', 1, 2, 2);
INSERT INTO blog.comment (contents, date, blogpost_id, user_id, reply_to_id) VALUES ('some other comment', '2023-02-15', 1, 1, null);
