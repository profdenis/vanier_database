# Simple Bank Database

- The database application called BANK, which keeps track of a Bank’s customers and their accounts.
    - Customers are identified by their name, address, phone and customer ID.
    - Accounts have numbers, types (e.g., savings, checking) and balances.
    - Also record the customer(s) who own an account.
    - A transaction takes place on exactly one account.
    - Each transaction has an ID, a code, an amount, a date, a time and a description.

## Conceptual Model

```plantuml
@startuml

skinparam classFontSize 20
skinparam classFontName Source Code Pro
hide empty methods

entity Customer {
    customer_id
    --
    name
    address
    phone
}

entity Account {
    number
    --
    type
    balance
}

entity Transaction {
    transaction_id
    --
    code
    amount
    date
    time
    description
}

Customer "*" -- "*" Account: > own
Transaction "*" -- "1" Account: > takes place
@enduml
```

```plantuml
@startuml

skinparam classFontSize 20
skinparam classFontName Source Code Pro
hide empty methods

entity Customer {
    customer_id
    --
    name
    address
    phone
}

entity Account {
    number
    --
    type
    balance
}

entity Transaction {
    transaction_id
    --
    code
    amount
    date
    time
    description
}

<> own_diamond
Customer "*" -- own_diamond
own_diamond --"*" Account: > own

<> takes_place_diamond
Transaction "*" -- takes_place_diamond
takes_place_diamond --"1" Account: > takes place
@enduml
```

## Logical Model

```plantuml
@startuml

skinparam classFontSize 20
skinparam classFontName Source Code Pro
hide empty methods

entity Customer {
    * customer_id: integer <<generated>> <<pk>>
    --
    * name: text
    * address: text
    * phone: text
}

entity Account {
    number
    --
    type
    balance
}

entity Transaction {
    transaction_id
    --
    code
    amount
    date
    time
    description
}

Customer "*" -- "*" Account: > own
Transaction "*" -- "1" Account: > takes place
@enduml
```