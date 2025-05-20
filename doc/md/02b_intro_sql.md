# Introduction to SQL

## University DB

Run the `university_create.sql` file to create the University DB.

```postgresql
set search_path to university;
```

1. *Projection*: choose the columns to include in the results
   ```postgresql
   select name, email
   from student;
   ```
2. Suppose the university is charging 200$ per credit for a course. Find the price for each course.
    - `price` is an alias for the calculated column
   ```postgresql
   select code, name, credits * 200 as price
   from course;
   ```
3. *Selection*: filter the rows to include in the results
    - Keep only the course offerings for the winter 2020 semester
   ```postgresql
   select *
   from offering
   where semester = 'W'
     and year = 2020;
   ```
4. *Sorting*: order the instructors by their names
   ```postgresql
   select iid, name, email
   from instructor
   order by name;
   
   select iid, name, email
   from instructor
   order by 2;
   ```
