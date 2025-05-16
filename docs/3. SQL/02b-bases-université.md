# 2b - University Database

Run the [university_create.sql](../src/create/university_create.sql) file to create the University database.

```sql
set
search_path to university;
```

1- **Projection**: choose the columns to include in the results

```sql
select name, email
from student;
```

2- Suppose the university charges $200 per credit for a course. Find the price for each course.

   - `price` is an alias for the calculated column

```sql
select code, name, credits * 200 as price
from course;
```

3- **Selection**: filter the rows to include in the results

   - Keep only course offerings for the Winter 2020 semester

```sql
select *
from offering
where semester = 'W'
          and year = 2020;
```

4- **Sorting**: order instructors by their names

```sql
select iid, name, email
from instructor
order by name;

select iid, name, email
from instructor
order by 2;
```

