connect sys/&pwSysProd@&dbProd as sysdba
drop user &schema cascade;

connect sys/&pwSysDev@&dbDev   as sysdba
drop user &schema cascade;
