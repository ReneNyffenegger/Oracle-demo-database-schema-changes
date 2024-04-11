define db=&1
connect &schema/&schema@&db

drop   index account_ix;
create index account_ix on account(customer_id, account_typ);

alter  table account rename column account_typ to account_type;
