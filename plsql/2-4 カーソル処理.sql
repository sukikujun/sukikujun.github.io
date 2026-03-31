
--- CURSOR LOOP / OPEN、FETCH、CLOSE
-- 暗黙カーソル for loop

create or replace procedure step01_select1
is
begin
  for vRec in (
    select 'data1' colname_1 from dual
    union all
    select 'data2' colname_1 from dual
  ) loop
    dbms_output.put(nvl(to_char(SQL%ROWCOUNT), 'NNULL') || ':');
    dbms_output.put_line(vRec.colname_1);
  end loop;
end;
/

call step01_select1();

-- 明示カーソル for loop
CREATE OR REPLACE PROCEDURE STEP01_SELECT2(P_DATA_1 IN VARCHAR2)
IS
  CURSOR cDual(P_DATA_2 VARCHAR2 := 'CURSOR param')
  IS
    SELECT P_DATA_1 COLNAME_1 FROM DUAL
    UNION ALL
    SELECT P_DATA_2 COLNAME_1 FROM DUAL;
BEGIN
  FOR vRec IN cDual LOOP
    DBMS_OUTPUT.PUT(cDual%ROWCOUNT || ':');
    DBMS_OUTPUT.PUT_LINE(vRec.COLNAME_1);
  END LOOP;
END;
/

call step01_select2('SELECT2');

-- カーソル オープンとフェッチ
create or replace procedure step01_select3(P_DATA_1 IN VARCHAR2)
IS
  CURSOR cDual(P_DATA_2 VARCHAR2 := 'CURSOR param')
  IS
    SELECT P_DATA_1 COLNAME_1 FROM DUAL
    UNION ALL
    SELECT P_DATA_2 COLNAME_1 FROM DUAL;
  vRec cDual%ROWTYPE;
BEGIN
  OPEN cDual('yyy'); -- 引数付きのカーソルをオープン
  LOOP
    FETCH cDual INTO vRec; -- カーソル内容を取り出す
    EXIT WHEN cDual%NOTFOUND;
    DBMS_OUTPUT.PUT(cDual%ROWCOUNT || ':');
    DBMS_OUTPUT.PUT_LINE(vRec.COLNAME_1);
  END LOOP;
  CLOSE cDual; -- 使用済みのカーソルは必ずクローズすること
END;
/

call step01_select3('SELECT3');

--- 暗黙カーソル

| カーソル属性 | 意味 | タイプ |
| :-: | :-: | :-: |
| FOUND | カーソルで実行した SQL に該当するものがある、ない | TRUE、FALSE |
| NOTFOUND | FOUND 属性の論理的な逆 | TRUE、FALSE |
| ISOPEN | カーソルがオープン中である、でない | TRUE、FALSE |
| ROWCOUNT | DML によって影響のあった行数 UPDATE、DELETE(SELECT 含む) | 数値(>=0) |
| BULK_ROWCOUNT | バルク操作によって影響のあった行数の配列(暗黙カーソルのみの属性) | 配列 |
| BULK_EXCEPTIONS | バルク操作によって発生した例外の配列(暗黙カーソルのみの属性) | 配列 |

---


