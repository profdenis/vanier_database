## Exercise #2: Books

Create an ER diagram for a Books database, based on the information given below.

### Part 1

1. A book has a title, a publication date and an ISBN number, and is written by
   one or more authors.
2. An author as a name, a phone number, and an email address.
3. A book can be self-published, or published by a publisher.
4. A publisher has a name, a phone number, an email address and a mailing
   address.

### Part 2

Add the following to the ER diagram you got in the previous part.

1. A book can have many chapters. Each chapter has a number and a title.
2. Tags can be applied to books, such as *fiction* or *non-fiction*,
   *computer science*, *statistics*, *language*, ...

### Part 3

Add the following to the ER diagram you got in the previous part.

1. A bookstore wants to sell books to customers. The books should have a retail
   price, and a sale price.
2. Customers should have a name and an email address.
3. A customer can order many books in the same order. The order should
   record the price of each book ordered, in case the book prices change
   over time.
4. Each order should have the total price (before tax and shipping), the
   shipping cost, and the grand total with shipping and taxes.

## Conceptual Diagram

```plantuml
@startuml
entity Book {
    book_id
    --
    title
    pub_date
    isbn
   
}

entity Author {
    author_id
    --
    name
    phone
    email
}

entity Publisher {
    publisher_id
    --
    name
    phone
    email
    address
}

entity Chapter {
    number
    title
}

entity Tag {
    tag_id
    --
    name
}

Book "0..*" -- "1..*" Author: written by >

Book "0..*" -- "0..1" Publisher: published by >

Book "1" *-- "0..*" Chapter

Book "*" -- "*" Tag

@enduml
```

## Logical Diagram

```plantuml
@startuml
entity Book {
    * book_id: integer <<generated>> <<pk>>
    --
    * title: text
    * pub_date: date
    isbn: text
    * retail_price: decimal(6, 2)
    sale_price: decimal(6, 2)
    * quantity: integer <<default 0>>
}

entity Author {
    * author_id: integer <<generated>> <<pk>>
    --
    * name: text
    phone: text
    email: text
}

entity Publisher {
    * publisher_id: integer <<generated>> <<pk>>
    --
    * name: text
    phone: text
    email: text
    address: text
}

entity Chapter {
    * number: integer
    * title: text
}

entity Tag {
    * tag_id: integer <<generated>> <<pk>>
    --
    * name: varchar(16)
}

Book "0..*" -- "1..*" Author: written by >

Book "0..*" -- "0..1" Publisher: published by >

Chapter "0..*" --* "1" Book

Tag "0..*" -- "0..*" Book

entity Customer {
    * customer_id: integer <<generated>> <<pk>>
    --
    * name: text
    * email: text
}

entity Order {
    * order_id: integer <<generated>> <<pk>>
    --
    * subtotal: decimal(8, 2)
    * shipping: decimal(8, 2)
    * taxes: decimal(8, 2)
    * total: decimal(8, 2)
}

entity book_order {
    * book_price: decimal(6, 2) <<default 0>>
    * book_quantity: integer <<default 1>>
}

Customer "1" -- "0..*" Order
<> book_order_diamond
Book "*" - book_order_diamond
book_order_diamond - "*" Order

book_order .. book_order_diamond

@enduml
```

## Physical Diagram

```plantuml
@startuml
entity Book {
    * book_id: integer <<generated>> <<pk>>
    --
    * title: text
    * pub_date: date
    isbn: text
    * retail_price: decimal(6, 2)
    sale_price: decimal(6, 2)
    * quantity: integer <<default 0>>
    --
    publisher_id: integer <<fk>>
}

entity Author {
    * author_id: integer <<generated>> <<pk>>
    --
    * name: text
    phone: text
    email: text
}

entity Publisher {
    * publisher_id: integer <<generated>> <<pk>>
    --
    * name: text
    phone: text
    email: text
    address: text
}

entity Chapter {
    * number: integer
    * title: text
    * book_id: integer <<fk>>
    --
    <<pk(book_id, number)>>
}

entity Tag {
    * tag_id: integer <<generated>> <<pk>>
    --
    * name: varchar(16)
}


entity book_author {
    * book_id: integer <<fk>>
    * author_id: integer <<fk>>
    --
    <<pk(book_id, author_id)>>
}

Book "1" - "   1..*" book_author
book_author "0..*" -- "1" Author

Book "0..*" -- "0..1" Publisher: published by >

Chapter "0..*" --* "1" Book

entity tag_book {
    * book_id: integer <<fk>>
    * tag_id: integer <<fk>>
    --
    <<pk(book_id, tag_id)>>
}
tag_book "0..*" - "1" Book
tag_book "0..*" -- "1" Tag


entity Customer {
    * customer_id: integer <<generated>> <<pk>>
    --
    * name: text
    * email: text
}

entity Order {
    * order_id: integer <<generated>> <<pk>>
    --
    * subtotal: decimal(8, 2)
    * shipping: decimal(8, 2)
    * taxes: decimal(8, 2)
    * total: decimal(8, 2)
    --
    * customer_id: integer <<fk>
}

entity book_order {
    * book_price: decimal(6, 2) <<default 0>>
    * book_quantity: integer <<default 1>>
    --
    * book_id: integer <<fk>>
    * order_id: integer <<fk>>
    --
    <<pk(book_id, order_id)>>
}

Customer "1" -- "0..*" Order

Book "1" - "*" book_order
book_order "*" -- "1" Order


@enduml
```