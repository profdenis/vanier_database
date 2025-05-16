# 2a - Contact Database

- Think of a contact database on a phone
- 2 tables:
    - `contact(CONTACT_ID, name, phone, address, email)`
    - `call(CALL_ID, phone, date, time, contact_id*)`

## Creating the Contact Database

1- Run the [contact_create.sql](../src/create/contact_create.sql) file to create the database

- the SQL commands included in this file will be explained later
- open the file in DataGrip and run it in an existing session or create a new session

2- To check the results, you can use the *Database Explorer* tab or run the following queries:

```sql
SELECT *
FROM contacts.contact;

SELECT *
FROM contacts.call;
```

3- To avoid prefixing table names with the schema name each time, we can run the following command:

```sql
SET
search_path TO contacts;

SELECT *
FROM contact;

SELECT *
FROM call;
```

## Queries on a Single Table

1- Find John Doe's email address

```sql
SELECT email
FROM contact
WHERE name = 'John Doe';
```

2- Find contacts without a phone number

```sql
SELECT *
FROM contact
WHERE phone IS NULL;
```

3- Find contacts with a phone number

```sql
SELECT *
FROM contact
WHERE phone IS NOT NULL;
```

### With Aggregate Functions

4- Count the number of rows in the `call` table

```sql
SELECT COUNT(*)
FROM call;
```

5- Count the number of rows in the `call` table with non-null values for `contact_id`

```sql
SELECT COUNT(contact_id)
FROM call;
```

6- Count the number of rows in the `call` table with null values for `contact_id`

```sql
SELECT COUNT(*)
FROM call
WHERE contact_id IS NULL;
```

