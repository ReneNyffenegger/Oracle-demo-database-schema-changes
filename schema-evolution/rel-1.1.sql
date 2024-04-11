define db=&1
connect &schema/&schema@&db

alter table customer add    birthday date;
alter table customer modify lastname varchar2(50) not null;

create or replace view account_v as
select
   cust.firstname,
   cust.lastname,
   cust.birthday,
   acct.account_typ   account_type,
   acct.balance
from
   customer      cust                                left join
   account       acct on cust.id = acct.customer_id
;

alter index account_ix rebuild compress;
