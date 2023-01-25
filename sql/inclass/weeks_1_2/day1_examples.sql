set search_path to contacts;

select *
from contacts.contact;

select *
from contact;

select *
from call;

select phone, datetime
from call;

select phone, datetime
from call
where datetime >= '2020-01-01' and datetime < '2021-01-01';

select phone, datetime
from call
where datetime between '2020-01-01' and '2021-01-01';

select phone, datetime
from call
where datetime >= '2020-01-01'
order by phone, datetime desc;