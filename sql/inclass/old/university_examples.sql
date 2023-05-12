set search_path to university;

select *
from instructor;

select c.code as course_code,
       c.name as course_name,
       semester,
       year,
       section,
       i.name as instructor_name
from offering o
         left join instructor i on i.iid = o.iid
         inner join course c on c.cid = o.cid;

select c.code as course_code,
       c.name as course_name,
       semester,
       year,
       section,
       i.name as instructor_name
from offering o
         left join instructor i on i.iid = o.iid
         inner join course c on c.cid = o.cid
where year = 2020
  and semester = 'W';

select *
from student s
         inner join enrollment e on s.sid = e.sid
         inner join offering o on e.oid = o.oid
         inner join course c on c.cid = o.cid
where s.sid = 3;


select *
from offering o
         left join instructor i on o.iid = i.iid;

select *
from offering o
where iid is null;

select *
from offering o
where iid is not null;

select distinct i.*
from instructor i
         inner join offering o on i.iid = o.iid;

select i.*
from instructor i
         left join offering o on i.iid = o.iid
where oid is null;

select *
from course c left join offering o on c.cid = o.cid
where o.cid is null;


select *
from student s left join enrollment e on s.sid = e.sid
where e.oid is null;

select *
from offering o left join enrollment e on o.oid = e.oid
where e.oid is null;

-- select *
-- from offering o inner join enrollment e on o.oid != e.oid;