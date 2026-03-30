
--- DDL の実行

-- PL/SQLのブロック内でDDL文（TRUNCATE, CREATE, DROPなど）を直接書くことができない
create or replace procedure DDL_TRUNCATE_NG
is
begin
  truncate table user_master;
end;
/

DDL_TRUNCATE_NG();

create or replace procedure DDL_TRUNCATE
is
  vUserID USER_MASTER.USER_ID%TYPE;
  vUserName USER_MASTER.USER_NAME%TYPE;
begin
  truncate table user_master;
end;
/
