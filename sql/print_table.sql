create or replace
procedure print_table(p_query in varchar2)
authid current_user
as
    l_cursor number := dbms_sql.open_cursor;
    l_sql varchar2(200) := p_query;
    l_column_count  number := 0;
    l_desctab   dbms_sql.desc_tab;
    l_column_value varchar2(4000);
    l_status number;
begin
    dbms_sql.parse(l_cursor,l_sql,dbms_sql.native);
    dbms_sql.describe_columns (l_cursor,l_column_count,l_desctab);
    dbms_output.put_line ('--------------------------------');
 
    for i in 1..l_column_count
    loop
        dbms_sql.define_column (l_cursor,i,l_column_value,4000);
    end loop;
 
    l_status := dbms_sql.execute(l_cursor);
 
    while ( dbms_sql.fetch_rows(l_cursor) > 0 )
    loop
        for i in 1..l_column_count
        loop
            dbms_sql.column_value (l_cursor,i,l_column_value);
            dbms_output.put_line ( rpad(' ',5,' ')||rpad(l_desctab(i).col_name,20,'.') ||' '|| l_column_value );
        end loop;
        dbms_output.put_line ('--------------------------------');
    end loop;
 
    dbms_sql.close_cursor(l_cursor);
end print_table;
/

