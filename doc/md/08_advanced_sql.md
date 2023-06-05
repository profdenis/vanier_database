# Advanced SQL

## Recursive queries

### PostgreSQL syntax

- Basic syntax (https://www.postgresqltutorial.com/postgresql-recursive-query/):

```
WITH RECURSIVE cte_name AS(
    CTE_query_definition -- non-recursive term
    UNION [ALL]
    CTE_query definion  -- recursive term
) SELECT * FROM cte_name;
```

- CTE: *common table expression*
- Since recursive queries are (of course) recursive, we need a *base case*,
  called a *non-recursive term* here
- Then we need 1 or more recursive terms
- `with recursive` works, at the beginning, a bit like the `with` queries (
  without `recursive`)
- It will evaluate the non-recursive term first, to initialise the result set
- Then it will start evaluating the recursive term multiple times, in a loop,
  until no new rows are added to the results
    - each time it evaluates the recursive term, it will try to add new rows to
      the result set
    - the recursive term is correlated to the `cte_name`

### Example on the blogpost DB

![Blogpost DB](../images/blogpost.png)

- We want to find all the replies to a given comment recursively
    - we don't want only the direct replies, but also all the replies of the
      replies
- First attempt to retrieve only the direct replies:

```postgresql
set search_path to blog3;
select comment_id, contents, reply_to_id, user_id
from comment
where blogpost_id = 1 and reply_to_id is null;
```

- To get the replies to the replies, we need to use the `with recurrsive` syntax
  described above

```postgresql
with recursive replies as (select comment_id, contents, reply_to_id, user_id
                           from comment
                           where reply_to_id = 1
                           union
                           select comment.comment_id,
                                  comment.contents,
                                  comment.reply_to_id,
                                  comment.user_id
                           from comment
                                    inner join replies
                                               on replies.comment_id = comment.reply_to_id)
select *
from replies;
```

- If we need to include the original comment we are starting with in the result,
  we need a slightly different
  non-recursive term
    - use `comment_id = 1` instead of `reply_to_id = 1`
-
    - If we need to include the comments starting with a blog post, we need a
      slightly different non-recursive term
        - use `blogpost_id = 1` instead of `reply_to_id = 1`

```postgresql
with recursive replies as (select comment_id, contents, reply_to_id, user_id
                           from comment
                           where blogpost_id = 1
                           union
                           select comment.comment_id,
                                  comment.contents,
                                  comment.reply_to_id,
                                  comment.user_id
                           from comment
                                    inner join replies
                                               on replies.comment_id = comment.reply_to_id)
select *
from replies;
```

## Views

- Views are basically virtual tables
- They are a layer on top of other tables
- Along with access control, they can be used to ensure different levels of
  privacy and security
- For example, the human resources department usually needs to know about their
  employees' social insurance numbers (
  SINs)
    - to report to the different governments for income taxes, etc...
- But the IT services (except maybe the top-level DBAs), marketing, etc...
  departments should not have access to SINs
- Access to the base employee table, with SINs, can be granted to some
  employees (or to some roles if using role-based
  access control)
- A view on top of the employee table can be created without the SINs, and
  access to other employees can be granted on
  the view

```sql
drop schema if exists company cascade;
create schema company;
set search_path to company;

create table employee_priv
(
    eid   integer generated always as identity primary key,
    sin   CHAR(9) not null unique,
    name  text    not null,
    phone text
);


insert into employee_priv(sin, name, phone)
values ('123456789', 'Denis', '123-456-7890'),
       ('987654321', 'Jane', '987-654-3210');
select *
from employee_priv;
```

```sql
create or replace view employee AS
select eid, name, phone
from employee_priv;

select *
from employee;
```

```sql
--drop role hr;
--drop role itsupport;
create role hr;
create role itsupport;
grant select, insert, update, delete on employee_priv to hr;
grant select on employee to itsupport;
```

- Creating users and roles are not completely standard across all relational
  DBMSs
- Every DBMS should have the grant and revoke SQL commands
- [PostgreSQL - create user](https://www.postgresql.org/docs/current/sql-createuser.html)
- [PostgreSQL - alter user](https://www.postgresql.org/docs/current/sql-alteruser.html)
- [PostgreSQL - grant](https://www.postgresql.org/docs/current/sql-grant.html)

- Views can be created on commonly used queries, often including joins, to
  simplify writing other queries

```sql

set search_path to university;
create or replace view studentcourse as
select s.sid,
       s.name as student_name,
       c.code,
       c.name as course_name,
       o.semester,
       o.year
from student s
         left join enrollment e on s.sid = e.sid
         inner join offering o on e.oid = o.oid
         inner join course c on o.cid = c.cid;

select *
from studentcourse;
```

- We can restrict the view rows to a specific student, for a specific semester
  and year
    - could be useful when creating schedules

```sql
select *
from studentcourse
where sid = 3
  and semester = 'W'
  and year = 2020;
```

### Logical Data Independence

- Views can also be used to minimize the impact of schema changes in the
  database
- Suppose a table schema needs to be modified, possibly because a table needs to
  be decomposed to reduce redundancy
  because of a previously unknown functional dependency
- Then all queries using this table must be updated, which might be difficult to
  do
- A view with the same name and columns can be created to replace the old table
    - this view would be defined on the new tables replacing the old table

### Are Views Updatable?

- The best answer is *maybe, but probably not* (at least not in general)
- If we want to update an employee's phone number, then we probably could do it
  through the view, since the view has a
  direct mapping to exactly 1 table, minus the SIN column
    - the update can be redirected to the `employee_priv` table
- But we cannot insert a new row in the employee view because
  the `employee_priv` table has the SIN column, which cannot
  be `null`
    - also, since it has the `unique` constraint, we cannot set it to a default
      value
        - actually, we could set it to a default value for at most 1 employee

- Similarly, trying to update the `studentcourse` view could be complicated
  because it comes from the join of 4 tables
    - updating 1 row in `studentcourse` could mean we need to modify multiples
      rows in 1 or many tables underneath
        - if we try to change a student's enrollment in a course offering
          through the view, then we will need to update
          the enrollment table, which doesn't show up directly in the view (its
          columns are not selected by the view
          query)
    - same kind of problem for inserting rows
    - it might be possible to do in some cases, but there's no universal way to
      do it
- There are similar issues with deleting rows through a view
    - it is possible in some cases, but not all

## Constraints

- Constraints can be defined in `create table` statements
- Or added to existing tables with `alter table` statements
- Different types of constraints
    - Null or not null
    - Primary key
    - Unique
    - Foreign key
    - Check
    - Domain
    - Assertion

### `null` or `not null` Constraints

- A column can allow `null` values
- Or disallow them with `not null`
- Default: allow `null` values

### Primary Key Constraints

- A column or group of columns can be designated as the `primary key`
- Primary key columns cannot be `null`
    - implicit `not null` for each primary key column
- We can use a column constraint if the primary key has only 1 column
    - `sid integer primary key`
- If the primary key has more than 1 column, we must use a table constraint
    - specified after all columns in the `create table` statement
    - `primary key(eid, sid)`

### Unique Constraints

- Like primary keys, but for candidate (secondary) keys
- Defined in the same way, but with `unique` instead of `primary key`
- *Example*:
    - adding a `unique` constraint to the `code` column of the `course` table

```sql
set search_path to university;
-- alter table course drop constraint course_code_key;
alter table course
    add unique (code);

```

```sql
insert into course(name, code, credits)
values ('Data Structures', 'DS', 3);
-- delete from course where code = 'DS';
```

### Foreign Key Constraints

- References to other tables
- Usually refers to primary keys in other tables
- Usually created to represent relationships when translating an ER diagram into
  a relational schema
- A column or group of columns can be references to a column or group of columns
  in another table
- We can use a column constraint if the foreign key has only 1 column
    - `sid integer references student(sid)`
- If the foreign key has more than 1 column, we must use a table constraint
    - specified after all columns in the `create table` statement
    - `foreign key(eid, sid) references enrollment(eid, sid)`

### FK Constraints Policy

- When we insert a new row in a table with a foreign key, the value we specify
  for the foreign key column(s) must exists
  in the other table we refer to
    - this is often called a **referential integrity constraint**
        - this usually corresponds to a *many-exactly-one* relationship
    - exception: if we allow `null` values for the foreign key column(s),
      then `null` values don't have to exist in the
      other table
        - and `null` values usually won't exist because the column(s) the FK
          refers to will usually be primary key
          columns
        - this usually corresponds to a *many-at-most-one* relationship
- But what happens when we delete or update a row in the table the FK refers to?
    - If the value the FK column(s) refers to doesn't exist anymore, what do we
      do?

- In the SQL standards, the valid actions are
    - `RESTRICT`, `CASCADE`, `SET NULL`, `NO ACTION` and `SET DEFAULT`
- Not all valid actions are implemented in all DBMSs
- The default FK policy is `RESTRICT`
    - if performing the update or delete would leave "*orphan*" rows (rows that
      refer to non-existing values), then
      block the update or delete and return an error message
    - `NO ACTION` is a synonym for `RESTRICT`
- If the `CASCADE` policy is set
    - then the changes are propagated to rows depending on the original row
        - if the row is deleted, then the rows depending on it will also be
          deleted (**very dangerous**)
        - if the row is updated, then the rows depending on it will also be
          updated
- If the policy is set to `SET NULL` or `SET DEFAULT`, it will replace the FK
  column(s) values by the `null` or default
  value, if possible

### Check Constraints

- Check if an expression before performing an insert or update
    - if the expression is false, then the insert or update will abort
    - otherwise, it will succeed
    - be careful: if the expression evaluates to `null`, then the insert or
      update will succeed
- If the check constraints refers to only 1 column, it can be specified as a
  column constraint
    - `score integer check(score >= 0 and score <= 100)`
- If the check constraints refers to 2 or more columns, it must be specified as
  a table constraint
    - `check(end_date >= start_date)`
        - note that if any of the dates is `null`, the expression will be `null`
          and the check will pass

### Domain Constraints

- A domain is used to restrict the possible values for a data type
- A domain
    - can have a default value
    - can be defined with a `null` or `not null` constraint
    - can have 1 or more check constraints
- A domain can be used to avoid repeating too many constraints, especially check
  constraints
    - `create domain score as integer check(score >= 0 and score <= 100)`

### Assertions

- General constraints that can apply to more than 1 row of a table or to columns
  of more than 1 table
- Like more general check constraints that are not limited to only 1 row
- Most DBMSs do not have full assertion support, even no assertion support at
  all

## Triggers

- Triggers are used in active databases
- They are similar to *events* in an *event-driven architecture*
- A trigger usually executes a function on some specific event or events
- The function it executes is similar to an event handler
    - for example, in an HTML page, you can associate a JavaScript function to
      an `onclick` event on a button
        - `<button onclick="do_something()">Do something</button>`
- Triggers follow the *ECA structure* to define *active rules*
    - **E**vent: signal (trigger) invoking the rule
    - **C**ondition: logical test, determines if the action will be carried out
      or not
    - **A**ction: code or function (in SQL, PL/SQL, or some other supported
      language) running on the DB
- Trigger support varies across DBMSs

### When to Use Triggers

- Triggers can be used to enforce constraints that cannot be enforced in other
  ways
    - if assertions are not supported, then similar functionality can be
      achieved with triggers
    - but triggers are more powerful than assertions
- Triggers can be used for logging
    - if you want (or need) to keep change logs, then triggers can help
    - normally, when inserts, updates and deletes are executed on the DB, no
      traces will be left
    - create triggers to insert data in a log or history table (or tables)
    - more details: https://en.wikipedia.org/wiki/Log_trigger

- Triggers can be used for many other things
    - to generate/update values for other columns
    - to update a statistics table
    - to audit sensitive data
    - to send emails to DBAs on critical events
    - to implement other business rules

- Similarly to event-driven programming in JavaScript or other programming
  languages, functions need to be associated to some events
    - the most common events are: `INSERT`, `UPDATE`, and `DELETE`
    - with 1 modifier (specified before the event): `BEFORE` or `AFTER`
- The event can be triggered for each row or for the whole statement
    - a single `INSERT`, `UPDATE`, or `DELETE` statement can apply to 1 or
      multiple rows
    - by default, we get a *statement-level* trigger
    - if we specify *FOR EACH ROW*, then we get a *row-level* trigger

- For example, after inserting a new employee's information in an `employee`
  table, we might want to automatically
  create an account to let the new employee log in on the company system
    - creating such an account probably necessitates inserting a row in
      an `account` table
    - so we need an `AFTER INSERT` trigger for this
    - note that sometimes, this functionality is handled by the front-end
      application, not the database
- Another example: we could have a `BEFORE DELETE` trigger to archive important
  deleted data
    - we could insert the deleted data in another table
    - we could also record who deleted the data, and when it was deleted

- Unfortunately, trigger implementations vary in different DBMSs
    - Some support only subsets of the standard, some make small changes to it
- In PostgreSQL, triggers can be created with the following (simplified) syntax

```
CREATE TRIGGER trigger_name 
{BEFORE | AFTER | INSTEAD OF} {event [OR ...]}
   ON table_name
   [FOR [EACH] {ROW | STATEMENT}]
       EXECUTE PROCEDURE trigger_function
```

- where `event` can be `INSERT`, `UPDATE`, `DELETE` or `TRUNCATE`
- Refer to these for more details:
    - [https://www.postgresqltutorial.com/creating-first-trigger-postgresql/](https://www.postgresqltutorial.com/creating-first-trigger-postgresql/)
    - [https://www.postgresql.org/docs/14/sql-createtrigger.html](https://www.postgresql.org/docs/14/sql-createtrigger.html)
    - [https://www.postgresql.org/docs/14/triggers.html](https://www.postgresql.org/docs/14/triggers.html)

- On MySQL/MariaDB, the basic syntax is

```
CREATE TRIGGER trigger_name
{BEFORE | AFTER} {INSERT | UPDATE| DELETE }
ON table_name FOR EACH ROW
trigger_body;
```

- Refer to these for more details:
    - [https://www.mysqltutorial.org/create-the-first-trigger-in-mysql.aspx](https://www.mysqltutorial.org/create-the-first-trigger-in-mysql.aspx)
    - [https://dev.mysql.com/doc/refman/8.0/en/create-trigger.html](https://dev.mysql.com/doc/refman/8.0/en/create-trigger.html)
    - [https://dev.mysql.com/doc/refman/8.0/en/trigger-syntax.html](https://dev.mysql.com/doc/refman/8.0/en/trigger-syntax.html)


- On Oracle, triggers can be created using the following syntax

```
CREATE [OR REPLACE] TRIGGER trigger_name
{BEFORE | AFTER } triggering_event ON table_name
[FOR EACH ROW]
[FOLLOWS | PRECEDES another_trigger]
[ENABLE / DISABLE ]
[WHEN condition]
DECLARE
    declaration statements
BEGIN
    executable statements
EXCEPTION
    exception_handling statements
END;
```

- [https://www.oracletutorial.com/plsql-tutorial/oracle-trigger/](https://www.oracletutorial.com/plsql-tutorial/oracle-trigger/)

- To make good use of triggers, we need to write functions or procedures in some
  programming language
    - PL/SQL (programming language for SQL) is supported in some form in most
      relational databases
    - or some other supported programming language, such as C
        - PostgreSQL supports *user-defined types (UDT)* and *user defined
          functions (UDF)*
        - UDF can be defined in PL/SQL or C
        - UDF can be used for triggers
    - other programming languages support programming languages in different
      ways
    
