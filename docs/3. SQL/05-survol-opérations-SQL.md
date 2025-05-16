# 5 - Overview of Operations in SQL Queries

To begin understanding the basic operations of an SQL query, let's examine a simple projection using the `SELECT` and
`FROM` clauses. These clauses are fundamental for extracting data from a relational database like PostgreSQL. We'll
illustrate this with a store customer table.

## Creating a Customer Table

Let's imagine we have a table named `customers` that contains information about store customers. Here's how this table
might be defined and populated with some example rows:

```sql
CREATE TABLE customers
(
    id                SERIAL PRIMARY KEY,
    lastname          VARCHAR(50),
    firstname         VARCHAR(50),
    email             VARCHAR(100),
    city              VARCHAR(50),
    registration_date DATE
);

INSERT INTO customers (lastname, firstname, email, city, registration_date)
VALUES ('Dupont', 'Jean', 'jean.dupont@example.com', 'Paris', '2023-01-15'),
       ('Martin', 'Marie', 'marie.martin@example.com', 'Lyon', '2023-02-20'),
       ('Durand', 'Paul', 'paul.durand@example.com', 'Marseille', '2023-03-10'),
       ('Lefevre', 'Sophie', 'sophie.lefevre@example.com', 'Toulouse', '2023-04-05'),
       ('Moreau', 'Pierre', 'pierre.moreau@example.com', 'Nice', '2023-05-18'),
       ('Simon', 'Lucie', 'lucie.simon@example.com', 'Nantes', '2023-06-22'),
       ('Laurent', 'Julie', 'julie.laurent@example.com', 'Bordeaux', '2023-07-30'),
       ('Lemoine', 'Antoine', 'antoine.lemoine@example.com', 'Strasbourg', '2023-08-14'),
       ('Roux', 'Claire', 'claire.roux@example.com', 'Lille', '2023-09-01'),
       ('Petit', 'Nicolas', 'nicolas.petit@example.com', 'Rennes', '2023-10-10');
```

## Using `SELECT` and `FROM`

The `SELECT` clause is used to specify the columns you want to retrieve, while the `FROM` clause indicates the table
from which this data comes. Here are some examples of SQL queries using these clauses:

### Example 1: Select All Columns

To retrieve all information from the `customers` table, you can use the asterisk (`*`) to indicate that you want all
columns:

```sql
SELECT *
FROM customers;
```

### Example 2: Select Specific Columns

If you only want certain columns, for example, the name and email of customers, you can specify these columns in the
`SELECT` clause:

```sql
SELECT lastname, email
FROM customers;
```

### Example 3: Select with an Alias

You can also use aliases to rename columns in the result. This can be useful for making results more readable or to
avoid name conflicts:

```sql
SELECT lastname AS CustomerName, email AS CustomerEmail
FROM customers;
```

### Summary

- **`SELECT`**: Specifies the columns to retrieve.
- **`FROM`**: Indicates the table from which the data comes.

These basic operations form the foundation of data manipulation in SQL. As you progress, you'll learn to use other
clauses and functions to perform more complex operations, such as filtering with `WHERE`, sorting with `ORDER BY`, and
much more.

## Using the `WHERE` Clause

The second fundamental operation in an SQL query is filtering data using the `WHERE` clause. This clause allows you to
specify conditions that must be met for a row to be included in the query result. Let's look at some simple examples of
filtering on our `customers` table.

The `WHERE` clause is used to extract only records that meet a specific condition. Here are some examples illustrating
its use:

### Example 1: Filter by City

Suppose we want to retrieve all customers who live in Paris. We'll use the `WHERE` clause to specify this condition:

```sql
SELECT *
FROM customers
WHERE city = 'Paris';
```

### Example 2: Filter by Last Name

If we want to find all customers whose last name is "Durand", we can write the following query:

```sql
SELECT *
FROM customers
WHERE lastname = 'Durand';
```

### Example 3: Filter by Email

To retrieve customers whose email address ends with "@example.com", we can use the `LIKE` operator with a search
pattern:

```sql
SELECT *
FROM customers
WHERE email LIKE '%@example.com';
```

### Example 4: Filter by Multiple Conditions

It's also possible to combine multiple conditions using the logical operators `AND` and `OR`. For example, to select
customers who live in Lyon or Marseille, we'll use `OR`:

```sql
SELECT *
FROM customers
WHERE city = 'Lyon'
   OR city = 'Marseille';
```

To select customers who live in Paris and whose last name is "Dupont", we'll use `AND`:

```sql
SELECT *
FROM customers
WHERE city = 'Paris'
  AND lastname = 'Dupont';
```

### Example 5: Filter by Numeric Conditions

Although our `customers` table doesn't contain numeric data in this example, if it had a column like `age`, we could
filter customers over 30 years old as follows:

```sql
SELECT *
FROM customers
WHERE age > 30;
```

### Summary

- **`WHERE`**: Used to filter rows based on specific conditions.
- **Logical Operators**: `AND`, `OR` to combine multiple conditions.
- **Comparison Operators**: `=`, `>`, `=`, `` (not equal).
- **`LIKE`**: Used for pattern searches in character strings.

The `WHERE` clause is essential for extracting relevant and precise data from a database, based on the specific needs of
the user or application.

## Using `ORDER BY`

Sorting results in an SQL query is done using the `ORDER BY` clause. This clause allows you to specify the order in
which rows should be returned, whether in ascending or descending order. You can sort results based on one or more
columns.

### Example 1: Simple Sort by Name

To sort results by customer name in ascending order (default), you can use the following query:

```sql
SELECT *
FROM customers
ORDER BY lastname;
```

### Example 2: Sort in Descending Order

To sort results by customer name in descending order, use the `DESC` keyword:

```sql
SELECT *
FROM customers
ORDER BY lastname DESC;
```

### Example 3: Sort by Multiple Columns

You can sort results by multiple columns. For example, to sort first by city in ascending order, then by name in
descending order:

```sql
SELECT *
FROM customers
ORDER BY city, lastname DESC;
```

### Example 4: Sort with a `WHERE` Clause

You can combine `ORDER BY` with a `WHERE` clause to filter and sort results. For example, to get customers from Paris
sorted by registration date:

```sql
SELECT *
FROM customers
WHERE city = 'Paris'
ORDER BY registration_date;
```

### Summary

- **`ORDER BY`**: Used to specify the order of results.
- **Ascending Order**: By default, results are sorted in ascending order (`ASC`).
- **Descending Order**: Use `DESC` to sort in descending order.
- **Multiple Sorting**: You can sort by multiple columns by separating them with commas.
- **Combination with `WHERE`**: `ORDER BY` can be used after `WHERE` to sort filtered results.

Sorting results is a powerful feature that allows you to present data in an organized and readable way, based on your
specific needs.

## Scalar Functions

In SQL, functions can be used in the `SELECT` clause to perform various operations on data. These functions can be
aggregate functions, which operate on a set of values to return a single one, or scalar functions, which operate on a
single value and return a new value.

Scalar functions are applied to each row individually. Here are some examples:

### Example 1: Using `UPPER` to Convert to Uppercase

Suppose we want to display last names in uppercase:

```sql
SELECT UPPER(lastname) AS UppercaseName, firstname
FROM customers;
```

### Example 2: Using `LENGTH` to Get the Length of a String

To get the length of email addresses:

```sql
SELECT lastname, LENGTH(email) AS EmailLength
FROM customers;
```

### Example 3: Using Functions on Dates

Imagine we've added a `registration_date` column to our `customers` table and we want to extract the registration year:

```sql
ALTER TABLE customers
    ADD COLUMN registration_date DATE;

UPDATE customers
SET registration_date = '2023-01-15'
WHERE id = 1;
-- (Add dates for other customers as needed)

SELECT lastname, EXTRACT(YEAR FROM registration_date) AS RegistrationYear
FROM customers;
```

## Aggregate Functions

Aggregate functions calculate a single value from a set of values. Here are some examples:

### Example 4: Using `COUNT` to Count the Number of Customers

To count the total number of customers in the table:

```sql
SELECT COUNT(*) AS NumberOfCustomers
FROM customers;
```

### Example 5: Using `AVG` to Calculate an Average

If we had an `age` column and we wanted to calculate the average age of customers:

```sql
ALTER TABLE customers
    ADD COLUMN age INT;

UPDATE customers
SET age = 30
WHERE id = 1;
-- (Add ages for other customers as needed)

SELECT AVG(age) AS AverageAge
FROM customers;
```

### Example 6: Using `MIN` and `MAX` to Find Extreme Values

To find the minimum and maximum age:

```sql
SELECT MIN(age) AS MinimumAge, MAX(age) AS MaximumAge
FROM customers;
```

### Summary

- **Scalar Functions**: Operate on each row individually (e.g., `UPPER`, `LENGTH`, `EXTRACT`).
- **Aggregate Functions**: Operate on a set of rows to return a single value (e.g., `COUNT`, `AVG`, `MIN`, `MAX`).
- **Date Functions**: Used to manipulate and extract information from dates (e.g., `EXTRACT`).

These functions enhance SQL's capabilities by allowing advanced transformations and calculations on data.

## Inner Join (`INNER JOIN`)

An inner join (INNER JOIN) is an operation that combines rows from two tables based on a common condition, typically a
foreign key. It returns only rows for which there is a match in both tables.

### Creating the Orders Table

To create an `orders` table that records orders placed by customers, we'll define a foreign key linking each order to a
specific customer in the `customers` table. Here's how you can create this table, insert data, and represent it in
Markdown format.

```sql
CREATE TABLE orders
(
    id          SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers (id),
    order_date  DATE,
    amount      DECIMAL(10, 2)
);

INSERT INTO orders (customer_id, order_date, amount)
VALUES (1, '2023-01-20', 150.00),
       (1, '2023-02-15', 200.50),
       (2, '2023-03-05', 300.75),
       (3, '2023-03-15', 120.00),
       (4, '2023-04-10', 450.00),
       (4, '2023-04-15', 300.00),
       (4, '2023-04-20', 250.00),
       (6, '2023-06-30', 60.00),
       (8, '2023-08-20', 250.00),
       (9, '2023-09-10', 320.00);
```

### Explanations

- **`customer_id`**: This column is a foreign key that references the identifier (`id`) of the `customers` table. This
  establishes a relationship between orders and customers, indicating which customer placed each order.
- **`order_date`**: Records the date on which the order was placed.
- **`amount`**: Indicates the total amount of the order.

This structure allows modeling a one-to-many relationship between customers and orders, where a customer can place
multiple orders.

### Example 1: Add Each Customer's Email to the Order List

To get a list of all orders with the associated customer's email, we use an inner join between the `orders` table and
the `customers` table. The join condition is that the customer ID in the `orders` table (`customer_id`) must match the
customer ID in the `customers` table (`id`).

```sql
SELECT orders.id AS OrderID, orders.order_date, orders.amount, customers.email
FROM orders
         INNER JOIN customers ON orders.customer_id = customers.id;
```

#### Explanation

- **`SELECT`**: Specifies the columns to include in the result. Here, we select the order ID, order date, amount, and
  customer email.
- **`FROM orders`**: Indicates that the main table for the join is `orders`.
- **`INNER JOIN customers ON orders.customer_id = customers.id`**: Performs the inner join by linking orders to
  customers using the foreign key `customer_id` of `orders` and the primary key `id` of `customers`.

### Example 2: List All Orders from Jean Dupont

To list all orders placed by Jean Dupont, we also use an inner join, but with an additional condition to filter the
results.

```sql
SELECT orders.id AS OrderID, orders.order_date, orders.amount
FROM orders
         INNER JOIN customers ON orders.customer_id = customers.id
WHERE customers.lastname = 'Dupont'
  AND customers.firstname = 'Jean';
```

#### Explanation

- **`WHERE customers.lastname = 'Dupont' AND customers.firstname = 'Jean'`**: Adds a condition to filter results to
  include only orders placed by Jean Dupont.
- The join links the `orders` and `customers` tables in the same way as in the first example, but the `WHERE` restricts
  results to a specific customer.

### Summary

- **Inner Join**: Combines rows from two tables for which there is a match in the specified columns.
- **Usage**: Often used to combine data spread across multiple tables, such as associating orders with customers.
- **Syntax**: `INNER JOIN` followed by the matching condition (`ON`).

Inner joins are essential for fully exploiting relationships between tables in a relational database. They allow
combining and analyzing data from different sources in a coherent and efficient manner.

## Left Outer Join

A left outer join (`LEFT JOIN`) is used to return all rows from the left table (in this case, `customers`), as well as
matching rows from the right table (`orders`). If no match is found in the right table, the results will contain null
values for the columns of the right table.

### Query: Find Customers Who Have No Orders

To identify customers who have not placed orders, we can use a left outer join and filter the results to include only
rows for which there is no match in the `orders` table.

```sql
SELECT customers.id, customers.lastname, customers.firstname, customers.email
FROM customers
         LEFT JOIN orders ON customers.id = orders.customer_id
WHERE orders.id IS NULL;
```

#### Explanation

- **`LEFT JOIN`**: Returns all rows from the `customers` table and matching rows from `orders`. If a customer has no
  orders, the columns of `orders` will contain null values.
- **`WHERE orders.id IS NULL`**: Filters the results to include only customers who have no orders, i.e., those for whom
  `orders.id` is `NULL`.

### Results of the Query

Here's the Markdown table representing the results of this query:

| id | Last Name | First Name | Email                     |
|----|-----------|------------|---------------------------|
| 5  | Moreau    | Pierre     | pierre.moreau@example.com |
| 7  | Laurent   | Julie      | julie.laurent@example.com |
| 10 | Petit     | Nicolas    | nicolas.petit@example.com |

These results show customers who have no orders recorded in the database. The left outer join is particularly useful for
identifying records in one table that don't match records in another table.

## Comparison of Outer Joins

### 1. Left Join (`LEFT JOIN`)

- Returns all rows from the left table (first mentioned table).
- Includes matching rows from the right table if they exist.
- If no match is found, the columns of the right table contain `NULL`.

```sql
SELECT *
FROM customers
         LEFT JOIN orders ON customers.id = orders.customer_id;
```

### 2. Right Join (`RIGHT JOIN`)

- Returns all rows from the right table (second mentioned table).
- Includes matching rows from the left table if they exist.
- If no match is found, the columns of the left table contain NULL.

```sql
SELECT *
FROM customers
         RIGHT JOIN orders ON customers.id = orders.customer_id;
```

### 3. Full Outer Join (`FULL JOIN`)

- Combines the results of a left join and a right join.
- Returns all rows from both tables.
- If no match is found, the columns of the non-matching table contain NULL.

```sql
SELECT *
FROM customers
         FULL OUTER JOIN orders ON customers.id = orders.customer_id;
```

### Key Differences

1. **LEFT JOIN**: Useful for finding all records from the left table, even if they don't have a match in the right
   table.

2. **RIGHT JOIN**: Similar to LEFT JOIN, but focusing on the right table. Less commonly used, as you can usually get the
   same result by reversing the order of the tables and using a LEFT JOIN.

3. **FULL JOIN**: Combines the results of the two previous joins. Useful for seeing all data from both tables, whether
   there's a match or not.

### Example Usage

- **LEFT JOIN**: Find all customers, whether they've placed orders or not.
- **RIGHT JOIN**: Find all orders, even if they're associated with customers who no longer exist in the customers table.
- **FULL JOIN**: See all customers and all orders, identifying cases where there's no match in either table.

### Important Note

The word `OUTER` can be added to each of these joins (`LEFT OUTER JOIN`, `RIGHT OUTER JOIN`, and `FULL OUTER JOIN`), but
it's optional. Using `OUTER` doesn't change the behavior of the join; it simply makes explicit the fact that it's an
outer join.

These outer joins are essential for analyzing data that may not have perfect matches between tables, thus allowing a
more complete view of the available data.

## Grouping with `GROUP BY`

Groupings in SQL, done with the `GROUP BY` clause, allow aggregating data based on specific criteria. Here's a detailed
explanation with examples using our `customers` and `orders` tables.

The `GROUP BY` clause is used to group rows that have the same values in specified columns. It's often used with
aggregate functions like `COUNT()`, `SUM()`, `AVG()`, etc.

### Example 1: Number of Orders per Customer

```sql
SELECT customer_id, COUNT(*) AS number_of_orders
FROM orders
GROUP BY customer_id;
```

Which might give a result like:

| customer_id | number_of_orders |
|-------------|------------------|
| 1           | 2                |
| 2           | 1                |
| 3           | 1                |
| 4           | 3                |
| 6           | 1                |
| 8           | 1                |
| 9           | 1                |

The concept of grouping in SQL, particularly with the `GROUP BY` clause, is essential for understanding how data is
aggregated and summarized. Here's a detailed explanation of the group formation process:

### Grouping Concept

#### Group Definition

- **Grouping Key**: Groups are defined by the distinct values of one or more columns specified in the `GROUP BY` clause.
  In our example, the grouping key is `customer_id`. This means that each unique value of `customer_id` in the `orders`
  table defines a distinct group.

#### Group Formation

1. **Identification of Unique Values**: The SQL engine identifies all unique values of the `customer_id` column in the
   `orders` table. Each unique value becomes the basis for a group.

2. **Row Grouping**: All rows (or records) in the table that share the same value of `customer_id` are grouped together.
   This means that each group contains all orders associated with a particular customer.

#### Grouping Process

- **Data Extraction**: The SQL engine goes through the `orders` table and extracts each row.
- **Group Association**: For each row, the engine checks the value of `customer_id` and associates it with the
  corresponding group. If a group for this value of `customer_id` doesn't exist yet, it's created.
- **Data Aggregation**: Once rows are grouped, aggregate functions (like `COUNT`, `SUM`, etc.) are applied to each group
  to calculate statistics or summaries.

#### Visual Example

Imagine a simplified table with the following `customer_id` values: 1, 1, 2, 3, 4, 4, 4.

- **Groups Formed**:
    - Group for `customer_id` 1: [1][1]
    - Group for `customer_id` 2:
    - Group for `customer_id` 3:
    - Group for `customer_id` 4:

Each group contains all rows where `customer_id` has the same value. Aggregate functions are then applied to these
groups to get results like the total number of orders per customer.

### Usefulness of Grouping

Grouping allows transforming raw data into meaningful information by summarizing and analyzing data according to
specific criteria. This is particularly useful for generating reports, statistics, and analyses that require an overview
of aggregated data.

### Example 2: Total Order Amount by City

```sql
SELECT customers.city, SUM(orders.amount) AS total_amount
FROM customers
         JOIN orders ON customers.id = orders.customer_id
GROUP BY customers.city;
```

Possible result:

| city       | total_amount |
|------------|--------------|
| Paris      | 350.50       |
| Lyon       | 300.75       |
| Marseille  | 120.00       |
| Toulouse   | 1000.00      |
| Nantes     | 60.00        |
| Strasbourg | 250.00       |
| Lille      | 320.00       |

### Using `HAVING`

The `HAVING` clause is used with `GROUP BY` to filter group results. Unlike `WHERE` which filters individual rows before
grouping, `HAVING` filters groups after grouping.

### Example 3: Customers with More Than One Order

```sql
SELECT customer_id, COUNT(*) AS number_of_orders
FROM orders
GROUP BY customer_id
HAVING COUNT(*) > 1;
```

Possible result:

| customer_id | number_of_orders |
|-------------|------------------|
| 1           | 2                |
| 4           | 3                |

### Example 4: Cities with a Total Order Amount Greater Than 500

```sql
SELECT customers.city, SUM(orders.amount) AS total_amount
FROM customers
         JOIN orders ON customers.id = orders.customer_id
GROUP BY customers.city
HAVING SUM(orders.amount) > 500;
```

Possible result:

```markdown
| city      | total_amount |
|-----------|--------------|
| Toulouse  | 1000.00      |
```

### Summary

- **`GROUP BY`**: Groups rows having the same values in the specified columns.
- Used with aggregate functions (`COUNT()`, `SUM()`, `AVG()`, etc.) to calculate statistics on each group.
- **`HAVING`**: Filters group results after grouping.
- `WHERE` filters individual rows before grouping, while `HAVING` filters groups after grouping.

Groupings are essential for data analysis, allowing to summarize and aggregate information meaningfully from large
datasets.



---------------

??? info "Use of AI"
    Page written in part with the help of an AI assistant, mainly using Perplexity AI. The AI was used to generate
    explanations, examples and/or structure suggestions. All information has been verified, edited and completed by the
    author.


