set feedback off
set verify   off

@ variables

@ schema-evolution/clean-up.sql
@ schema-evolution/initial/go.sql

host rm    -rf liquibase/out
host mkdir     liquibase/out

connect &schema/&schema@&dbProd

prompt @|green generate-schema|@
@ liquibase/cmd/generate-schema.sql

prompt @|green changelog-sync|@
@ liquibase/cmd/changelog-sync.sql

connect &schema/&schema@&dbProd
@ liquibase/cmd/tag-rel-1.0.sql

connect &schema/&schema@&dbDev
@ schema-evolution/rel-1.1.sql

connect &schema/&schema@&dbProd
@ liquibase/cmd/diff-changelog.sql


prompt @|blue,intensity_bold Sync prod DB with dev DB|@
@ liquibase/cmd/update.sql

@ liquibase/cmd/tag-rel-1.1.sql

@ sql/select-account.sql

prompt @|green Changes for Rel 1.2|@
@ schema-evolution/rel-1.2.sql &dbDev


connect &schema/&schema@&dbProd

lb diff-changelog -output-file liquibase/out/controller.xml -reference-username &schema -reference-password &schema -reference-url jdbc:oracle:thin:@&dbDev

prompt @|blue,intensity_bold Sync prod DB with dev DB|@
@ liquibase/cmd/update.sql

@ liquibase/cmd/tag-rel-1.2.sql

@ sql/select-account.sql

@ sql/index-account_ix.sql

@ liquibase/sql/databasechangelog.sql

exit
