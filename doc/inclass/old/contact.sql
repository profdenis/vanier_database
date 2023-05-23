create schema if not exists contacts_in_class;

set search_path to contacts_in_class;

create table if not exists contact
(
    contact_id integer generated always as identity primary key,
    name       text not null,
    address    text,
    email      text
);

create table if not exists call
(
    call_id    integer generated always as identity primary key,
    phone      text      not null,
    datetime   timestamp not null,
    contact_id integer references contact (contact_id)
);

insert into contact(name, address, email)
values ('Denis', 'Québec', 'denis@example.com'),
       ('Bob', 'Montréal', 'Bob@example.com');

insert into call(phone, datetime, contact_id)
values ('1231231234', '2023-02-01 14:00', 1),
       ('1112223333', '2023-01-23', null);

-- dangerous!
-- delete from call;
-- do instead
delete from call where datetime < '2023-01-01';

-- dangerous
-- drop table contact;
-- drop table call;
-- even more dangerous
-- drop table contact cascade;
