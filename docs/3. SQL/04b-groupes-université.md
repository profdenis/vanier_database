# 4b - Grouping and Aggregates (University)

```sql
set
search_path to university;
```

1- Find the number of course offerings for each year

```sql
select year, count (oid)
from offering
group by year;
```

2- Same result because `oid` cannot be null

```sql
select year, count (*)
from offering
group by year;
```

3- Similar, but different results because of null values

```sql
select year, count (iid)
from offering
group by year;
```

4- Find the number of course offerings for each instructor

```sql
select iid, count(*)
from offering
group by iid;
   ```

5- Get the number of students enrolled in each course offering

```sql
select oid, count(sid)
from enrollment
group by oid;
```

6- Get the number of students enrolled in each course offering

- with course codes, names, and sections

```sql
select e.oid, code, name, section, count (sid) as n_students
from enrollment e
    inner join offering o
on e.oid = o.oid
    inner join course c on o.cid = c.cid
group by e.oid, code, name, section;
```

7- What about offerings without enrollments?

```sql
select o.oid, code, name, section, count (sid) as n_students
from enrollment e
    right join offering o
on e.oid = o.oid
    inner join course c on o.cid = c.cid
group by o.oid, code, name, section
order by n_students desc;
```

8- Get the number of students enrolled in each course offering

- with course codes, names, and sections, but only for course offerings with fewer than 3 enrollments

```sql
select o.oid, code, name, section, count (sid) as n_students
from enrollment e
    right join offering o
on e.oid = o.oid
    inner join course c on o.cid = c.cid
group by o.oid, code, name, section
having count (sid) < 3;
```

9- Same thing, but with fewer than one enrollment

```sql
select o.oid, code, name, section, count (sid) as n_students
from enrollment e
    right join offering o
on e.oid = o.oid
    inner join course c on o.cid = c.cid
group by o.oid, code, name, section
having count (sid) < 1;
```

```sql
-- better answer
select o.oid, code, name, section
from enrollment e
    right join offering o
on e.oid = o.oid
    inner join course c on o.cid = c.cid
where e.oid is null;
```

## Exercises

1. Get the number of course offerings for each instructor
2. Get the number of course offerings for the instructor with ID 1, for each year
3. Get the number of course offerings for each instructor for each year
    - what about instructors without any course offerings?
4. Get the number of course offerings for each instructor for each semester and each year
    - what about semesters without any course offerings?
    - what about semesters without course offerings for certain instructors?
        - for example, many instructors teach only in fall and winter semesters, but not in summer semesters; should we
          list these semesters without courses for each instructor with a count of 0?

