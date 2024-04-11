set feedback off
set verify   off

@ variables

@ schema-evolution/clean-up
@ schema-evolution/initial/go.sql



connect sys/&pwSysProd@&dbProd as sysdba
grant create database link to &schema;

connect &schema/&schema@&dbProd

-- use docker inspect to find ip address of host
@ metadata/database-link.sql

connect &schema/&schema@&dbProd
@ metadata/diff-util-pkg-spec.sql
@ metadata/diff-util-pkg-body.sql

-------------------------------------

connect &schema/&schema@&dbDev
prompt @|blue,intensity_bold Develop release 1.1 on dev|@
@ schema-evolution/rel-1.1.sql &dbDev

connect &schema/&schema@&dbProd
prompt @|blue,intensity_bold ALTER TABLE statements on prod|@
@ metadata/print-alter-stmts.sql

prompt @|blue,intensity_bold Sync prod with dev |@
@ schema-evolution/rel-1.1.sql &dbProd

-------------------------------------

connect &schema/&schema@&dbDev
prompt @|blue,intensity_bold Develop release 1.2 on dev|@
@ schema-evolution/rel-1.2.sql &dbDev

connect &schema/&schema@&dbProd
prompt @|blue,intensity_bold ALTER TABLE statements on prod|@
@ metadata/print-alter-stmts.sql

prompt @|blue,intensity_bold Sync prod with dev |@
@ schema-evolution/rel-1.2.sql &dbProd


exit
