
--- SELECT INTO
-- SELECT INTO をした単一行の取得

create or replace procedure step01_select
is
  vUserID user_master.user_id%type;
  vUserName user_master.user_name%type;
begin
  select user_id, user_name into vUserID, vUserName from user_master;
  -- select user_id, user_name into vUserID, vUserName from user_master where rownum <= 1;

  dbms_output.put_line('利用者IDは' || vUserID || 'です。');
  dbms_output.put_line('利用者名は' || vUserName || 'です。');
exception
  when NO_DATA_FOUND then
    dbms_output.put_line('データが見つかりませんでした。');
  when TOO_MANY_ROWS then
    dbms_output.put_line('データが複数見つかりました。');
end;
/

begin
  step01_select();
end;

-- SELECT BULK COLLECT INTO によるバルク処理
create or replace procedure step01_select_all
is
  type tUserList is table of user_master%ROWTYPE;
  vUsers tUserList;
begin
  select * bulk collect into vUsers from user_master;
  -- bulk collect 全ての結果が一度に設定される
  dbms_output.put_line('レコード数は' || vUsers.COUNT || '件です。');
  for i in 1..vUsers.COUNT loop
    dbms_output.put_line(vUsers(i).user_id || ' - ' || vUsers(i).user_name);
  end loop;
  dbms_output.put_line('利用者IDは' || vUsers(1).user_id || 'です。');
  dbms_output.put_line('利用者名は' || vUsers(1).user_name || 'さんです。');

  vUsers.delete;
  dbms_output.put_line('配列の大きさは' || vUsers.COUNT || 'です');
end;
/

begin
  step01_select_all();
end;

--- INSERT

-- テーブル定義
create table user_master (
     user_id     varchar(4) not null,
     dept_no     varchar(4),
     user_name   varchar(32),
     created_on  date default sysdate,
     modified_on date
);

-- INSERT
create or replace procedure step01_insert
is
begin
  INSERT INTO user_master (
    user_id, dept_no, user_name, created_on, modified_on
  ) VALUES ( '0020', '1001', '小泉 純一', default, null );
  dbms_output.put_line('インサートした件数は' || SQL%ROWCOUNT || '件です。');
  commit;
  dbms_output.put_line('commit(SQL)後の ROWCOUNT は' || SQL%ROWCOUNT || 'です。');
end;
/

call step01_insert();

-- RETURNING
create or replace procedure step02_insert
is
  vUser USER_MASTER%ROWTYPE;
begin
  INSERT INTO user_master (
    user_id, dept_no, user_name, created_on, modified_on
  ) VALUES ( '0021', '1001', '小泉 純一', default, null )
  RETURNING user_id, dept_no, user_name, created_on, modified_on into vUser;

  dbms_output.put_line('インサートした件数は' || SQL%ROWCOUNT || '件です。');
  commit;
  dbms_output.put_line('commit(SQL)後の ROWCOUNT は' || SQL%ROWCOUNT || 'です。');
  dbms_output.put_line('インサートした日付は' || vUser.created_on || 'です。');
end;
/

call step02_insert();
