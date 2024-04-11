select
   tag,
   filename,
   to_char(dateexecuted, 'yyyy-mm-dd hh24:mi') exec_dt,
   exectype,
   description,
   author
from
   databasechangelog
order by
   orderexecuted;
