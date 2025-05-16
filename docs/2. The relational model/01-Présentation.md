# Presentation

The relational model is a conceptual framework for organizing and managing data in the form of tables, also called
relations. This model was introduced by Edgar F. Codd in 1970 and has become the foundation for relational database
management systems (RDBMS), such as PostgreSQL. In this model, data is represented by tuples (rows) in relations (
tables), and operations on the data are performed using a structured query language like SQL (Structured Query
Language).

## Lexicon

1. **Relation (Table)**: A relation is a two-dimensional table composed of rows and columns. Each table represents an
   entity or a real-world concept.

2. **Attribute (Column)**: An attribute is a column in a table. Each attribute has a name and a data type (for example,
   integer, text, date).

3. **Tuple (Row)**: A tuple is a row in a table. Each tuple represents a unique record of an entity.

4. **Domain**: A domain is the set of possible values that an attribute can take. For example, the domain of an "age"
   attribute might be integers from 0 to 120.

5. **Primary Key**: A primary key is an attribute or set of attributes that uniquely identifies each tuple in a
   relation. For example, a social security number can be a primary key for a table of people.

6. **Foreign Key**: A foreign key is an attribute or set of attributes in a table that references the primary key of
   another table. This creates a relationship between the two tables.

7. **Relation Schema**: The relation schema is the structure or definition of a relation, including attribute names and
   their data types.

8. **Referential Integrity**: Referential integrity is a constraint that ensures that foreign key values correspond to
   existing primary key values in the referenced tables.

## Examples

### Example 1: Students Table

| Student_ID | Last_Name | First_Name | Age | Department       |
|------------|-----------|------------|-----|------------------|
| 1          | Dupont    | Jean       | 20  | Computer Science |
| 2          | Martin    | Sophie     | 22  | Mathematics      |
| 3          | Durand    | Pierre     | 21  | Physics          |

- **Relation**: `Students`
- **Attributes**: `Student_ID`, `Last_Name`, `First_Name`, `Age`, `Department`
- **Primary Key**: `Student_ID`

### Example 2: Courses Table

| Course_Code | Course_Name        | Credit |
|-------------|--------------------|--------|
| CS101       | Introduction to CS | 3      |
| MA101       | Calculus I         | 4      |
| PH101       | General Physics    | 4      |

- **Relation**: `Courses`
- **Attributes**: `Course_Code`, `Course_Name`, `Credit`
- **Primary Key**: `Course_Code`

### Example 3: Enrollments Table

| Student_ID | Course_Code |
|------------|-------------|
| 1          | CS101       |
| 2          | MA101       |
| 3          | PH101       |
| 1          | MA101       |

- **Relation**: `Enrollments`
- **Attributes**: `Student_ID`, `Course_Code`
- **Primary Key**: `(Student_ID, Course_Code)`
- **Foreign Keys**: `Student_ID` refers to `Students(Student_ID)`, `Course_Code` refers to `Courses(Course_Code)`

These examples show how data can be organized and interconnected in the relational model, facilitating the management
and querying of information in an efficient and consistent manner.




---------------

??? info "Use of AI"
    Page written in part with the help of an AI assistant, mainly using Perplexity AI. The AI was used to generate
    explanations, examples and/or structure suggestions. All information has been verified, edited and completed by the
    author.
