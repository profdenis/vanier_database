# 6 - Nested SQL Queries

- A *subquery* is a query inside another query (or inside another subquery).
- We can have multiple levels of subqueries.
- Sometimes we refer to subqueries as *inner* queries and to the enclosing queries as *outer* queries.

## University Database

```sql
set
search_path to university;
```

### Uncorrelated Subqueries

- Also called ***simple*** subqueries.
- *Correlated* subqueries will be covered later.
- Uncorrelated subqueries are independent of their outer (enclosing) queries.
- They can execute on their own.
- They don't depend on something defined in the outer queries.

#### Examples: with 2 uncorrelated subqueries

1- Find students and instructors with an email address `@example.com`

```sql
select name, email
from student
where email like '%@example.com'
union
select name, email
from instructor
where email like '%@example.com';
```

2- Check if there are students and instructors with the same email address

```sql
select email
from student
intersect
select email
from instructor;
```

3- Find courses that have never been offered

```sql
select cid
from course
except
select cid
from offering;

select c.cid
from course c
         left join offering o on c.cid = o.cid
where o.oid is null;
```

4- Find students not enrolled in any course

```sql
select sid
from student
except
select sid
from enrollment;
```

5- Find course offerings in which no student is enrolled

```sql
select oid
from offering
except
select oid
from enrollment;
```

### Scalar Subqueries

- Scalar subqueries are the simplest type of subqueries.
- They always return exactly 1 row containing exactly 1 column.
- They are often (but not always) obtained by calculating an aggregate function.

#### Examples

1- Find the number of students with an email address `@example.com`

```sql
select count(sid) as n_students
from student
where email like '%@example.com';
```

2- Find courses that have been offered more often than the `DB` course

a) Find the number of times `DB` has been offered

```sql
select count(o.cid)
from course c
         left join offering o on c.cid = o.cid
where c.code = 'DB';
```

b) Insert the previous result into the `HAVING` clause of a query calculating the number of times each course has been
offered. It might be better to start with a fixed number (e.g., 3) instead of immediately inserting the first query into
the second

```sql
select c.cid, c.code
from course c
         left join offering o on c.cid = o.cid
group by c.cid, c.code
having count(o.oid) > 3;
```

```sql
select c.cid, c.code
from course c
         left join offering o on c.cid = o.cid
group by c.cid, c.code
having count(o.oid) > (select count(o.cid)
                       from course c
                                left join offering o on c.cid = o.cid
                       where c.code = 'DB');
```

3- Find the average number of times each course has been offered. Start by finding the number of times each course has
been offered, then take the average

```sql
select c.cid, c.code, count(o.oid) as n_offerings
from course c
         left join offering o on c.cid = o.cid
group by c.cid;
```

```sql
-- won't work
select c.cid, c.code, avg(count(o.oid)) as n_offerings
from course c
         left join offering o on c.cid = o.cid
group by c.cid;
```

```sql
select round(avg(n_offerings), 2) as avg_n_offerings
from (select count(o.oid) as n_offerings
      from course c
               left join offering o on c.cid = o.cid
      group by c.cid) as T;

with T as (select count(o.oid) as n_offerings
           from course c
                    left join offering o on c.cid = o.cid
           group by c.cid)
select round(avg(n_offerings), 2) as avg_n_offerings
from T;
```

4- Find courses that have been offered more often than the average (number of times each course has been offered)

```sql
select c.cid, c.code
from course c
         left join offering o on c.cid = o.cid
group by c.cid
having count(o.oid) > (select avg(n_offerings) as avg_n_offerings
                       from (select count(o.oid) as n_offerings
                             from course c
                                      left join offering o on c.cid = o.cid
                             group by c.cid) as T);
```

### `with` Query Format

- In order to more easily express queries with multiple levels of subqueries, we can use the `with ... select ...` query
  style.
- We define (sort of) temporary tables before the main `select` query begins.
- Then we use the temporary tables in the main `select` query as if they were tables stored in the database.

```sql
with T2 as (select avg(n_offerings) as avg_n_offerings
            from (select c.cid, c.code, count(o.oid) as n_offerings
                  from course c
                           left join offering o on c.cid = o.cid
                  group by c.cid) as T1)
select c.cid, c.code
from course c
         left join offering o on c.cid = o.cid
group by c.cid
having count(o.oid) > (select * from T2);

with n_offerings_per_course as (select c.cid,
                                       c.code,
                                       count(o.oid) as n_offerings
                                from course c
                                         left join offering o on c.cid = o.cid
                                group by c.cid)
select cid, code
from n_offerings_per_course
where n_offerings > (select avg(n_offerings) as avg_n_offerings
                     from n_offerings_per_course);
```

- Don't *over-use* the `with` syntax
- For example, don't rewrite this query

```sql
select name, email
from student
where email like '%@example.com'
union
select name, email
from instructor
where email like '%@example.com';
```

as

```sql
with students_example as (select name, email from student where email like '%@example.com'),
     instructor_example as (select name, email from instructor where email like '%@example.com')
select *
from students_example
union
select *
from instructor_example;
```

- Although this query is technically correct and equivalent to the original query, using `with` to define 2 temporary
  tables is excessive here and actually reduces readability.
- Use `with` only when the subqueries are complicated or when there are multiple levels of subqueries.
- We can also use `with recursive` to write recursive queries.

### `NULL` Values in SQL

- SQL uses a *3-valued logic* instead of Boolean logic (a 2-valued logic).
- The 3 values are `true`, `false`, and `null` (or `T`, `F`, and `N` in the table below).
- The first 2 values have the usual meaning, while `null` can have different meanings:
    - *unknown*
    - *not applicable*
    - *doesn't matter*
- Logical operators need to be updated to account for `null` values.

| A | B | NOT A | A OR B | A AND B |
|---|---|-------|--------|---------|
| T | T | F     | T      | T       |
| T | F | F     | T      | F       |
| T | N | F     | T      | N       |
| F | T | T     | T      | F       |
| F | F | T     | F      | F       |
| F | N | T     | N      | F       |
| N | T | N     | T      | N       |
| N | F | N     | N      | F       |
| N | N | N     | N      | N       |

### Non-Scalar Subqueries

- If a (sub)query returns more than one row and/or more than one column, then it is **not** a scalar subquery.
- Attempting to use normal comparison or arithmetic operators with non-scalar subqueries will fail if there is more than
  one row.
- Some DBMSs, like PostgreSQL, allow some operators to work with subqueries giving exactly 1 row but multiple columns.
- PostgreSQL is an ORDBMS, so it's more flexible with data types.
- It will see the single row with multiple columns as a single object with multiple fields.
- In general, we need to use special operators to deal with non-scalar subqueries:
    - `IN`, `NOT IN`, `EXISTS`, `NOT EXISTS`, `ANY`, `ALL`

#### `IN`

- `expression IN (sub-query)`
    - it's the same as $\in$ in mathematical notation (except that we need to handle `null` values)
    - the subquery must return exactly 1 column
    - `true` if the expression is equal to 1 of the rows in the subquery results
    - `false` if the expression is not `null` and there are no `null` values in the subquery and the expression is not
      equal to any row in the subquery
    - `null` if the expression is `null` or if the expression is not equal to any row in the subquery and there is at
      least 1 `null` value in the subquery
- Because SQL uses 3-valued logic, evaluating `IN` is more complicated

- Remember that if we want to know if a column value is `null`, we cannot use the equality operator `=` as it will
  always return `null`
    - `null` means *unknown* in this case, so we don't know how to compare values to an unknown value
    - So we need to use `is null` instead of `= null`
- The `IN` operator compares values with `=`, so as soon as it compares with a `null`, it will evaluate to `null`
    - So if the expression is equal to `null`, `IN` will evaluate to `null`
    - If the expression is not `null`, then it will compare the expression with non-null values first in the subquery
        - if it finds a match, then the value of `IN` will be true
        - if we don't find a match, then it will check if the subquery contains `null` values
            - if not, then we know with certainty that the expression is not in the subquery, so the value of `IN` will
              be `false`
            - if there are `null` values, then we don't know with certainty if the expression is in the subquery because
              we have *unknown* values (`null`), so the value of `IN` is `null`

- This example works as expected

```sql
-- note that (1, 2, 3) is not really a subquery, but acts like a subquery
-- it is used to simplify the example
select *
from course
where cid in (1, 2, 3);
```

```sql
-- note that (2, 3, 4, null) is not really a subquery, but acts like a subquery
-- it is used to simplify the example
select *
from course
where cid in (2, 3, 4, null);
```

- This example is equivalent and shows how `IN` operators are evaluated internally

```sql
select *
from course
where cid = 2
   or cid = 3
   or cid = 4
   or cid = null;
```

- This works for courses with a `cid` value of 2, 3, or 4 because at least 1 of the comparisons will be true and we'll
  get something like `T OR F OR F OR N`, which is true
- But for courses with a `cid` not included in the provided set, we'll get `null` because `F OR F OR F OR N` is `N`
- This doesn't create a problem because rows with a `where` condition will be dropped
- But if we negate `IN` to get a `NOT IN` operator, we'll be in trouble

```sql
select *
from course
where cid not in (2, 3, 4, null);

select *
from course
where cid not in (select cid from offering);

select *
from course
except
select c.*
from course c
         inner join offering o on c.cid = o.cid;

select c.*
from course c
         left join offering o on c.cid = o.cid
where o.oid is null;

select *
from instructor
where iid not in (select iid from offering);
```

- We get nothing
- But the course with `cid = 1` is not in the subquery, so why don't we get it?
- It's because of the `null` value
    - `1 in (2, 3, 4, null)` evaluates to `null`
    - and `1 not in (2, 3, 4, null)` evaluates to `not null`, which is `null`
- So `NOT IN` queries are dangerous because of `null` values
- The following query is correct because we know with certainty that `cid` in course cannot be `null`
    - So we can find courses that have never been offered this way

```sql
--insert into course(name, code, credits)
--values ('Data Structures', 'DS', 3);
-- delete from course where code = 'DS';
select *
from course
where cid not in (select cid from offering);
```

- But trying to do something similar for instructors will create problems because `iid` in offering can be `null`
- We need to explicitly exclude `null` values in the subquery for the query to return the correct results

```sql
--insert into instructor(name, email, department)
--values ('John', 'john@bbb.com', 'ECE');
-- delete from instructor where name = 'John';
select *
from instructor
where iid not in (select iid from offering);
```

```sql
select *
from instructor
where iid not in (select iid
                  from offering
                  where iid is not null);
```

#### Recommendation: don't use `NOT IN`

#### Recommendation: use a `left join` instead

- Not only does the left join (or outer joins in general) force you to think about `null` values (and handle them
  correctly), but in terms of performance, left joins will generally be more efficient.
- Using left joins avoids dealing with SQL's 3-valued logic.

```sql
select i.*
from instructor i
         left join offering o on i.iid = o.iid
where o.iid is null;
```

#### `ANY` and `ALL`

- `ANY` and `ALL` are used as operator modifiers (usually comparison operators)
    - `expression operator ANY (sub-query)`
        - `true` when there exists a row $r$ in the subquery such that `expression operator r` is true
        - `false` when for all rows r in the subquery, `expression operator r` is false and there are no `null` values
          in the subquery
        - `null` when for all rows r in the subquery, `expression operator r` is false and there is at least 1 `null`
          value in the subquery
    - `IN` is equivalent to `=ANY`
    - `expression operator ALL (sub-query)`
        - `true` when for all rows $r$ in the subquery, `expression operator r` is true
        - `false` when `expression operator r` is false for at least 1 row in the subquery
        - `null` when for all rows $r$ in the subquery, `expression operator r` is not false and there is at least 1
          `null` value in the subquery
    - `NOT IN` is equivalent to `<> ALL`

