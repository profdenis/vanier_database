# Apartments for Rent

- You have to design a database to manage the information of a company managing
  a set of apartments for rent.
    - This company manages many buildings, each consisting of at least one
      apartment.
    - Suppose that an apartment can be uniquely identified by its number within
      its building.
    - For each apartment, there is at least one tenant, if it is rented.
    - The monthly rent and the end-of-lease date (if known) must be included.
    - For each apartment available soon, the date of availability and the asking monthly rent must be included.
    - For each tenant, the first name, last name, the home phone number, the
      name of his/her employer and his/her work phone number must be included.

- The date of availability is not always the day after the end of the previous
  lease because an apartment could be
  unavailable for some time because of renovations, for example.
- Following a similar reasoning, the asking monthly rent is not necessarily the
  same as the current rent.

# Conceptual Diagram

```plantuml

skinparam classFontSize 20
skinparam classFontName Source Code Pro
hide empty methods

@startuml

entity Apartment {
    number
    asking_rent
    available_on
}

entity Building {
    building_id
    --
    name
    address
}

entity Tenant {
    tenant_id
    --
    first_name
    last_name
    home_phone
    employer
    work_phone
}

entity Lease {
    monthly_rent
    end_of_lease
}

<> apartment_building
Apartment "1..*" -- apartment_building: > located in
apartment_building -- "1" Building
 
<> apartment_tenant
Apartment "*" -- apartment_tenant
apartment_tenant -- "*" Tenant: < rents
apartment_tenant .. Lease

@enduml
```

# Logical Diagram

```plantuml

skinparam classFontSize 20
skinparam classFontName Source Code Pro
hide empty methods

@startuml

entity Apartment {
    * number: integer
    asking_rent: numeric(10, 2)
    available_on: date
}

entity Building {
    * building_id: integer <<generated>> <<pk>>
    --
    name: text
    * address: text
}

entity Tenant {
    * tenant_id: integer <<generated>> <<pk>>
    --
    * first_name: text
    * last_name: text
    * home_phone: text
    employer
    work_phone
}

entity Lease {
    monthly_rent: numeric(10, 2)
    end_of_lease: date
}

<> apartment_building
Apartment "1..*" -- apartment_building: > located in
apartment_building -- "1" Building
 
<> apartment_tenant
Apartment "*" -- apartment_tenant
apartment_tenant -- "*" Tenant: < rents
apartment_tenant .. Lease

@enduml
```

# Physical Diagram

```plantuml

skinparam classFontSize 20
skinparam classFontName Source Code Pro
hide empty methods

@startuml

entity Apartment {
    * building_id: integer <<fk>>
    * number: integer
    asking_rent: numeric(10, 2)
    available_on: date
    --
    <<pk(building_id, number)>>
}

entity Building {
    * building_id: integer <<generated>> <<pk>>
    --
    name: text
    * address: text
}

entity Tenant {
    * tenant_id: integer <<generated>> <<pk>>
    --
    * first_name: text
    * last_name: text
    * home_phone: text
    employer
    work_phone
}

entity Lease {
    * lease_id: integer <<generated>> <<pk>>
    --
    * monthly_rent: numeric(10, 2)
    end_of_lease: date
    * tenant_id: integer <<fk>>
    * building_id: integer
    * number: integer
    --
    <<fk Apartment(building_id, number)>>
}
'keep unique constraint as an example only
'<<unique(tenant_id, building_id, number, end_of_lease)>>

Apartment "1..*" -- "1" Building: > located in

Apartment "1" -- "*" Lease
Lease "*" -- "1" Tenant: < rents


@enduml
```