set search_path to contacts;

-- cartesian product
select *
from call,
     contact;

-- join using a cartesian product
select *
from call,
     contact
where call.contact_id = contact.contact_id;

select call_id, datetime, call.contact_id, name
from call,
     contact
where call.contact_id = contact.contact_id;

-- inner join
select call_id, datetime, call.contact_id, name
from call
         inner join contact on call.contact_id = contact.contact_id;

-- aliases for table names, not really necessary
select call_id, datetime, ca.contact_id, name
from call ca
         inner join contact co on ca.contact_id = co.contact_id;

select call_id, datetime, ca.contact_id, name as contact_name
from call as ca
         inner join contact as co on ca.contact_id = co.contact_id;

select call_id, datetime, ca.contact_id, name as contact_name
from call as ca
         left outer join contact as co on ca.contact_id = co.contact_id;

select *
from call as ca
         left outer join contact as co on ca.contact_id = co.contact_id;

select *
from call as ca
         right outer join contact as co on ca.contact_id = co.contact_id;

select *
from call as ca
         full outer join contact as co on ca.contact_id = co.contact_id;
