--
-- PostgreSQL database dump
--

-- Dumped from database version 14.6 (Ubuntu 14.6-0ubuntu0.22.04.1)
-- Dumped by pg_dump version 14.6 (Ubuntu 14.6-0ubuntu0.22.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: blog; Type: SCHEMA; Schema: -; Owner: vanierdb
--

CREATE SCHEMA blog;


-- ALTER SCHEMA blog OWNER TO vanierdb;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: blogpost; Type: TABLE; Schema: blog; Owner: vanierdb
--

CREATE TABLE blog.blogpost (
    blogpost_id integer NOT NULL,
    title text NOT NULL,
    contents text NOT NULL,
    date date DEFAULT now() NOT NULL,
    user_id integer
);


-- ALTER TABLE blog.blogpost OWNER TO vanierdb;

--
-- Name: blogpost_blogpost_id_seq; Type: SEQUENCE; Schema: blog; Owner: vanierdb
--

ALTER TABLE blog.blogpost ALTER COLUMN blogpost_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME blog.blogpost_blogpost_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: blogpost_topic; Type: TABLE; Schema: blog; Owner: vanierdb
--

CREATE TABLE blog.blogpost_topic (
    blogpost_id integer NOT NULL,
    topic_id integer NOT NULL
);


-- ALTER TABLE blog.blogpost_topic OWNER TO vanierdb;

--
-- Name: comment; Type: TABLE; Schema: blog; Owner: vanierdb
--

CREATE TABLE blog.comment (
    comment_id integer NOT NULL,
    contents text NOT NULL,
    date date DEFAULT now() NOT NULL,
    blogpost_id integer,
    user_id integer NOT NULL,
    reply_to_id integer,
    CONSTRAINT comment_check CHECK (((blogpost_id IS NOT NULL) OR (reply_to_id IS NOT NULL)))
);


-- ALTER TABLE blog.comment OWNER TO vanierdb;

--
-- Name: comment_comment_id_seq; Type: SEQUENCE; Schema: blog; Owner: vanierdb
--

ALTER TABLE blog.comment ALTER COLUMN comment_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME blog.comment_comment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: topic; Type: TABLE; Schema: blog; Owner: vanierdb
--

CREATE TABLE blog.topic (
    topic_id integer NOT NULL,
    name character varying(32) NOT NULL,
    description text
);


-- ALTER TABLE blog.topic OWNER TO vanierdb;

--
-- Name: topic_topic_id_seq; Type: SEQUENCE; Schema: blog; Owner: vanierdb
--

ALTER TABLE blog.topic ALTER COLUMN topic_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME blog.topic_topic_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: user; Type: TABLE; Schema: blog; Owner: vanierdb
--

CREATE TABLE blog."user" (
    user_id integer NOT NULL,
    nickname character varying(16) NOT NULL,
    email text NOT NULL,
    CONSTRAINT user_email_check CHECK (((length(email) >= 6) AND (email ~~* '%@%.%'::text))),
    CONSTRAINT user_nickname_check CHECK ((length((nickname)::text) >= 3))
);


-- ALTER TABLE blog."user" OWNER TO vanierdb;

--
-- Name: user_user_id_seq; Type: SEQUENCE; Schema: blog; Owner: vanierdb
--

ALTER TABLE blog."user" ALTER COLUMN user_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME blog.user_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Data for Name: blogpost; Type: TABLE DATA; Schema: blog; Owner: vanierdb
--

INSERT INTO blog.blogpost (blogpost_id, title, contents, date, user_id) OVERRIDING SYSTEM VALUE VALUES (1, 'select', 'how to use select statement', '2023-02-14', 1);
INSERT INTO blog.blogpost (blogpost_id, title, contents, date, user_id) OVERRIDING SYSTEM VALUE VALUES (2, 'flask', 'intro to flask', '2023-02-14', 1);


--
-- Data for Name: blogpost_topic; Type: TABLE DATA; Schema: blog; Owner: vanierdb
--

INSERT INTO blog.blogpost_topic (blogpost_id, topic_id) VALUES (1, 1);
INSERT INTO blog.blogpost_topic (blogpost_id, topic_id) VALUES (2, 2);
INSERT INTO blog.blogpost_topic (blogpost_id, topic_id) VALUES (2, 1);


--
-- Data for Name: comment; Type: TABLE DATA; Schema: blog; Owner: vanierdb
--

INSERT INTO blog.comment (comment_id, contents, date, blogpost_id, user_id, reply_to_id) OVERRIDING SYSTEM VALUE VALUES (1, 'nice article', '2023-02-14', 1, 2, NULL);
INSERT INTO blog.comment (comment_id, contents, date, blogpost_id, user_id, reply_to_id) OVERRIDING SYSTEM VALUE VALUES (2, 'thank you', '2023-02-14', 1, 1, 1);
INSERT INTO blog.comment (comment_id, contents, date, blogpost_id, user_id, reply_to_id) OVERRIDING SYSTEM VALUE VALUES (3, 'needs more details', '2023-02-14', 2, 2, NULL);
INSERT INTO blog.comment (comment_id, contents, date, blogpost_id, user_id, reply_to_id) OVERRIDING SYSTEM VALUE VALUES (4, 'you''re welcome', '2023-02-14', 1, 2, 2);
INSERT INTO blog.comment (comment_id, contents, date, blogpost_id, user_id, reply_to_id) OVERRIDING SYSTEM VALUE VALUES (5, 'some other comment', '2023-02-15', 1, 1, NULL);


--
-- Data for Name: topic; Type: TABLE DATA; Schema: blog; Owner: vanierdb
--

INSERT INTO blog.topic (topic_id, name, description) OVERRIDING SYSTEM VALUE VALUES (1, 'DB', 'Database');
INSERT INTO blog.topic (topic_id, name, description) OVERRIDING SYSTEM VALUE VALUES (2, 'Python', 'Python programming');


--
-- Data for Name: user; Type: TABLE DATA; Schema: blog; Owner: vanierdb
--

INSERT INTO blog."user" (user_id, nickname, email) OVERRIDING SYSTEM VALUE VALUES (1, 'denis', 'denis@example.com');
INSERT INTO blog."user" (user_id, nickname, email) OVERRIDING SYSTEM VALUE VALUES (2, 'bob', 'bob@example.com');


--
-- Name: blogpost_blogpost_id_seq; Type: SEQUENCE SET; Schema: blog; Owner: vanierdb
--

SELECT pg_catalog.setval('blog.blogpost_blogpost_id_seq', 2, true);


--
-- Name: comment_comment_id_seq; Type: SEQUENCE SET; Schema: blog; Owner: vanierdb
--

SELECT pg_catalog.setval('blog.comment_comment_id_seq', 5, true);


--
-- Name: topic_topic_id_seq; Type: SEQUENCE SET; Schema: blog; Owner: vanierdb
--

SELECT pg_catalog.setval('blog.topic_topic_id_seq', 2, true);


--
-- Name: user_user_id_seq; Type: SEQUENCE SET; Schema: blog; Owner: vanierdb
--

SELECT pg_catalog.setval('blog.user_user_id_seq', 2, true);


--
-- Name: blogpost blogpost_pkey; Type: CONSTRAINT; Schema: blog; Owner: vanierdb
--

ALTER TABLE ONLY blog.blogpost
    ADD CONSTRAINT blogpost_pkey PRIMARY KEY (blogpost_id);


--
-- Name: blogpost_topic blogpost_topic_pkey; Type: CONSTRAINT; Schema: blog; Owner: vanierdb
--

ALTER TABLE ONLY blog.blogpost_topic
    ADD CONSTRAINT blogpost_topic_pkey PRIMARY KEY (blogpost_id, topic_id);


--
-- Name: comment comment_pkey; Type: CONSTRAINT; Schema: blog; Owner: vanierdb
--

ALTER TABLE ONLY blog.comment
    ADD CONSTRAINT comment_pkey PRIMARY KEY (comment_id);


--
-- Name: topic topic_pkey; Type: CONSTRAINT; Schema: blog; Owner: vanierdb
--

ALTER TABLE ONLY blog.topic
    ADD CONSTRAINT topic_pkey PRIMARY KEY (topic_id);


--
-- Name: user user_email_key; Type: CONSTRAINT; Schema: blog; Owner: vanierdb
--

ALTER TABLE ONLY blog."user"
    ADD CONSTRAINT user_email_key UNIQUE (email);


--
-- Name: user user_nickname_key; Type: CONSTRAINT; Schema: blog; Owner: vanierdb
--

ALTER TABLE ONLY blog."user"
    ADD CONSTRAINT user_nickname_key UNIQUE (nickname);


--
-- Name: user user_pkey; Type: CONSTRAINT; Schema: blog; Owner: vanierdb
--

ALTER TABLE ONLY blog."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (user_id);


--
-- Name: blogpost_topic blogpost_topic_blogpost_id_fkey; Type: FK CONSTRAINT; Schema: blog; Owner: vanierdb
--

ALTER TABLE ONLY blog.blogpost_topic
    ADD CONSTRAINT blogpost_topic_blogpost_id_fkey FOREIGN KEY (blogpost_id) REFERENCES blog.blogpost(blogpost_id);


--
-- Name: blogpost_topic blogpost_topic_topic_id_fkey; Type: FK CONSTRAINT; Schema: blog; Owner: vanierdb
--

ALTER TABLE ONLY blog.blogpost_topic
    ADD CONSTRAINT blogpost_topic_topic_id_fkey FOREIGN KEY (topic_id) REFERENCES blog.topic(topic_id);


--
-- Name: blogpost blogpost_user_id_fkey; Type: FK CONSTRAINT; Schema: blog; Owner: vanierdb
--

ALTER TABLE ONLY blog.blogpost
    ADD CONSTRAINT blogpost_user_id_fkey FOREIGN KEY (user_id) REFERENCES blog."user"(user_id);


--
-- Name: comment comment_blogpost_id_fkey; Type: FK CONSTRAINT; Schema: blog; Owner: vanierdb
--

ALTER TABLE ONLY blog.comment
    ADD CONSTRAINT comment_blogpost_id_fkey FOREIGN KEY (blogpost_id) REFERENCES blog.blogpost(blogpost_id);


--
-- Name: comment comment_reply_to_id_fkey; Type: FK CONSTRAINT; Schema: blog; Owner: vanierdb
--

ALTER TABLE ONLY blog.comment
    ADD CONSTRAINT comment_reply_to_id_fkey FOREIGN KEY (reply_to_id) REFERENCES blog.comment(comment_id);


--
-- Name: comment comment_user_id_fkey; Type: FK CONSTRAINT; Schema: blog; Owner: vanierdb
--

ALTER TABLE ONLY blog.comment
    ADD CONSTRAINT comment_user_id_fkey FOREIGN KEY (user_id) REFERENCES blog."user"(user_id);


--
-- PostgreSQL database dump complete
--

