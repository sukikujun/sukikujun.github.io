
-- 自律型トランザクション
CREATE TABLE ERROR_LOGS (
  USER_CODE NUMBER(5),
  USER_ERRM VARCHAR2(30),
  CREATED_ON DATE
)
/

-- 自律型トランザクションでエラーログを保存
create or replace procedure simple_logger(
  p_code in number,
  p_errm in varchar2
)
is
  pragma autonomous_transaction;
  -- 自律型トランザクション プラグマ
begin
  INSERT INTO ERROR_LOGS (
    USER_CODE, USER_ERRM, CREATED_ON
  ) VALUES ( p_code, p_errm, SYSDATE );
  commit;
end;
/

create or replace procedure insert_error
is
begin
  execute immediate q'[insert into user_master(user_id, dept_no, user_name) values ('0021', '1000', '鈍色聴')]';
  execute immediate 'insert into not_exists_table values (null)';
  -- commit; 絶対に失敗する予定なので必要なし
exception
  when others then
    dbms_output.put_line('例外処理しました。ORA' || SQLCODE || ':' SQLERRM);
    simple_logger(SQLCODE, 'INSERT ERROR');
    rollback;
end;
/

call insert_error();

select * from ERROR_LOGS;
select * from user_master;
