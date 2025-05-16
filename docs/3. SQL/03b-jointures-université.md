# 3b - Queries with More Than One Table (University)

```sql
set
search_path to university;
```

## Cartesian Product

1- Associate each row of the first table with each row of the second

```sql
select *
from offering,
     instructor;
```

## Join

2- Like the Cartesian product, but keep only the interesting matching rows

- here, keep only the matching instructor IDs (column `iid`)

```sql
select *
from offering,
     instructor
where offering.iid = instructor.iid;
```

3- More modern way to write the same query: use an `inner join`

```sql
select *
from offering
         inner join instructor on offering.iid = instructor.iid;

select *
from offering as o
         inner join instructor as i on o.iid = i.iid;


select semester, year, section, i.name as instructor_name, c.name as course_name
from offering as o
    inner join instructor as i
on o.iid = i.iid
    inner join course c on c.cid = o.cid;
```

4- (Almost) the same query with a `natural join`

- differences: only one `iid` column, and columns in a different order
- not recommended: the behavior of a natural join can be unpredictable

```sql
select *
from offering
         natural join instructor;

-- doesn't work
select *
from offering
         natural join instructor
         natural join course;
```

5- Get the IDs and names of instructors teaching in the Winter 2020 semester

- we need to specify which of the two `iid` columns we want, even though they are equal

```sql
select instructor.iid, name
from offering
         inner join instructor on offering.iid = instructor.iid
where semester = 'W'
          and year = 2020;
```

6- Use `distinct` to remove duplicates

```sql
select distinct instructor.iid, name
from offering
         inner join instructor on offering.iid = instructor.iid
where semester = 'W'
          and year = 2020;
```

7- Get the codes and names of courses offered in the Winter 2020 semester

```sql
select distinct course.code, course.name
from course
         inner join offering on course.cid = offering.cid
where semester = 'W'
          and year = 2020;
```

8- Get the codes and names of courses offered in the Winter 2020 semester, along with the names of the instructors

- first attempt: why doesn't this work?

```sql
select code, course.name, instructor.name
from offering
         natural join instructor
         natural join course
where semester = 'W'
          and year = 2020;

--- second attempt
select distinct code, course.name, instructor.name
from offering
         inner join instructor on offering.iid = instructor.iid
         inner join course on offering.cid = course.cid
where semester = 'W'
          and year = 2020;
```

9- What about offerings without an instructor?

- The `iid` in offering can be null, but not the `cid`
- if `iid` is null in offering, it won't match anything in instructor
- *outer joins*: keep rows that don't match

```sql
select o.oid, o.iid, i.iid
from offering as o
         inner join instructor as i on o.iid = i.iid;

select o.oid, o.iid, i.iid
from offering o
         left outer join instructor i on o.iid = i.iid;

select o.oid, o.iid, i.iid
from offering o
         right outer join instructor i on o.iid = i.iid;

select o.oid, o.iid, i.iid
from offering o
         full outer join instructor i on o.iid = i.iid;
```

10- Get the course IDs offered in 2020, along with the instructor names

```sql
select distinct cid, instructor.name as instructor_name
from offering
         left join instructor on offering.iid = instructor.iid
where year = 2020;
```

11- Get the codes and names of courses offered in 2020, along with the semester and instructor names

```sql
select distinct code,
                course.name     as course_name,
                semester,
                instructor.name as instructor_name
from (offering left join instructor on offering.iid = instructor.iid)
         right join course on offering.cid = course.cid
where year = 2020;
```

12- Find offerings without an instructor

```sql
select *
from offering
where iid is null;
```

13- Find students not enrolled in any course

```sql
select s.*
from student s
         left join enrollment e on s.sid = e.sid
where oid is null;
```

14- Find courses that have never been offered

```sql
select c.*
from course c
         left join offering o on c.cid = o.cid
where oid is null;
```

15- Find offerings in which no student is enrolled

```sql
select o.*
from offering o
         left join enrollment e on o.oid = e.oid
where e.oid is null;
```

