# History of Databases

## 1960s: The Beginning

### File Systems

- **Sequential Storage**: The first data management systems used sequential files to store information. Data was
  recorded in a specific order, making search and update operations slow and inefficient.

### Hierarchical Databases

- **IMS (Information Management System)**: Developed by IBM in 1966, IMS is one of the first hierarchical database
  management systems (DBMS). Data is organized in a tree structure, with parent and child records[5].

#### Example of Hierarchical Structure

```
Company
│
├── Department A
│   ├── Employee 1
│   └── Employee 2
│
└── Department B
    ├── Employee 3
    └── Employee 4
```

## 1970s: The Era of Relational Databases

### Relational Model

- **Edgar F. Codd**: In 1970, Edgar F. Codd, a researcher at IBM, proposed the relational model in his paper "A
  Relational Model of Data for Large Shared Data Banks". This model organizes data in tables (relations) and uses keys
  to establish relationships between tables[5][10][12].

### Relational DBMSs

- **System R**: IBM developed System R in the 1970s to demonstrate the feasibility of the relational model. This project
  led to the creation of SQL (Structured Query Language)[5].
- **Ingres**: Another major research project, Ingres, was developed at the University of California, Berkeley, and also
  contributed to the popularization of relational databases. This system would later evolve into Postgres and eventually
  PostgreSQL[5].

## 1980s: Commercialization and Standardization

### Commercial DBMSs

- **Oracle**: Founded in 1977, Oracle Corporation launched its first commercial relational DBMS in 1979. Oracle quickly
  became a leader in the database field[5].
- **IBM DB2**: In 1983, IBM launched DB2, a relational DBMS based on System R research[5].
- **Microsoft SQL Server**: Launched in 1989, SQL Server became a major player in the relational database field.

### SQL Standardization

- **ANSI SQL**: In 1986, the American National Standards Institute (ANSI) published the first SQL standard,
  standardizing the query language for relational databases.

## 1990s: Evolution and Diversification

### Object-Oriented Databases

- **Emergence**: Object-oriented databases gained popularity for managing complex data and programming objects[5].
- **db4o and ObjectDB**: Examples of object-oriented DBMSs that appeared during this period.

### Distributed Databases

- **Scalability**: Distributed databases were developed to allow data distribution across multiple servers, thus
  improving scalability and fault tolerance.

## 2000s: The Rise of NoSQL Databases

### Big Data

- **Data Explosion**: With the rise of the internet and web applications, the volume of data exploded, requiring new
  approaches to data management.

### NoSQL Databases

- **MongoDB**: Launched in 2009, MongoDB is a document database that allows storing semi-structured data[4].
- **Cassandra**: Developed by Facebook, Cassandra is a distributed column database, designed to manage large amounts of
  data across multiple servers.
- **Redis**: An in-memory database, used for applications requiring high performance[4].

## 2010s to Today: New Trends and Technologies

### In-Memory Databases

- **Performance**: In-memory databases, such as Redis and Memcached, are gaining popularity for applications requiring
  ultra-fast response times[4].

### Multi-Model Databases

- **Flexibility**: Multi-model databases, such as ArangoDB and OrientDB, allow combining multiple data models (
  relational, document, graph) in the same DBMS.

### Cloud and Database as a Service (DBaaS)

- **Accessibility**: Cloud database services, such as Amazon RDS, Google Cloud SQL, and Azure SQL Database, allow
  companies to deploy and manage databases without having to worry about the underlying infrastructure.

## Conclusion

The history of databases is marked by constant evolution, responding to growing needs for storage, management, and data
access. From the first hierarchical systems to relational databases, through NoSQL databases and in-memory solutions,
each step has brought significant innovations. Today, databases continue to evolve to meet the challenges of Big Data,
the Internet of Things (IoT), and real-time applications.

??? note "References"
    [1] https://www.quickbase.com/articles/timeline-of-database-history
    [2] https://s2.smu.edu/~fmoore/timeline.pdf
    [3] https://www.thinkautomation.com/histories/the-history-of-databases
    [4] https://www.linkedin.com/pulse/timeline-databases-darren-culbreath
    [5] https://en.wikipedia.org/wiki/Database
    [6] https://fr.wikipedia.org/wiki/Mod%C3%A8le_relationnel
    [7] https://dbs.academy.lv/lection/dbs_LS02ENa_hist.pdf
    [8] https://fr.wikipedia.org/wiki/Edgar_Frank_Codd
    [9] https://www.dataversity.net/brief-history-database-management/
    [10] https://www.historyofinformation.com/detail.php?id=94
    [11] https://www.cockroachlabs.com/blog/history-of-databases-distributed-sql/
    [12] https://www.techno-science.net/definition/7438.html
    [13] https://librecours.net/modules/bdd/relationnel/solpdf?contentName=relationnel.pdf
    [14] https://cours.ebsi.umontreal.ca/sci6005/h2022/co/sgbd_modele_relationnel.html
    [15] https://www.seas.upenn.edu/~zives/03f/cis550/codd.pdf
    [16] https://www.decideo.fr/glossary/Codd-Dr-Edgar-F_gw93.html
    [17] https://www.ibm.com/history/edgar-codd




---------------

??? info "Use of AI"
    Page written in part with the help of an AI assistant, mainly using Perplexity AI. The AI was used to generate
    explanations, examples and/or structure suggestions. All information has been verified, edited and completed by the
    author.
