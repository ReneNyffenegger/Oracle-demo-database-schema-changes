create or replace package diff_util authid definer as

   function  alter_stmts(nam varchar2, typ varchar2 := 'table') return clob;
   procedure print_obj_alter_stmts(nam varchar2, typ varchar2 := 'table');
   procedure print_alter_stmts;

end diff_util;
/
