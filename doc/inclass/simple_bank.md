# Simple Bank Database

- The database application called BANK, which keeps track of a Bank’s customers
  and their accounts.
    - Customers are identified by their name, address, phone and customer ID.
    - Accounts have numbers, types (e.g., savings, checking) and balances.
    - Also record the customer(s) who own an account.
    - A transaction takes place on exactly one account.
    - Each transaction has an ID, a code, an amount, a date, a time and a
      description.


## Conceptual diagram

```plantuml
@startuml
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

Customer "1..*" -- " *  " Account: > owns
Transaction " *  " -- "1" Account: > takes place

@enduml
```

## Logical diagram

```plantuml
@startuml
entity Customer {
    * customer_id: integer <<generated>> <<pk>>
    --
    * name: text
    * address: text
    * phone: text
}

entity Account {
    * number: integer <<generated>> <<pk>>
    --
    * type: text
    * balance: numeric(12, 2)
}

entity Transaction {
    * transaction_id: integer <<generated>> <<pk>>
    --
    * code: char(3)
    * amount: numeric(12, 2)
    * datetime: datetime
    description: text
}

Customer "1..*" -- " *  " Account: > owns
Transaction " *  " -- "1" Account: > takes place

@enduml
```

Comments:
- asedfsdf 
- sdf sdf