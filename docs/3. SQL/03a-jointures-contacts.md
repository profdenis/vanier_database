# 3a - Queries with More Than One Table (Contacts)

```sql
SET
search_path TO contacts;
```

## Cartesian Product

- Associate each row of one table with each row of the other table
    - gives too many rows
    - rarely used because it generally doesn't provide useful information
    - and it can become very inefficient if the tables involved are large
        - the number of rows in the results will be the multiplication of the number of rows in each table involved

```sql
SELECT *
FROM call,
     contact;
```

## Join (with Cartesian Product)

- Keep only the matching rows, by "following" the foreign key from `call` to `contact`
    - this is the old way of doing a join (a Cartesian product followed by a `WHERE` condition)

```sql
SELECT *
FROM call,
     contact
WHERE call.contact_id = contact.contact_id;
```

## Joins (with `JOIN`)

### Inner Join

- A more modern way to express a join in SQL
    - there are several types of joins, the most common type is an `INNER JOIN`

```sql
SELECT *
FROM call
         INNER JOIN contact
                    ON call.contact_id = contact.contact_id;
```

### Natural Join

- Join on columns having the same names, using the = operator, and removing duplicate columns
    - note that the columns are in a different order
    - it is not recommended (even discouraged) to use natural joins because the join condition is not specified and
      could have consequences that are difficult to predict, especially in the long term if the database is modified
      after the queries are written

```sql
SELECT *
FROM call
         NATURAL JOIN contact; 
```

- The phone call with ID 2 doesn't match any contact, so it's not listed in the results
- Every time we use = with `NULL`, it's always false, so call 3 is not in the results

### Outer Joins

- Use a *left outer join* to keep phone calls that don't match any contact
    - it's like an inner join, but rows on the left that don't match anything on the right will be kept

```sql
SELECT *
FROM call
         LEFT OUTER JOIN contact
                         ON call.contact_id = contact.contact_id;
```

- Use a *right outer join* to keep contacts that don't match any phone call

```sql
SELECT *
FROM call
         RIGHT OUTER JOIN contact
                          ON call.contact_id = contact.contact_id;
```

- Or a *full outer join* to keep rows that don't match anything on either side

```sql
SELECT *
FROM call
         FULL OUTER JOIN contact
                         ON call.contact_id = contact.contact_id;
```
