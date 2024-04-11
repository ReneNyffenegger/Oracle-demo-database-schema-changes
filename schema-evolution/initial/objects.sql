define db=&1

connect sys/&pwSysProd@&db as sysdba

create user &schema
   identified by &schema
   quota unlimited on users;

grant
   create procedure,
   create session,
   create sequence,
   create table,
   create view
to
   &schema;


connect &schema/&schema@&db

create table customer (
   id          number,
   lastname    varchar2(30),
   firstname   varchar2(30),
   --
   constraint customer_pk primary key (id)
);

create sequence customer_id_seq;

comment on table customer is 'Table customer contains sensitive personal data! Do not copy data to DEV environment!';

create table account (
    id                number,
    customer_id       number not null,
    account_typ       varchar2(50),         -- Should the column be renamed to account_type?
    balance           decimal(15, 2),
    constraint account_pk primary key(id),
    constraint account_fk foreign key(customer_id) references customer(id)
);

create sequence account_id_seq;

create index account_ix on account(customer_id);

create table transaction_history (
    id               number,
    account_id       number not null,
    transaction_date date,
    transaction_type varchar2(50),
    amount           decimal(15, 2),
    --
    constraint transaction_history_pk primary key (id),
    constraint transaction_history_fk foreign key (account_id) references account(id)
);
create sequence transaction_history_id_seq;


create view account_v as
select
   cust.firstname,
   cust.lastname,
   acct.account_typ,
   acct.balance
from
   customer      cust                                left join
   account       acct on cust.id = acct.customer_id
;
