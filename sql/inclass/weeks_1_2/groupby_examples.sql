set search_path to contacts;

select *
from contact;

select count(*) as number_of_contacts
from contact;

select count(contact_id) as number_of_contacts
from contact;

select count(email) as number_of_emails
from contact;

select count(address) as number_of_addresses
from contact;

-- select count(*) as number_of_contacts, email
-- from contact;

select *
from call;

select count(contact_id)
from call;

select phone, count(*)
from call
group by phone
order by count(*) desc;

select phone, count(*) as n_calls
from call
group by phone
order by n_calls desc;

select phone, count(*)
from call
group by phone;

select phone, max(datetime) as latest_date
from call
group by phone
order by latest_date desc;

select *
from call full join contact c on c.contact_id = call.contact_id;

select c.contact_id, count(call_id) as n_calls
from call full join contact c on c.contact_id = call.contact_id
group by c.contact_id;

select c.contact_id, name as contact_name, count(call_id) as n_calls
from call full join contact c on c.contact_id = call.contact_id
group by c.contact_id, name;

set search_path to university;

select count(*) as n_offerings
from offering
where year = 2020;

select year, semester, count(*) as n_offerings
from offering
group by year, semester
order by year, semester;

select c.cid, code, count(oid) as n_offerings
from offering o right join course c on o.cid = c.cid
group by c.cid, code;