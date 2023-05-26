# Music Copyrights Database

- You are asked to design a music copyright collection agency database,
  including information as follows:
    1. A writer has a writer number, first name, last name and address.
    2. Writers may be signed with a publisher. Publishers sign up many writers.
    3. Publishers have a publisher code, name and address.
    4. Writers write works. Works may have more than one writer. Each writer writes a percentage of a work.
    5. A work has a title, duration and description.
    6. Works get performed at concerts (or music shows) by an act.


# Conceptual Diagram

```plantuml
@startuml

hide empty methods

entity Writer {
    number
    --
    first_name
    last_name
    address
}

entity Publisher {
    code
    --
    name
    address
}

entity Work {
    id
    --
    title
    duration
    description
}

entity Writes {
    percentage
}

entity Act {
    id
    --
    name
    email
}

entity Concert {
    id
    --
    venue
    date
}

entity Performer {
    id
    --
    name
}

Writer "*" -- "0..1" Publisher

<> writes_diamond
Writer "1..*" - writes_diamond: writes > 
writes_diamond - "   *" Work
Writes .. writes_diamond

<> performed_diamond
Work "*" -- performed_diamond
performed_diamond - "*" Act
Concert "*" - performed_diamond

Act "*" -- "1..*" Performer
@enduml
```

# Logical Diagram

```plantuml
@startuml

hide empty methods

entity Writer {
    * number: integer <<generated>> <<pk>>
    --
    * first_name: text
    * last_name: text
    address: text
}

entity Publisher {
    * code: integer <<generated>> <<pk>>
    --
    * name: text
    * address: text
}

entity Work {
    * id: integer <<generated>> <<pk>>
    --
    * title: text
    * duration: time
    description: text
}

entity Writes {
    * percentage: float <<default 100>>
}

entity Act {
    * id: integer <<generated>> <<pk>>
    --
    * name: text
    email: text
}

entity Concert {
    * id: integer <<generated>> <<pk>>
    --
    * venue: text
    * date: date
    * start_time: time <<default 19:00>>
}

entity Performer {
    * id: integer <<generated>> <<pk>>
    --
    * name: text
}

Writer "*" -- "0..1" Publisher

<> writes_diamond
Writer "1..*" - writes_diamond: writes > 
writes_diamond - "   *" Work
Writes .. writes_diamond

<> performed_diamond
Work "*" -- performed_diamond
performed_diamond - "*" Act
Concert "*" - performed_diamond

Act "*" -- "1..*" Performer
@enduml
```

# Physical Diagram

```plantuml
@startuml

hide empty methods

entity Writer {
    * number: integer <<generated>> <<pk>>
    --
    * first_name: text
    * last_name: text
    address: text
    --
    publisher_code: integer <<fk>>
}

entity Publisher {
    * code: integer <<generated>> <<pk>>
    --
    * name: text
    * address: text
}

entity Work {
    * id: integer <<generated>> <<pk>>
    --
    * title: text
    * duration: time
    description: text
}

entity writer_work {
    * writer_number: integer <<fk>>
    * work_id: integer <<fk>>
    --
    * percentage: float <<default 100>>
}

entity Act {
    * id: integer <<generated>> <<pk>>
    --
    * name: text
    email: text
}

entity Concert {
    * id: integer <<generated>> <<pk>>
    --
    * venue: text
    * date: date
    * start_time: time <<default 19:00>>
}

entity Performer {
    * id: integer <<generated>> <<pk>>
    --
    * name: text
}

Writer "*" -- "0..1" Publisher



Writer "1" - "       *" writer_work
writer_work "1..*  " -- "    1" Work

entity performed {
    * work_id: integer <<fk>>
    * concert_id: integer <<fk>>
    * act_id: integer <<fk>>
}
Work "1" -- "*" performed
performed "*" - "     1     " Act
Concert "1" - "*" performed

entity act_performer {
    * act_id: integer <<fk>>
    * performer_id: integer <<fk>>
}

Act "1" -- "1..*" act_performer
act_performer "*" -- "1" Performer
@enduml
```