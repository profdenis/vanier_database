# Music Database

## Conceptual diagram

```plantuml
@startuml

skinparam classFontSize 16
skinparam classFontName Source Code Pro
hide empty methods

entity Writer {
number
first name
last name
address
}

entity Work {
id
title
duration
description
}

entity Publisher {
code
name
address
}

entity Act {
id
name
address
}

entity Concert {
id
date venue
}

Writer "*" -- "0..1" Publisher: > signs contract

<> writes_diamond
entity writes {
percentage
}
Writer "*" - writes_diamond
writes_diamond - "*" Work
writes .. writes_diamond

<> performed_diamond

Work "*" - performed_diamond
Act "*" -- performed_diamond 
performed_diamond -- "*" Concert
@enduml
```


## Logical diagram

```plantuml
@startuml

skinparam classFontSize 16
skinparam classFontName Source Code Pro
hide empty methods

entity Writer {
* number: integer <<generated>> <<pk>>
--
* first name: text
* last name: text
  address: text
}

entity Work {
* id: integer <<generated>> <<pk>>
--
* title: text
  duration: integer <<default 0>>
  description: text
}

entity Publisher {
* code: text <<pk>>
--
* name: text
* address: text
}

entity Act {
* id: integer <<generated>> <<pk>>
--
* name: text
  address: text
}

entity Concert {
* id: integer <<generated>> <<pk>>
--
* date: date
* venue: text
}

Writer "*" -- "0..1" Publisher: > signs contract

<> writes_diamond
entity writes {
percentage
}
Writer "*" - writes_diamond
writes_diamond - "*" Work
writes .. writes_diamond

<> performed_diamond

Work "*" - performed_diamond
Act "*" -- performed_diamond 
performed_diamond -- "*" Concert
@enduml
```


## Physical diagram

```plantuml
@startuml

skinparam classFontSize 16
skinparam classFontName Source Code Pro
hide empty methods

entity Writer {
* number: integer <<generated>> <<pk>>
--
* first name: text
* last name: text
  address: text
--
  publisher_code: text <<fk>>
}

entity Work {
* id: integer <<generated>> <<pk>>
--
* title: text
  duration: integer <<default 0>>
  description: text
}

entity Publisher {
* code: text <<pk>>
--
* name: text
* address: text
}

entity Act {
* id: integer <<generated>> <<pk>>
--
* name: text
  address: text
}

entity Concert {
* id: integer <<generated>> <<pk>>
--
* date: date
* venue: text
}

Writer "*" -- "0..1" Publisher: > signs contract

entity writes {
* percentage: float <<default 1>>
--
* writer_number: integer <<fk>>
* work_id: integer <<fk>>
--
(writer_number, work_id) <<pk>>
}
Writer "1" - "*" writes: "       "
writes "*" -- "1" Work: "       "

entity performed {
* work_id: integer <<fk>>
* act_id: integer <<fk>>
* concert_id: integer <<fk>>
--
(work_id, act_id, concert_id) <<pk>>
}
Work "1" - "*" performed: "       "
Act "1" -- "*" performed
performed "*" -- "1" Concert 

@enduml
```

