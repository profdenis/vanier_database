--
-- PostgreSQL database dump
--

-- Dumped from database version 9.3.2
-- Dumped by pg_dump version 9.3.2
-- Started on 2014-12-09 13:26:28 ICT

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 7 (class 2615 OID 47465)
-- Name: football; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA football;


-- ALTER SCHEMA football OWNER TO postgres;

SET search_path = football, pg_catalog;

SET default_with_oids = false;

--
-- TOC entry 176 (class 1259 OID 47500)
-- Name: match; Type: TABLE; Schema: football; Owner: postgres
--

CREATE TABLE match (
    mid integer NOT NULL,
    date_time timestamp without time zone NOT NULL,
    stadium text,
    home_tid integer NOT NULL,
    home_goals integer,
    away_tid integer NOT NULL,
    away_goals integer
);


-- ALTER TABLE football.match OWNER TO postgres;

--
-- TOC entry 175 (class 1259 OID 47498)
-- Name: match_mid_seq; Type: SEQUENCE; Schema: football; Owner: postgres
--

CREATE SEQUENCE match_mid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


-- ALTER TABLE football.match_mid_seq OWNER TO postgres;

--
-- TOC entry 2034 (class 0 OID 0)
-- Dependencies: 175
-- Name: match_mid_seq; Type: SEQUENCE OWNED BY; Schema: football; Owner: postgres
--

ALTER SEQUENCE match_mid_seq OWNED BY match.mid;


--
-- TOC entry 178 (class 1259 OID 47534)
-- Name: playedin; Type: TABLE; Schema: football; Owner: postgres
--

CREATE TABLE playedin (
    tid integer NOT NULL,
    pid integer NOT NULL,
    mid integer NOT NULL,
    goals integer,
    minutes integer
);


-- ALTER TABLE football.playedin OWNER TO postgres;

--
-- TOC entry 174 (class 1259 OID 47479)
-- Name: player; Type: TABLE; Schema: football; Owner: postgres
--

CREATE TABLE player (
    pid integer NOT NULL,
    name text NOT NULL,
    "position" text,
    dob date,
    current_tid integer,
    start_date date
);


-- ALTER TABLE football.player OWNER TO postgres;

--
-- TOC entry 173 (class 1259 OID 47477)
-- Name: player_pid_seq; Type: SEQUENCE; Schema: football; Owner: postgres
--

CREATE SEQUENCE player_pid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


-- ALTER TABLE football.player_pid_seq OWNER TO postgres;

--
-- TOC entry 2035 (class 0 OID 0)
-- Dependencies: 173
-- Name: player_pid_seq; Type: SEQUENCE OWNED BY; Schema: football; Owner: postgres
--

ALTER SEQUENCE player_pid_seq OWNED BY player.pid;


--
-- TOC entry 177 (class 1259 OID 47519)
-- Name: previousteams; Type: TABLE; Schema: football; Owner: postgres
--

CREATE TABLE previousteams (
    tid integer NOT NULL,
    pid integer NOT NULL,
    start_date date NOT NULL,
    end_date date
);


-- ALTER TABLE football.previousteams OWNER TO postgres;

--
-- TOC entry 172 (class 1259 OID 47468)
-- Name: team; Type: TABLE; Schema: football; Owner: postgres
--

CREATE TABLE team (
    tid integer NOT NULL,
    name text NOT NULL,
    city text,
    captain_pid integer
);


-- ALTER TABLE football.team OWNER TO postgres;

--
-- TOC entry 171 (class 1259 OID 47466)
-- Name: team_tid_seq; Type: SEQUENCE; Schema: football; Owner: postgres
--

CREATE SEQUENCE team_tid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


-- ALTER TABLE football.team_tid_seq OWNER TO postgres;

--
-- TOC entry 2036 (class 0 OID 0)
-- Dependencies: 171
-- Name: team_tid_seq; Type: SEQUENCE OWNED BY; Schema: football; Owner: postgres
--

ALTER SEQUENCE team_tid_seq OWNED BY team.tid;


--
-- TOC entry 1895 (class 2604 OID 47503)
-- Name: mid; Type: DEFAULT; Schema: football; Owner: postgres
--

ALTER TABLE ONLY match ALTER COLUMN mid SET DEFAULT nextval('match_mid_seq'::regclass);


--
-- TOC entry 1894 (class 2604 OID 47482)
-- Name: pid; Type: DEFAULT; Schema: football; Owner: postgres
--

ALTER TABLE ONLY player ALTER COLUMN pid SET DEFAULT nextval('player_pid_seq'::regclass);


--
-- TOC entry 1893 (class 2604 OID 47471)
-- Name: tid; Type: DEFAULT; Schema: football; Owner: postgres
--

ALTER TABLE ONLY team ALTER COLUMN tid SET DEFAULT nextval('team_tid_seq'::regclass);


--
-- TOC entry 2027 (class 0 OID 47500)
-- Dependencies: 176
-- Data for Name: match; Type: TABLE DATA; Schema: football; Owner: postgres
--

INSERT INTO match VALUES (7, '2014-08-11 13:00:00', 'Downtown', 4, 3, 1, 0);
INSERT INTO match VALUES (5, '2014-07-01 19:00:00', 'RMIT', 1, 2, 2, 2);
INSERT INTO match VALUES (1, '2013-05-05 20:00:00', 'RMIT', 1, 4, 3, 2);
INSERT INTO match VALUES (4, '2013-06-17 18:00:00', 'Olympic', 2, 1, 3, 3);


--
-- TOC entry 2037 (class 0 OID 0)
-- Dependencies: 175
-- Name: match_mid_seq; Type: SEQUENCE SET; Schema: football; Owner: postgres
--

SELECT pg_catalog.setval('match_mid_seq', 7, true);


--
-- TOC entry 2029 (class 0 OID 47534)
-- Dependencies: 178
-- Data for Name: playedin; Type: TABLE DATA; Schema: football; Owner: postgres
--

INSERT INTO playedin VALUES (1, 1, 1, 0, 90);
INSERT INTO playedin VALUES (3, 6, 1, 1, 85);
INSERT INTO playedin VALUES (2, 4, 4, 1, 77);
INSERT INTO playedin VALUES (1, 3, 1, 4, 90);
INSERT INTO playedin VALUES (3, 6, 4, 2, 90);


--
-- TOC entry 2025 (class 0 OID 47479)
-- Dependencies: 174
-- Data for Name: player; Type: TABLE DATA; Schema: football; Owner: postgres
--

INSERT INTO player VALUES (1, 'John', 'goal keeper', '1990-01-01', 1, '2010-01-10');
INSERT INTO player VALUES (2, 'Jack', 'goal keeper', '1988-06-09', 2, '2011-04-10');
INSERT INTO player VALUES (3, 'Jim', 'defender', '1977-05-02', 1, '2014-02-13');
INSERT INTO player VALUES (4, 'Jay', 'defender', '1992-02-02', 2, '2013-07-19');
INSERT INTO player VALUES (5, 'Tim', 'attacker', '1990-02-08', 1, '2012-01-11');
INSERT INTO player VALUES (6, 'Tom', 'attacker', '1985-08-01', 3, '2011-04-18');
INSERT INTO player VALUES (7, 'Bao', 'defender', '1970-02-06', 3, '2008-02-13');
INSERT INTO player VALUES (8, 'Tri', 'goal keeper', '1987-09-22', 4, '2009-08-21');


--
-- TOC entry 2038 (class 0 OID 0)
-- Dependencies: 173
-- Name: player_pid_seq; Type: SEQUENCE SET; Schema: football; Owner: postgres
--

SELECT pg_catalog.setval('player_pid_seq', 8, true);


--
-- TOC entry 2028 (class 0 OID 47519)
-- Dependencies: 177
-- Data for Name: previousteams; Type: TABLE DATA; Schema: football; Owner: postgres
--

INSERT INTO previousteams VALUES (1, 2, '2007-01-01', '2008-07-09');
INSERT INTO previousteams VALUES (1, 6, '2009-07-05', '2010-04-15');
INSERT INTO previousteams VALUES (3, 8, '2007-04-02', '2009-05-11');
INSERT INTO previousteams VALUES (3, 5, '2010-01-01', '2011-01-01');
INSERT INTO previousteams VALUES (3, 3, '2004-02-08', '2006-11-08');
INSERT INTO previousteams VALUES (2, 3, '2008-08-09', '2009-05-28');


--
-- TOC entry 2023 (class 0 OID 47468)
-- Dependencies: 172
-- Data for Name: team; Type: TABLE DATA; Schema: football; Owner: postgres
--

INSERT INTO team VALUES (1, 'Tigers', 'HCMC', 3);
INSERT INTO team VALUES (2, 'Lions', 'Hanoi', 2);
INSERT INTO team VALUES (3, 'Snakes', 'Danang', 6);
INSERT INTO team VALUES (4, 'Ants', 'Dalat', 8);


--
-- TOC entry 2039 (class 0 OID 0)
-- Dependencies: 171
-- Name: team_tid_seq; Type: SEQUENCE SET; Schema: football; Owner: postgres
--

SELECT pg_catalog.setval('team_tid_seq', 4, true);


--
-- TOC entry 1901 (class 2606 OID 47508)
-- Name: match_pkey; Type: CONSTRAINT; Schema: football; Owner: postgres
--

ALTER TABLE ONLY match
    ADD CONSTRAINT match_pkey PRIMARY KEY (mid);


--
-- TOC entry 1905 (class 2606 OID 47538)
-- Name: playedin_pkey; Type: CONSTRAINT; Schema: football; Owner: postgres
--

ALTER TABLE ONLY playedin
    ADD CONSTRAINT playedin_pkey PRIMARY KEY (tid, pid, mid);


--
-- TOC entry 1899 (class 2606 OID 47487)
-- Name: player_pkey; Type: CONSTRAINT; Schema: football; Owner: postgres
--

ALTER TABLE ONLY player
    ADD CONSTRAINT player_pkey PRIMARY KEY (pid);


--
-- TOC entry 1903 (class 2606 OID 47523)
-- Name: previousteams_pkey; Type: CONSTRAINT; Schema: football; Owner: postgres
--

ALTER TABLE ONLY previousteams
    ADD CONSTRAINT previousteams_pkey PRIMARY KEY (tid, pid, start_date);


--
-- TOC entry 1897 (class 2606 OID 47476)
-- Name: team_pkey; Type: CONSTRAINT; Schema: football; Owner: postgres
--

ALTER TABLE ONLY team
    ADD CONSTRAINT team_pkey PRIMARY KEY (tid);


--
-- TOC entry 1909 (class 2606 OID 47514)
-- Name: match_away_tid_fkey; Type: FK CONSTRAINT; Schema: football; Owner: postgres
--

ALTER TABLE ONLY match
    ADD CONSTRAINT match_away_tid_fkey FOREIGN KEY (away_tid) REFERENCES team(tid);


--
-- TOC entry 1908 (class 2606 OID 47509)
-- Name: match_home_tid_fkey; Type: FK CONSTRAINT; Schema: football; Owner: postgres
--

ALTER TABLE ONLY match
    ADD CONSTRAINT match_home_tid_fkey FOREIGN KEY (home_tid) REFERENCES team(tid);


--
-- TOC entry 1914 (class 2606 OID 47549)
-- Name: playedin_mid_fkey; Type: FK CONSTRAINT; Schema: football; Owner: postgres
--

ALTER TABLE ONLY playedin
    ADD CONSTRAINT playedin_mid_fkey FOREIGN KEY (mid) REFERENCES match(mid);


--
-- TOC entry 1913 (class 2606 OID 47544)
-- Name: playedin_pid_fkey; Type: FK CONSTRAINT; Schema: football; Owner: postgres
--

ALTER TABLE ONLY playedin
    ADD CONSTRAINT playedin_pid_fkey FOREIGN KEY (pid) REFERENCES player(pid);


--
-- TOC entry 1912 (class 2606 OID 47539)
-- Name: playedin_tid_fkey; Type: FK CONSTRAINT; Schema: football; Owner: postgres
--

ALTER TABLE ONLY playedin
    ADD CONSTRAINT playedin_tid_fkey FOREIGN KEY (tid) REFERENCES team(tid);


--
-- TOC entry 1907 (class 2606 OID 47488)
-- Name: player_current_tid_fkey; Type: FK CONSTRAINT; Schema: football; Owner: postgres
--

ALTER TABLE ONLY player
    ADD CONSTRAINT player_current_tid_fkey FOREIGN KEY (current_tid) REFERENCES team(tid);


--
-- TOC entry 1911 (class 2606 OID 47529)
-- Name: previousteams_pid_fkey; Type: FK CONSTRAINT; Schema: football; Owner: postgres
--

ALTER TABLE ONLY previousteams
    ADD CONSTRAINT previousteams_pid_fkey FOREIGN KEY (pid) REFERENCES player(pid);


--
-- TOC entry 1910 (class 2606 OID 47524)
-- Name: previousteams_tid_fkey; Type: FK CONSTRAINT; Schema: football; Owner: postgres
--

ALTER TABLE ONLY previousteams
    ADD CONSTRAINT previousteams_tid_fkey FOREIGN KEY (tid) REFERENCES team(tid);


--
-- TOC entry 1906 (class 2606 OID 47493)
-- Name: team_captain_pid_fkey; Type: FK CONSTRAINT; Schema: football; Owner: postgres
--

ALTER TABLE ONLY team
    ADD CONSTRAINT team_captain_pid_fkey FOREIGN KEY (captain_pid) REFERENCES player(pid);


-- Completed on 2014-12-09 13:26:28 ICT

--
-- PostgreSQL database dump complete
--

