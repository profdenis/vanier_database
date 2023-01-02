SET search_path TO football;

-- Q1: Find the players who are the captain of a team. List the player names and
--     IDs, and also the team name. List only the players with a name starting with
--     the letter T.
SELECT pid, p.name AS player_name, t.name AS team_name
FROM team t
         INNER JOIN player p ON t.captain_pid = p.pid
WHERE p.name LIKE 'T%';

-- Q2: Find the team names and cities of the teams that have played a match
--     on 2014-07-01.
SELECT t.name, t.city
FROM team t
         INNER JOIN match m ON t.tid = m.home_tid
WHERE date_time >= '2014-07-01' and date_time < '2014-07-02'
UNION
SELECT t.name, t.city
FROM team t
         INNER JOIN match m ON t.tid = m.away_tid
WHERE date_time >= '2014-07-01' and date_time < '2014-07-02';

-- Q3: Find all the draws or ties (matches without a winner). List the date and
--     times, stadium of these matches.
SELECT date_time, stadium
FROM match m
WHERE home_goals = away_goals;

-- Q4: Find the names and IDs of the players who have never scored any goal.
SELECT pid, name
FROM player
WHERE pid NOT IN (SELECT pid
                  FROM playedin
                  WHERE goals > 0);


-- Q5: For each player, find the total number of goals they scored. List the
--     player names and IDs along with the number of goals.
SELECT player.pid, name, CASE WHEN SUM(goals) IS NULL THEN 0 ELSE SUM(goals) END AS n_goals
FROM player
         LEFT JOIN playedin ON player.pid = playedin.pid
GROUP BY player.pid, name;
