## Traditional Entity-Relationship Diagram Notation for arrow heads

**Note**: cannot easily include diamonds for relationships with PlantUML, but we
can name the relationships with a label. Labels are not used in the first
diagram because of the note boxes close to the relationships. The second diagram
shows relationship labels instead of note boxes.

We usually include note boxes only in some cases, not on all relationships. It
is often recommend to label the relationships to clarify their purpose or
meaning, not only using the traditional ERD notation, but also with the other
notations.

### Diagram without labels

```plantuml
@startuml
T1 -- T2
note on link: many-many\nbetween T1 and T2

T2 --> T3
note on link: many-one\nfrom T2 to T3

T3 --|> T4
note on link: many-exactly-one\nfrom T3 to T4

T2 <-> T5
note on link: one-one\nbetween T2 and T5

T5 <|--|> T6
note on link: exactly-one--exactly-one\nbetween T5 and T6
@enduml
```

### Diagram with labels

We can include < or > in the labels to help read the relationship more easily.
It's not very useful in this generic example, but it will be useful in the
specific examples.

```plantuml
@startuml
T1 -- T2: rel_1

T2 --> T3: rel_2 >

T3 --|> T4: rel_3 >

T2 <-> T5: < rel_4

T5 <|--|> T6: rel_5
@enduml
```

## Using cardinalities (or multiplicities) instead

**Notes**:

- `*` may be replaced by `n`, or sometimes `m`.
- This is the preferred notation, with labels added on the relationships as
  needed.

```plantuml
@startuml
T1 "*" -- "*" T2
note on link: many-many\nbetween T1 and T2

T2 "*" -- "0..1" T3
note on link: many-one\nfrom T2 to T3

T3 "*" -- "1" T4
note on link: many-exactly-one\nfrom T3 to T4

T2 "0..1" - "0..1" T5
note on link: one-one\nbetween T2 and T5

T5 "1" -- "1" T6
note on link: exactly-one--exactly-one\nbetween T5 and T6

T3 "1..*" - "1..*" T6
note on link: at-least-one--at-least-one\nbetween T3 and T6
@enduml
```

## Crow-foot notation

```plantuml
@startuml

T1 }o--o{ T2
note on link: many-many\nbetween T1 and T2

T2 }o--o| T3
note on link: many-one\nfrom T2 to T3

T3 }o--|| T4
note on link: many-exactly-one\nfrom T3 to T4

T2 |o-o|  T5
note on link: one-one\nbetween T2 and T5

T5 ||--|| T6
note on link: exactly-one-exactly-one\nbetween T5 and T6

T3 }|-|{ T6
note on link: at-least-one-at-least-one\nbetween T3 and T6
@enduml
```