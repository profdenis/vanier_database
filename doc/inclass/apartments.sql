create schema apartments;
set search_path to apartments;

create table building
(
    building_id integer generated always as identity primary key,
    name        text,
    address     text not null
);

create table apartment
(
    building_id  integer references building (building_id),
    number       integer,
    asking_rent  numeric(10, 2),
    available_on date,
    primary key (building_id, number)
);

create table contract
(
    contract_id  integer generated always as identity primary key,
    monthly_rent numeric(10, 2) not null,
    end_of_lease date,
    building_id  integer        not null,
    number       integer        not null,
    foreign key (building_id, number) references apartment (building_id, number)
);

create table tenant
(
    tenant_id  integer generated always as identity primary key,
    first_name text not null,
    last_name  text not null,
    home_phone text not null,
    employer   text,
    work_phone text
);

create table contract_tenant
(
    contract_id integer not null references contract (contract_id),
    tenant_id   integer not null references tenant (tenant_id),
    primary key (contract_id, tenant_id)
);


insert into building(name, address)
values (null, 'Montréal'),
       ('Vanier', 'St-Laurent');

insert into apartment values (1, 1, 1000, '2023-06-01');
insert into apartment(building_id, number) values (2, 1);
