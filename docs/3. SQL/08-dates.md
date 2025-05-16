# 8 - Using `date` and `timestamp`

Here is a guide on operations and functions for dates and timestamps in PostgreSQL.

## Differences between `date` and `timestamp`

Here are the main differences between the `date` and `timestamp` types in PostgreSQL:

1. Stored content:
    - `date` stores only a date (year, month, day)
    - `timestamp` stores a date and time (year, month, day, hour, minute, second, and optionally fractions of a second)

2. Storage size:
    - `date` occupies 4 bytes
    - `timestamp` occupies 8 bytes

3. Precision:
    - `date` has a precision of one day
    - `timestamp` has a precision of one microsecond

4. Range of values:
    - `date`: from 4713 BC to 5874897 AD
    - `timestamp`: from 4713 BC to 294276 AD

5. Temporal operations:
    - `date` allows basic operations on dates
    - `timestamp` allows more precise operations including hours, minutes, and seconds

6. Time zone:
    - `date` does not include time zone information
    - `timestamp` may or may not include time zone information (depending on whether you use `timestamp with time zone`
      or `timestamp without time zone`)

7. Usage:
    - `date` is used when only the date is important (e.g., birth date)
    - `timestamp` is used when you need the precise date and time (e.g., transaction timestamp)

In general, `timestamp` offers more flexibility and precision, but `date` can be sufficient and more efficient in terms
of storage if only the date is necessary.

### Conversion

To convert a `timestamp` to a `date`, or vice-versa, you can _cast_ from one to the other:

```sql
select (now()::date);
-- now() gives the current timestamp
```

| now        |
|:-----------|
| 2024-09-27 |

```sql
select (CURRENT_DATE::timestamp);
-- CURRENT_DATE gives today's date
```

| current\_date              |
|:---------------------------|
| 2024-09-27 00:00:00.000000 |

## Simple comparisons with dates in ISO format

PostgreSQL natively supports the ISO 8601 date format (YYYY-MM-DD) for comparisons:

- Table `users`

| id | name  | created                    |
|:---|:------|:---------------------------|
| 1  | denis | 2024-09-25 20:42:08.200074 |
| 3  | bob   | 2023-08-09 12:12:00.000000 |
| 2  | alice | 2024-07-25 02:42:08.200074 |

```sql
select *
from users
where created > '2024-09-15';
```

| id | name  | created                    |
|:---|:------|:---------------------------|
| 1  | denis | 2024-09-25 20:42:08.200074 |

```sql
-- Select records between two dates
select *
from users
where created between '2023-01-01' and '2023-12-12';
```

| id | name | created                    |
|:---|:-----|:---------------------------|
| 3  | bob  | 2023-08-09 12:12:00.000000 |

```sql
-- Select records between two dates
select *
from users
where created between '2023-01-01' and '2023-08-09';
```

| id | name | created |
|:---|:-----|:--------|

## Common date functions

### EXTRACT

Allows extracting a specific part of a date or timestamp.

```sql
select name, extract(year from created) as year
from users;
```

| name  | year |
|:------|:-----|
| denis | 2024 |
| alice | 2024 |
| bob   | 2023 |

```sql
select name, extract(month from created) as month
from users;
```

| name  | month |
|:------|:------|
| denis | 9     |
| alice | 7     |
| bob   | 8     |

### DATE_PART

Similar to EXTRACT, allows obtaining a specific part of a date.

```sql
select name, date_part('year', created) as year
from users;
```

| name  | year |
|:------|:-----|
| denis | 2024 |
| alice | 2024 |
| bob   | 2023 |

#### Differences between `EXTRACT` and `DATE_PART`

Here are the main differences between the `EXTRACT()` and `DATE_PART()` functions in PostgreSQL:

1. Syntax:
    - `EXTRACT()` uses the syntax: `EXTRACT(field FROM source)`
    - `DATE_PART()` uses the syntax: `DATE_PART('field', source)`

2. SQL Standard:
    - `EXTRACT()` conforms to the SQL standard
    - `DATE_PART()` is specific to PostgreSQL

3. Return type:
    - `EXTRACT()` returns a numeric type since PostgreSQL 14
    - `DATE_PART()` always returns a double precision (float8)

4. Performance:
    - Before PostgreSQL 14, `EXTRACT()` was rewritten as `DATE_PART()` internally
    - Since PostgreSQL 14, the implementations are different

5. Precision:
    - `EXTRACT()` can be more precise for certain calculations since PostgreSQL 14
    - `DATE_PART()` may lose precision in some cases due to the float type

6. Usage:
    - `EXTRACT()` is generally preferred for SQL compatibility
    - `DATE_PART()` is still used out of habit or for compatibility with older versions

In practice, the two functions are very similar and interchangeable in most cases. The choice often depends on personal
preferences or coding conventions. For better portability and precision, `EXTRACT()` is generally recommended.

### DATE_TRUNC

Truncates a date to a specified precision.

```sql
select name, date_trunc('month', created)
from users;
```

| name  | date\_trunc                |
|:------|:---------------------------|
| denis | 2024-09-01 00:00:00.000000 |
| bob   | 2023-08-01 00:00:00.000000 |
| alice | 2024-07-01 00:00:00.000000 |

### `now` and `current_date`

- `now()`: Returns the current date and time with time zone.
- `current_date`: Returns the current date.

```sql
select now();
```

| now                               |
|:----------------------------------|
| 2024-09-25 21:12:05.032204 +00:00 |

```sql
select current_date;
```

| current\_date |
|:--------------|
| 2024-09-25    |

### Differences between `now()` and `current_date`

1. Return type:
    - `now()` returns a timestamp with time zone (date and time with time zone)
    - `current_date` returns only a date (without time or time zone)

2. Precision:
    - `now()` includes hour, minutes, seconds, and microseconds
    - `current_date` returns only the date (year, month, day)

3. Usage in transactions:
    - `now()` returns the same value throughout a transaction
    - `current_date` can change if the transaction spans midnight

4. Performance:
    - `current_date` is generally faster because it only processes the date

5. Behavior with time zones:
    - `now()` takes into account the session's time zone
    - `current_date` always returns the server's local date

6. Flexibility:
    - `now()` can be easily converted to other temporal types
    - `current_date` is limited to operations on dates

7. Consistency:
    - `now()` remains constant in a transaction, useful for data consistency
    - `current_date` can change, always reflecting the current date

In summary, `now()` offers more precision and flexibility, while `current_date` is simpler and faster when only the date
is needed.

## Operations with `interval`

Using `interval` allows performing calculations on dates:

```sql
-- Add 1 month to the current date
select current_date + interval '1 month';
```

| ?column?                   |
|:---------------------------|
| 2024-10-25 00:00:00.000000 |

```sql
-- Subtract 2 weeks from a specific date
select date '2023-01-15' - interval '2 weeks';
```

```sql
-- users created in the last month
select name, users.created
from users
where created > current_date - interval '1 month';
```

| name  | created                    |
|:------|:---------------------------|
| denis | 2024-09-25 20:42:08.200074 |

## Advanced examples

### Calculate age

```sql
select name, age(created)
from users;
-- Returns the interval between the specified date and the current date
```

| name  | age                                                     |
|:------|:--------------------------------------------------------|
| denis | 0 years 0 mons 0 days -20 hours -42 mins -8.200074 secs |
| bob   | 1 years 1 mons 15 days 11 hours 48 mins 0.0 secs        |
| alice | 0 years 1 mons 30 days 21 hours 17 mins 51.799926 secs  |

### Convert a string to a date

```sql
select to_date('2023-09-21', 'yyyy-mm-dd');
-- Converts the string to a date
```

### Format a date

```sql
select to_char(current_date, 'DD/MM/YYYY');
-- Formats the current date in DD/MM/YYYY format
```

| to\_char   |
|:-----------|
| 25/09/2024 |

These examples cover the most common operations on dates and timestamps in PostgreSQL. Remember that PostgreSQL offers
many other functions and capabilities for manipulating dates and times according to your specific needs.

## Date operations

1. Date subtraction:
    - You can subtract two dates to get an interval.
    - Example: `date '2023-09-21' - date '2023-01-01'` will return an interval representing the difference between these
      two dates.

2. Addition/Subtraction with an interval:
    - You can add or subtract an interval to a date.
    - Example: `date '2023-09-21' + interval '1 month'` will add one month to the specified date.

## Timestamp operations

1. Timestamp subtraction:
    - Subtracting two timestamps returns an interval.
    - Example: `timestamp '2023-09-21 10:00:00' - timestamp '2023-09-20 09:00:00'` will give the interval between these
      two moments.

2. Addition/Subtraction with an interval:
    - As with dates, you can add or subtract intervals to timestamps.
    - Example: `timestamp '2023-09-21 10:00:00' - interval '2 hours'` will subtract 2 hours from the timestamp.

## Important points to note

1. Precision: Operations on timestamps are more precise because they take into account hours, minutes, and seconds.

2. Time zones: For `timestamp with time zone`, PostgreSQL automatically handles time zone adjustments during operations.

3. Complex intervals: You can use complex intervals like `interval '1 year 2 months 3 days'` for more elaborate
   calculations.

4. AGE() function: To calculate the difference between two dates or timestamps in a more readable way, you can use the
   `age()` function.

These operations are very useful for performing temporal calculations in your queries, such as finding the duration
between two events or calculating future or past dates based on a reference date.

## Converting an interval to a number of hours (float)

The most common method for converting an interval to a number is to transform it into seconds, then divide it to get the
desired unit. To get a number of hours as a float, you can use the EXTRACT function with the 'epoch' unit:

```sql
select extract(epoch from interval '4 hours 30 minutes') / 3600.0 as hours;
```

This query will return 4.5, representing 4 hours and 30 minutes in decimal format.

## Conversion to numeric

For a conversion to numeric type, which offers arbitrary precision, you can use a similar approach:

```sql
select cast(extract(epoch from interval '4 hours 30 minutes') / 3600.0 as numeric(10, 2)) as hours;
```

This query will convert the interval to a numeric number with 2 decimal places.

## Important points to note

1. Precision: Converting an interval to a number can lead to a loss of precision, especially for intervals including
   years or months, as these units don't have a fixed duration in seconds.

2. Variable units: Years and months are treated specially in PostgreSQL intervals. For example, '1 year' is not always
   equal to 365 days, which can lead to unexpected results during conversion.

3. Choice of unit: You can adjust the divisor (3600.0 in the examples above) to get other units. For example, use
   86400.0 to get days, or 60.0 for minutes.

4. `to_char()` function: For more complex formatting needs, you can use the to_char() function which allows formatting
   various data types, including intervals.

In conclusion, although PostgreSQL does not provide a direct conversion of an interval to float or numeric, it is
possible to perform this conversion using the EXTRACT function with the 'epoch' unit, followed by a division and
possibly a CAST if necessary.

