## Exercise #1: Blog

Create an ER diagram for the database of a Blog application, based on the information given below.

### Part 1

1. A blog post should be written by a user.
2. A blog post should have an ID, a title, contents, and a posted date.
3. A user should have a nick name (unique among all the users) and an email address.
4. Blog posts should be organized into topics. There can be many topics per blog post.
5. A topic should have an ID, a name, and a description.

### Part 2

Add the following to the ER diagram you got in the previous part.

1. Users can leave comments on blog posts, and reply to other comments.
2. A comment must be posted by a user (no anonymous comments allowed), and must
   be associated to a blog post or another comment (the parent comment).
3. A comment must have an ID, contents (the comment's text), and a date.

## Conceptual diagram

```plantuml
@startuml

entity BlogPost {
    id
    --
    title
    contents
    posted
}

entity User {
    id
    --
    nickname
    email
}

entity Topic {
    id
    --
    name
    description
}

entity Comment {
    id
    --
    contents
    posted
}

BlogPost " *  " -- "1" User: > written by
BlogPost "*" -- "*" Topic: > organized into

User "1" - "*" Comment: < posted by
BlogPost "0..1" -- "*" Comment

'<> comment_diamond
Comment "0..1" -- "*" Comment: parent <
'Comment "0..1" -- comment_diamond
'comment_diamond -- "*" Comment: parent <
@enduml
```

## Logical diagram

```plantuml
@startuml

entity BlogPost {
    * blogpost_id: integer <<generated>> <<pk>>
    --
    * title: text
    * contents: text
    * posted: date <<default today>>
}

entity User {
    * user_id: integer <<generated>> <<pk>>
    --
    * nickname: varchar(16) <<unique>>
    * email: text
}

entity Topic {
    * topic_id: integer <<generated>> <<pk>>
    --
    * name: text
    description: text
}

entity Comment {
    * comment_id: integer <<generated>> <<pk>>
    --
    * contents: text
    * posted: datetime <<default now>>
}

BlogPost " *  " -- "1" User: > written by
BlogPost "*" -- "*" Topic: > organized into

User "1" - "*" Comment: < posted by
BlogPost "0..1" -- "*" Comment

'<> comment_diamond
Comment "0..1" -- "*" Comment: parent <
'Comment "0..1" -- comment_diamond
'comment_diamond -- "*" Comment: parent <
@enduml
```

## Physical diagram

```plantuml
@startuml

entity BlogPost {
    * blogpost_id: integer <<generated>> <<pk>>
    --
    * title: text
    * contents: text
    * posted: date <<default today>>
    --
    * user_id: integer <<fk>>
}

entity User {
    * user_id: integer <<generated>> <<pk>>
    --
    * nickname: varchar(16) <<unique>>
    * email: text
}

entity Topic {
    * topic_id: integer <<generated>> <<pk>>
    --
    * name: text
    description: text
}

entity Comment {
    * comment_id: integer <<generated>> <<pk>>
    --
    * contents: text
    * posted: datetime <<default now>>
    --
    * user_id: integer <<fk>>
    blogpost_id: integer <<fk>>
    parent_id: integer <<fk Comment>>
}

entity blogpost_topic {
    * blogpost_id: integer <<fk>>
    * topic_id: integer <<fk>>
    --
    <<pk (blogpost_id, topic_id)>>
}

BlogPost "*" -- "1" User: > written by

BlogPost "1" - "*" blogpost_topic: > organized into
blogpost_topic "*" -- "1  " Topic

User "1" - "*" Comment: < posted by
BlogPost "0..1" -- "*" Comment

'<> comment_diamond
Comment "0..1" -- "*" Comment: parent <
'Comment "0..1" -- comment_diamond
'comment_diamond -- "*" Comment: parent <
@enduml
```