# More on diagrams

- There are different types of ERDs:
    - **conceptual**
    - **logical**
    - **physical**
- *Conceptual* and *logical* models don't have foreign keys in them. There
  are relationships, that will end up being converted to foreign keys, and maybe
  tables, at a later stage, usually in the physical models.
- *Conceptual* models are very basic, without data types and constraints.
- Data types and constraints are usually added to the *logical* models.
- Relationships are translated to tables and foreign keys in the *physical*
  models. The diagrams produced by Datagrip can be considered *physical* models,
  reversed-engineered from an existing database.

## PlantUML ERD examples

### Contact Database

#### Basic diagram (Conceptual)

```plantuml
@startuml
entity Contact {
    contact_id
    --
    name
    phone
    address
    email
}

entity Call {
    call_id
    --
    phone
    datetime
}

Call "*" -- "0..1" Contact : "            "
@enduml
```

### With data types and constraints (Logical)

The circle before a column name means **mandatory**, and the absence of such a circle means **optional**.

```plantuml
@startuml
entity Contact {
    * contact_id: integer <<generated>> <<pk>>
    --
    * name: text
    phone: text
    address: text
    email: text
}

entity Call {
    * call_id: integer <<generated>> <<pk>>
    --
    * phone: text
    * datetime: datetime
}

Call "*" -- "0..1" Contact : > from  
@enduml
```

### With Foreign Keys (Physical)

```plantuml
@startuml
entity Contact {
    * contact_id: integer <<generated>> <<pk>>
    --
    * name: text
    phone: text
    address: text
    email: text
}

entity Call {
    * call_id: integer <<generated>> <<pk>>
    --
    * phone: text
    * datetime: datetime
    --
    contact_id: integer <<fk>>
}

Call "*" -- "0..1" Contact : from >

@enduml
```


## College Database

### Conceptual

```plantuml
@startuml
entity Student {
    id
    --
    name
    phone
}

entity Lecturer {
    id
    --
    name
    office
    rank
    phone
}

entity Course {
    code
    --
    name
    credits
}

entity Grade {
    id
    --
    result
    year
    semester
}

Student "*" -- "0..1" Lecturer: < advises
Student "1" - "*" Grade: < given to
Course "1" -- "*" Grade: < given for
Lecturer "   1" - "   *" Grade: < given by
@enduml
```

### Logical

```plantuml
@startuml
entity Student {
    * student_id: integer <<generated>> <<pk>>
    --
    * name: text
    phone: text
}

entity Lecturer {
    * lecturer_id: integer <<generated>> <<pk>>
    --
    * name: text
    office: text
    * rank: text
    phone: text
}

entity Course {
    * course_code: text <<pk>>
    --
    * name: text
    * credits: text <<default 0>>
}

entity Grade {
    * grade_id: integer <<generated>> <<pk>>
    --
    * result: integer
    * year: integer
    * semester: integer
}

Student "*" -- "0..1" Lecturer: < advises
Student "1" - "*" Grade: < given to
Course "1" -- "*" Grade: < given for
Lecturer "   1" - "   *" Grade: < given by
@enduml
```


### Physical

```plantuml
@startuml
entity Student {
    * student_id: integer <<generated>> <<pk>>
    --
    * name: text
    phone: text
    --
    adviser_id: integer <<fk Lecturer>>
}

entity Lecturer {
    * lecturer_id: integer <<generated>> <<pk>>
    --
    * name: text
    office: text
    * rank: text
    phone: text
}

entity Course {
    * course_code: text <<pk>>
    --
    * name: text
    * credits: text <<default 0>>
}

entity Grade {
    * grade_id: integer <<generated>> <<pk>>
    --
    * result: integer
    * year: integer
    * semester: integer
    --
    * student_id: integer <<fk>>
    * course_code: text <<fk>>
    * lecturer_id: integer <<fk>>
}

Student "*" -- "0..1" Lecturer: < advises
Student "1" - "*" Grade: < given to
Course "1" -- "*" Grade: < given for
Lecturer "   1" - "   *" Grade: < given by
@enduml
```