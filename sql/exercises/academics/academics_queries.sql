set search_path to academics;

-- 1.	Find the family and given names of academics who are interested in the field number 292.
SELECT famname, givename
FROM academic
         natural join interest
WHERE fieldnum = 292;

-- 2.	Find the paper number and title of papers containing the word “database” in their title.
SELECT panum, title
FROM paper
WHERE title LIKE '%database%';

-- 3.	Find the family and given names of academics who have authored at least one paper with the word “database” in the paper’s title.
SELECT DISTINCT ac.acnum, famname, givename
FROM academic ac
         inner join author au on ac.acnum = au.acnum
         inner join paper p on p.panum = au.panum
WHERE p.title LIKE '%database%';

-- 4.	Find the family and given names of academics who have not authored any paper.
-- first solution
SELECT famname, givename
FROM academic
WHERE acnum NOT IN (SELECT acnum FROM author);

-- second solution
SELECT ac.acnum, au.acnum
FROM academic ac
         LEFT JOIN author au
                   ON ac.acnum = au.acnum
WHERE au.acnum IS NULL;

-- 5.	Find the family and given names of academics who are working for RMIT who have not authored any paper.
SELECT famname, givename
FROM academic
         natural join department
WHERE instname = 'Royal Melbourne Institute of Technology'
  and acnum NOT IN (SELECT acnum FROM author);

-- 6.	Find the academic number of academics who have an interest in databases (you should look for the word “database” in both the Interest and Field tables).
SELECT DISTINCT acnum
FROM interest
         NATURAL JOIN field
WHERE title LIKE '%database%'
   OR descrip LIKE '%database%';

-- 7.	Find how many academics are interested in the field number 292.
SELECT count(acnum)
FROM interest
WHERE fieldnum = 292;

-- 8.	Find how many academics are interested in each field, and order the results by the most popular fields first. The most popular field is the field with the largest number of academics interested in it. There could be many fields equal for the first place.
SELECT fieldnum, count(acnum)
FROM interest
GROUP BY fieldnum
ORDER BY 2 DESC;


