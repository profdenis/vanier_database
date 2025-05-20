create schema trigger_examples;
set search_path to trigger_examples;

create table contact
(
    contact_id   integer generated always as identity primary key,
    email        text,
    phone        text,
    street       text,
    city         text,
    province     text,
    country      text,
    created      timestamp with time zone default now() not null,
    last_updated timestamp with time zone default now() not null,
    check (email is not null or phone is not null or
           (street is not null and city is not null
               and province is not null and country is not null))
);

create table person
(
    person_id    integer generated always as identity primary key,
    first_name   text                                    not null,
    last_name    text                                    not null,
    contact_id   integer references contact (contact_id) not null,
    created      timestamp with time zone default now()  not null,
    last_updated timestamp with time zone default now()  not null
);

-- last_updated: function and trigger
create function last_updated() returns trigger
    language plpgsql
as
$$
BEGIN
    NEW.last_updated = CURRENT_TIMESTAMP;
    RETURN NEW;
END
$$;

create trigger last_updated
    before update
    on contact
    for each row
execute function last_updated();

create trigger last_updated
    before update
    on person
    for each row
execute function last_updated();

-- name changes
create table person_audits
(
    id         integer generated always as identity primary key,
    person_id  integer references person(person_id)   not null,
    first_name text                                   not null,
    last_name  text                                   not null,
    changed_on timestamp with time zone default now() not null
);


create or replace function log_name_changes()
    returns trigger
    language PLPGSQL
as
$$
BEGIN
    IF NEW.first_name <> OLD.first_name OR NEW.last_name <> OLD.last_name THEN
        INSERT INTO person_audits(person_id, first_name, last_name)
        VALUES (OLD.person_id, OLD.first_name, OLD.last_name);
    END IF;

    RETURN NEW;
END;
$$;

create trigger name_changes
    before update
    on person
    for each row
execute procedure log_name_changes();


-- insert and update rows
insert into contact(email, phone)
values ('denis@example.com', '111-111-1111');
insert into contact(street, city, province, country)
values ('555 Rue Notre-Dame', 'Montréal', 'Québec', 'Canada');

insert into person(first_name, last_name, contact_id)
values ('Denis', 'Rinfret', 1);

update contact
set phone = '222-222-2222'
where contact_id = 1;

update person
set contact_id = 2
where person_id = 1;

update person
set last_name = 'Vanier'
where person_id = 1;


-- errors
insert into contact(street, city, province, country)
values ('555 Rue Notre-Dame', 'Montréal', 'Québec', null);

update contact
set country = null
where contact_id = 2;

update person
set contact_id = 1000
where person_id = 1;

update person
set first_name = null
where person_id = 1;

-- error or not?
update person
set first_name = ''
where person_id = 1;


-- employees and customers
create table employee
(
    employee_id integer generated always as identity primary key,
    position    text                                  not null,
    person_id   integer references person (person_id) not null
);

create table customer
(
    customer_id integer generated always as identity primary key,
    points      integer default 0 check ( points >= 0 ) not null,
    person_id   integer references person (person_id)  not null
);

insert into employee(person_id, position)
values (1, 'teacher');

insert into person (first_name, last_name, contact_id)
values ('John', 'Doe', 2);

insert into customer(person_id)
values (2);