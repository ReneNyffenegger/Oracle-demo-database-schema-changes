create or replace package body diff_util as

   function obj_sxml( -- {
      name    varchar2,
      typ     varchar2,
      db_link varchar2
   )
   return clob is
     
      hdl_meta         number;
      hdl_xml_to_sxml  number;
      sxml             clob;
    
   begin
      hdl_meta := dbms_metadata.open(upper(typ), network_link => upper(db_link));
     
      dbms_metadata.set_filter(hdl_meta, 'NAME', name);

      hdl_xml_to_sxml := dbms_metadata.add_transform(hdl_meta, 'SXML');

      dbms_metadata.set_transform_param(hdl_xml_to_sxml, 'PHYSICAL_PROPERTIES', true ); /* compressed etc. */
      dbms_metadata.set_transform_param(hdl_xml_to_sxml, 'SEGMENT_ATTRIBUTES' , true );
      dbms_metadata.set_transform_param(hdl_xml_to_sxml, 'STORAGE'            , true );
     
      sxml := dbms_metadata.fetch_clob(hdl_meta);
    
      dbms_metadata.close(hdl_meta);
     
      return sxml;
         
   end obj_sxml; -- }

   function obj_sxml_diff( -- {
      name  in varchar2,
      typ   in varchar2
   )
   return clob is
      sxml_prod      clob;
      sxml_dev       clob;
      sxml_diff      clob;
      hdl_meta_diff  number;
   begin
      sxml_prod := obj_sxml(name, typ,  null   );
      sxml_dev  := obj_sxml(name, typ, 'db_dev');

      hdl_meta_diff := dbms_metadata_diff.openc(typ);
    
      dbms_metadata_diff.add_document(hdl_meta_diff, sxml_prod);
      dbms_metadata_diff.add_document(hdl_meta_diff, sxml_dev );

      sxml_diff := dbms_metadata_diff.fetch_clob(hdl_meta_diff);
      dbms_metadata_diff.close(hdl_meta_diff);

      return sxml_diff;
    
   end obj_sxml_diff; -- }

   function obj_xml_alter(  -- {
      name in varchar2,
      typ  in varchar2
   )
   return clob
   is

      diffdoc       clob;
      hdl_meta      number;
      hdl_alter_xml number;
      xml_alter     clob;

   begin

      diffdoc := obj_sxml_diff(name, typ);

      hdl_meta      := dbms_metadata.openw(typ);
      hdl_alter_xml := dbms_metadata.add_transform(hdl_meta, 'ALTERXML');

--    dbms_metadata.set_parse_item(hdl_meta, 'CLAUSE_TYPE'     );
--    dbms_metadata.set_parse_item(hdl_meta, 'NAME'            );
--    dbms_metadata.set_parse_item(hdl_meta, 'COLUMN_ATTRIBUTE');

      dbms_lob.createtemporary(xml_alter, true);

      dbms_metadata.convert(hdl_meta, diffdoc, xml_alter);
      dbms_metadata.close(hdl_meta);

      return xml_alter;
   end obj_xml_alter; -- }
      
   function obj_alter_ddl( -- {
      name in varchar2,
      typ  in varchar2
   )
   return clob is

      xml_alter       clob;
      hdl_meta        number;
      hdl_alter_ddl   number;
      alter_ddl       clob;

   begin
      xml_alter:= obj_xml_alter(name, typ);
      hdl_meta := dbms_metadata.openw(typ);

      hdl_alter_ddl    := dbms_metadata.add_transform(hdl_meta, 'ALTERDDL');
      dbms_metadata.set_transform_param(hdl_alter_ddl, 'SQLTERMINATOR', true);

      dbms_lob.createtemporary(alter_ddl, true);
      dbms_metadata.convert(hdl_meta, xml_alter, alter_ddl);

      dbms_metadata.close(hdl_meta);
      return alter_ddl;
   end obj_alter_ddl; -- }

   function alter_stmts(nam varchar2, typ varchar2) return clob is -- {
   begin
      return obj_alter_ddl(upper(nam), upper(typ));
   exception
      when dbms_metadata.invalid_argval then
           return '-- Object type ' || lower(typ) || ' is not supported by dbms_metadata_diff (ORA-31600)';
      when others then
           if sqlcode  = -31604 then
              return '-- Error 31604, ' || sqlerrm;
           end if;
           raise;
   end alter_stmts; -- }

   procedure print_obj_alter_stmts(nam varchar2, typ varchar2) is -- {
      stmts clob;
   begin
      stmts := alter_stmts(nam, typ);
      if length(stmts) > 0 then
         dbms_output.put_line('-- ' || chr(27) || '[96m' || nam || ' (' || typ || ')' || chr(27) || '[0m');
         dbms_output.put_line(chr(27) || '[93m');
         dbms_output.put_line(stmts);
         dbms_output.put_line(chr(27) || '[0m');
      end if;
   end print_obj_alter_stmts;

   procedure print_alter_stmts is
   begin

      for obj in (
         select
            object_name nam,
            object_type typ
         from
            user_objects
         where
            object_type not in ('PACKAGE', 'PACKAGE BODY', 'DATABASE LINK')
        ) loop
          diff_util.print_obj_alter_stmts(obj.nam, obj.typ);
      end loop;

   end print_alter_stmts;

end diff_util; -- }
/
