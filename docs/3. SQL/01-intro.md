# 1 - Introduction to SQL

SQL (Structured Query Language) is a standardized programming language used to manage and manipulate relational
databases. It allows for various operations such as creating, modifying, deleting, and retrieving data in a database.
SQL is essential for interacting with relational database management systems (RDBMS) like PostgreSQL, MySQL, Oracle, and
SQL Server[1][2][4].

## History of SQL

SQL was developed in the early 1970s by IBM researchers Donald D. Chamberlin and Raymond F. Boyce as part of the System
R project, which aimed to demonstrate the feasibility of relational databases. The language was initially called
SEQUEL (Structured English Query Language) before being renamed SQL[4][5]. In 1986, the American National Standards
Institute (ANSI) published the first SQL standard, followed by the International Organization for Standardization (ISO)
in 1987[3][4][5]. Since then, SQL has evolved with several revisions and extensions to meet the growing needs of modern
databases.

## Overview of ISO Standards

ISO standards for SQL define the specifications and functionalities of the language to ensure interoperability between
different database systems. Here are some of the key versions:

- **SQL-86**: The first SQL standard published by ANSI in 1986 and adopted by ISO in 1987[3][4].
- **SQL-89**: A minor revision of SQL-86, introducing some improvements and corrections.
- **SQL-92**: A major version that added numerous features, including subqueries, outer joins, and integrity
  constraints[4].
- **SQL:1999 (SQL3)**: Introduction of user-defined data types, stored procedures, and recursive query language.
- **SQL:2003**: Addition of XML functions, derived tables, and windowed data types.
- **SQL:2008**: Improvements to existing features and addition of new ones, such as common table expressions (CTE).
- **SQL:2011**: Introduction of temporal data processing features.
- **SQL:2016**: Addition of JSON features and new extensions for geospatial data types.

## Principles of a Non-Procedural Language

SQL is a non-procedural language, which means that the user specifies **what they want** to obtain without detailing *
*how** the system should obtain it[5]. Here are some key principles:

1. **Declaration of Intentions**: In SQL, you declare your intentions in terms of desired results. For example, a SELECT
   query indicates which columns and rows you want to retrieve, but not how to retrieve them[3].

2. **Implementation Abstraction**: Implementation details, such as sorting algorithms or data access paths, are managed
   by the RDBMS. The user doesn't need to know these details[2].

3. **Automatic Optimization**: RDBMSs automatically optimize queries to improve performance. The user focuses on query
   logic rather than optimization[2].

4. **Ease of Use**: Non-procedural language is generally easier to learn and use for end users, as it focuses on results
   rather than processes[5].

5. **Portability**: SQL queries are portable between different database systems, as long as they adhere to ISO
   standards, which facilitates migration and interoperability[4].

## Example of an SQL Query

```sql
SELECT Name, FirstName, Age
FROM Students
WHERE Department = 'Computer Science';
```

This query selects the Name, FirstName, and Age columns from the Students table for students belonging to the Computer
Science department, without specifying how the RDBMS should access or sort the data[3][6].

In summary, SQL is a powerful and flexible language for interacting with relational databases, offering an abstraction
that allows users to focus on desired results rather than implementation details[2][5].

??? note "References"
    [1] https://aws.amazon.com/what-is/sql/
    [2] https://www.techtarget.com/searchdatamanagement/definition/SQL
    [3] https://www.w3schools.com/sql/sql_intro.asp
    [4] https://en.wikipedia.org/wiki/SQL
    [5] https://www.atscale.com/glossary/sql/
    [6] https://www.secoda.co/learn/mastering-basic-sql-database-operations-create-read-update-delete
    [7] https://learn.microsoft.com/en-us/rest/api/sql/database-operations/list-by-database?view=rest-sql-2023-08-01
    [8] https://www.spiceworks.com/tech/artificial-intelligence/articles/what-is-sql/
    [9] https://learn.microsoft.com/en-us/sql/t-sql/lesson-1-creating-database-objects?view=sql-server-ver16
    [10] https://courses.cs.washington.edu/courses/cse100/09wi/lectures/23-DatabaseOperations.pdf
    [11] https://azure.microsoft.com/en-us/resources/cloud-computing-dictionary/what-is-sql-database
    [12] https://www.w3schools.com/sql/
    [13] https://www.w3schools.com/sql/sql_operators.asp
    [14] https://opentextbc.ca/dbdesign01/chapter/sql-structured-query-language/
    [15] https://www.youtube.com/watch?v=7mz73uXD9DA
    [16] https://www.devart.com/dbforge/sql/sqlcomplete/crud-operations-in-sql.html
    [17] https://www.ibm.com/think/topics/structured-query-language
    [18] https://learn.microsoft.com/en-us/sql/sql-server/tutorials-for-sql-server-2016?view=sql-server-ver16
    [19] https://www.w3schools.com/sql/sql_examples.asp
    [20] https://www.datacamp.com/blog/all-about-sql-the-essential-language-for-database-management



---------------

??? info "Use of AI"
    Page written in part with the help of an AI assistant, mainly using Perplexity AI. The AI was used to generate
    explanations, examples and/or structure suggestions. All information has been verified, edited and completed by the
    author.
    