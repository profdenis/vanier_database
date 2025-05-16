drop schema if exists university cascade;
create schema university;
set search_path to university;

create table student
(
    sid     integer generated always as identity primary key,
    name    text not null,
    email   text,
    program text not null
);

create table instructor
(
    iid        integer generated always as identity primary key,
    name       text not null,
    email      text,
    department text not null
);

create table course
(
    cid     integer generated always as identity primary key,
    name    text not null,
    code    text,
    credits integer
);

create table offering
(
    oid      integer generated always as identity primary key,
    semester char                            not null,
    year     integer                         not null,
    section  varchar(2)                      not null,
    cid      integer references course (cid) not null,
    iid      integer references instructor (iid),
    unique (semester, year, section, cid)
);

create table enrollment
(
    sid integer references student (sid)  not null,
    oid integer references offering (oid) not null,
    primary key (sid, oid)
);

insert into student(name, email, program)
values ('John', 'john@example.com', 'CS'),
       ('Jane', 'jane@example.com', 'SE'),
       ('Joe', 'joe@example.com', 'CS'),
       ('Janet', 'janet@example.com', 'CS');

insert into instructor(name, email, department)
values ('Denis', 'denis@example.com', 'CS'),
       ('Alice', 'alice@example.com', 'CS'),
       ('Bob', 'bob@example.com', 'CS');

insert into course(name, code, credits)
values ('Databases', 'DB', 4),
       ('Web Programming', 'WP', 3),
       ('Security', 'SEC', 3);

insert into offering(semester, year, section, cid, iid)
values ('W', 2020, 'A', 1, 1),
       ('W', 2020, 'B', 1, 2),
       ('W', 2019, 'A', 1, 2),
       ('W', 2020, 'C', 2, 1),
       ('W', 2020, 'D', 2, 1),
       ('F', 2019, 'B', 2, 1),
       ('S', 2020, 'A', 2, null);

insert into enrollment
values (1, 1),
       (1, 4),
       (2, 2),
       (2, 4),
       (3, 4),
       (3, 6);
