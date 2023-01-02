create schema blog;
set search_path to blog;

-- user(USER_ID, nickname, email)
create table "user"
(
    user_id  integer generated always as identity primary key,
    nickname varchar(16) unique not null,
    email    text unique        not null,
    check ( length(nickname) >= 3 ),
    check ( length(email) >= 6 and email ilike '%@%.%')
);

-- blogpost(BLOGPOST_ID, title, contents, date, user_id*)
create table blogpost
(
    blogpost_id integer generated always as identity primary key,
    title       text               not null,
    contents    text               not null,
    date        date default now() not null,
    user_id     integer references "user" (user_id)
);

-- topic(TOPIC_ID, name, description)
create table topic
(
    topic_id    integer generated always as identity primary key,
    name        varchar(32) not null,
    description text
);

-- blogpost_topic(blogpost_id*, topic_id*)
create table blogpost_topic
(
    blogpost_id integer references blogpost (blogpost_id) not null,
    topic_id    integer references topic (topic_id)       not null,
    primary key (blogpost_id, topic_id)
);

-- comment(COMMENT_ID, contents, date, blogpost_id*, user_id*, reply_to_id*)
create table comment
(
    comment_id  integer generated always as identity primary key,
    contents    text                                not null,
    date        date default now() not null,
    blogpost_id integer references blogpost (blogpost_id),
    user_id     integer references "user" (user_id) not null,
    reply_to_id integer references comment (comment_id),
    check (blogpost_id is not null or reply_to_id is not null)
);

