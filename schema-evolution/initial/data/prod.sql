connect &schema/&schema@&dbProd

declare

   procedure ins_trx_hist(dt date, tp varchar2, amt decimal) is begin
      insert into transaction_history (id, account_id, transaction_date, transaction_type, amount) values (transaction_history_id_seq.nextval, account_id_seq.currval, dt, tp, amt);
   end ins_trx_hist;

begin
   insert into customer(id, lastname, firstname) values (customer_id_seq.nextval,'Brown'    , 'Mary'      );
   insert into account (id, customer_id, account_typ, balance) values (account_id_seq.nextval, customer_id_seq.currval, 'Checking', 1500.00);
   ins_trx_hist(date '2023-12-31', 'interest'  ,   3.18);
   ins_trx_hist(date '2024-01-31', 'deposit'   , 100   );
   ins_trx_hist(date '2024-01-31', 'auto-pay'  , 150   );
   ins_trx_hist(date '2024-02-19', 'withdrawal', 100   );
   ins_trx_hist(date '2024-02-22', 'transfer'  , 100   );
   ins_trx_hist(date '2024-02-28', 'payment'   , 100   );
   ins_trx_hist(date '2024-02-29', 'auto-pay'  , 150   );
   ins_trx_hist(date '2024-03-31', 'charge'    ,   2.19);
   ins_trx_hist(date '2024-03-31', 'auto-pay'  , 150   );
   ins_trx_hist(date '2024-04-02', 'refund'    ,   5.00);
   ins_trx_hist(date '2024-04-04', 'check'     ,  22.22);
   ins_trx_hist(date '2024-04-30', 'auto-pay'  , 150   );

   insert into account (id, customer_id, account_typ, balance) values (account_id_seq.nextval, customer_id_seq.currval, 'Savings' , 3000.00);


   insert into customer(id, lastname, firstname) values (customer_id_seq.nextval,'Smith'    , 'William'   );
   insert into account (id, customer_id, account_typ, balance) values (account_id_seq.nextval, customer_id_seq.currval, 'Checking', 2500.50);
   insert into account (id, customer_id, account_typ, balance) values (account_id_seq.nextval, customer_id_seq.currval, 'Savings' , 6543.21);
   insert into account (id, customer_id, account_typ, balance) values (account_id_seq.nextval, customer_id_seq.currval, 'IRA'     ,12345.67);


   insert into customer(id, lastname, firstname) values (customer_id_seq.nextval,'Rodriguez', 'James'     );
   insert into account (id, customer_id, account_typ, balance) values (account_id_seq.nextval, customer_id_seq.currval, 'Checking', 1200.00);
   insert into account (id, customer_id, account_typ, balance) values (account_id_seq.nextval, customer_id_seq.currval, 'Savings' , 500.00);

   insert into customer(id, lastname, firstname) values (customer_id_seq.nextval,'Johnson'  , 'Linda'     );
   insert into account (id, customer_id, account_typ, balance) values (account_id_seq.nextval, customer_id_seq.currval, 'Checking', 750.25);

   insert into customer(id, lastname, firstname) values (customer_id_seq.nextval,'Garcia'   , 'Patricia'  );
   insert into account (id, customer_id, account_typ, balance) values (account_id_seq.nextval, customer_id_seq.currval, 'Savings' , 8290.00);
   insert into account (id, customer_id, account_typ, balance) values (account_id_seq.nextval, customer_id_seq.currval, 'IRA'     ,15817.87);

   insert into customer(id, lastname, firstname) values (customer_id_seq.nextval,'Garcia'   , 'John'      );
   insert into account (id, customer_id, account_typ, balance) values (account_id_seq.nextval, customer_id_seq.currval, 'Checking' , 1500.00);
   insert into account (id, customer_id, account_typ, balance) values (account_id_seq.nextval, customer_id_seq.currval, 'Brokerage',27859.90);

   insert into customer(id, lastname, firstname) values (customer_id_seq.nextval,'Williams' , 'Elizabeth' );
   insert into account (id, customer_id, account_typ, balance) values (account_id_seq.nextval, customer_id_seq.currval, 'Savings' , 3123.18);

   insert into customer(id, lastname, firstname) values (customer_id_seq.nextval,'Smith'    , 'Patricia'  );
   insert into account (id, customer_id, account_typ, balance) values (account_id_seq.nextval, customer_id_seq.currval, 'Savings' , 2991.80);

   insert into customer(id, lastname, firstname) values (customer_id_seq.nextval,'Johnson'  , 'Jennifer'  );
   insert into account (id, customer_id, account_typ, balance) values (account_id_seq.nextval, customer_id_seq.currval, 'CD' ,  819.37);

   insert into customer(id, lastname, firstname) values (customer_id_seq.nextval,'Williams' , 'Robert'    );
   insert into account (id, customer_id, account_typ, balance) values (account_id_seq.nextval, customer_id_seq.currval, 'MMA' , 2222.22);

   commit;
end;
/
