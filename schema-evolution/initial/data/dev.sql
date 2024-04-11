connect &schema/&schema@&dbDev

declare

   procedure ins_trx_hist(dt date, tp varchar2, amt decimal) is begin
      insert into transaction_history (id, account_id, transaction_date, transaction_type, amount) values (transaction_history_id_seq.nextval, account_id_seq.currval, dt, tp, amt);
   end ins_trx_hist;
begin
   insert into customer(id, lastname, firstname) values (customer_id_seq.nextval,'Mouse', 'Mickey');

   insert into account (id, customer_id, account_typ, balance) values (account_id_seq.nextval, customer_id_seq.currval, 'Checking', 1200.00);
   ins_trx_hist(date '2023-12-31', 'interest'  ,   3.18);
   ins_trx_hist(date '2024-01-31', 'deposit'   , 100   );

   insert into account (id, customer_id, account_typ, balance) values (account_id_seq.nextval, customer_id_seq.currval, 'Savings' , 500.00);
   ins_trx_hist(date '2023-12-31', 'interest'  ,   2.97);
   ins_trx_hist(date '2024-01-31', 'deposit'   ,  80   );

   insert into customer(id, lastname, firstname) values (customer_id_seq.nextval,'Jerry', 'Tom'   );
   insert into account (id, customer_id, account_typ, balance) values (account_id_seq.nextval, customer_id_seq.currval, 'IRA'     ,15817.87);

   commit;
end;
/
