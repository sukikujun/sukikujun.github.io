
create table user_master (
   user_id     varchar(4) not null,
   dept_no     varchar(4),
   user_name   varchar(32),
   created_on  date default sysdate,
   modified_on date
);

begin
  insert into user_master(user_id, user_name) values('1001', '鈍色聴');
  insert into user_master(user_id, user_name) values('1002', '鈍色次郎');
  insert into user_master(user_id, user_name) values('1003', '鈍色三郎');
  commit;
end;

-- ユーザー定義によるレコード型の定義
declare
  type tID_NAME is record (
    id number not null default -1,
    name varchar2(8 char) default 'ななし' -- varchar(8) が 8 byyte, 1文字3バイト（UTF-8の場合）
  );
  vID_NAME tID_NAME;
begin
  vID_NAME.ID := 1;
  dbms_output.put_line(vID_NAME.ID || '.' || vID_NAME.Name);
end;
/

-- 表を使用した定義
declare
  vUser USER_MASTER%ROWTYPE;
begin
  select * into vUser from USER_MASTER where rownum <= 1;
  dbms_output.put_line(vUser.USER_NAME);
end;
/

-- カーソルを使用した定義
declare
  cursor cIDName is
    select user_id, user_name from user_master;
  vID_NAME cIDName%ROWTYPE;
begin
  open cIDName;
  loop
    fetch cIDName into vID_NAME;
    exit when cIDName%notfound;
    dbms_output.put_line(vID_NAME.user_name);
  end loop;
  close cIDName;
end;
