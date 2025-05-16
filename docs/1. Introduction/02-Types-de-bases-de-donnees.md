# Database Types

There are several types of databases, each designed to meet specific needs. Here's an overview of the main types of databases used today:

## 1. Relational Databases

### Description

Relational databases organize data in tables that can be linked together through primary and foreign keys. They use SQL (Structured Query Language) for data management and manipulation.

### Examples

- **PostgreSQL**: A powerful and extensible open-source relational (and object-relational) DBMS.
- **MySQL**: A popular open-source relational DBMS, often used for web applications.
- **Oracle Database**: A commercial relational (and object-relational) DBMS with many advanced features.
- **Microsoft SQL Server**: A relational DBMS developed by Microsoft, often used in Windows environments.

### Advantages

- **Clear structure**: Data is organized in a logical and coherent manner.
- **Data integrity**: Constraints and integrity rules ensure data accuracy and consistency.
- **Complex queries**: SQL allows for complex queries to extract specific information.

## 2. Object-Relational Databases

### Description

Object-relational databases combine aspects of relational databases and object-oriented databases. They allow storing data in tables while supporting object-oriented programming concepts such as custom data types, table inheritance, and methods.

### Examples

- **PostgreSQL**: An open-source object-relational DBMS that supports advanced features like custom data types and table inheritance[5].
- **Oracle Database**: Offers object-relational features in addition to its relational capabilities[5].

### Advantages

- **Flexibility**: Combines the advantages of relational and object-oriented databases.
- **Extensibility**: Allows creating custom data types and methods[5].
- **Compatibility**: Maintains compatibility with SQL while offering advanced features.

## 3. NoSQL Databases

### Description

NoSQL databases are designed for specific needs that are not well supported by relational databases. They are often used for applications requiring high scalability and performance.

### Types of NoSQL Databases

- **Document databases**: Store data as JSON or BSON documents. Example: MongoDB[5].
- **Column databases**: Store data in columns rather than rows. Example: Apache Cassandra.
- **Graph databases**: Use graph structures to represent and store data. Example: Neo4j.
- **Key-value databases**: Store data as key-value pairs. Example: Redis[5].

### Advantages

- **Scalability**: Designed to handle large amounts of data and high workloads.
- **Flexibility**: Allow storing unstructured or semi-structured data.
- **Performance**: Optimized for fast read and write operations.

## 4. In-Memory Databases

### Description

In-memory databases store data directly in random access memory (RAM), allowing for very fast access times. They are often used for applications requiring high real-time performance.

### Examples

- **Redis**: An open-source in-memory database often used for caching and session management[5].
- **Memcached**: A distributed in-memory caching system, used to speed up web applications by reducing database load.

### Advantages

- **Performance**: Extremely fast data access.
- **Real-time**: Ideal for applications requiring real-time responses.

## 5. Object-Oriented Databases

### Description

Object-oriented databases store data as objects, similar to object-oriented programming. They allow storing complex objects with their methods and attributes.

### Examples

- **db4o**: An open-source object-oriented database.
- **ObjectDB**: An object-oriented database for Java.

### Advantages

- **Correspondence with object-oriented programming**: Facilitates the transition between in-memory objects and stored objects.
- **Data complexity**: Allows storing complex data structures.

## Conclusion

Each type of database has its own advantages and disadvantages, and the choice of database type depends on the specific needs of the application. In this course, we will primarily focus on relational databases and the use of PostgreSQL, but it's important to know about other types of databases and their use cases.

??? note "References"
    [1] https://www.altexsoft.com/blog/comparing-database-management-systems-mysql-postgresql-mssql-server-mongodb-elasticsearch-and-others/
    [2] https://www.prisma.io/dataguide/intro/comparing-database-types
    [3] https://en.wikipedia.org/wiki/Comparison_of_relational_database_management_systems
    [4] https://db-engines.com/en/ranking
    [5] https://www.integrate.io/blog/which-database/
    [6] https://bytescout.com/blog/mysql-vs-postgresql-vs-oracle.html
    [7] https://www.digitalocean.com/community/tutorials/sqlite-vs-mysql-vs-postgresql-a-comparison-of-relational-database-management-systems
    [8] https://severalnines.com/blog/basic-administration-comparison-between-oracle-mssql-mysql-postgresql/
    [9] https://www.datasciencecentral.com/decoding-different-types-of-databases-a-comparison/
    [10] https://www.reddit.com/r/SQL/comments/spxzfh/ms_sql_server_mysql_oracle_dba_postgresql_which/
    [11] https://docs.syteca.com/view/comparison-of-database-types
    [12] https://db-engines.com/en/system/Microsoft+SQL+Server;Oracle;PostgreSQL
    [13] https://db-engines.com/en/system/MySQL;Oracle;PostgreSQL




---------------

??? info "Use of AI"
    Page written in part with the help of an AI assistant, mainly using Perplexity AI. The AI was used to generate
    explanations, examples and/or structure suggestions. All information has been verified, edited and completed by the
    author.
