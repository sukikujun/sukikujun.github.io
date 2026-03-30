

# [PL/SQL プログラミング入門（２）](https://www.shift-the-oracle.com/plsql/index2.html)

## PL/SQL のコンテナタイプのデータ型

### コレクション（配列）

> 結合配列（索引付の表）

```plsql
create or replace procedure initial_test1 is
   type tarrayint is
      table of varchar2(10) index by binary_integer;
   type tarraystr is
      table of varchar2(20) index by varchar2(5);
   vname10_list tarrayint;
   vname20_list tarraystr;

   -- vname10 を初期化する
   procedure initialize (
      p_array out tarrayint
   ) is
   begin
      p_array(1) := 'AAA';
      p_array(2) := 'BBB';
   end;

   -- vname20 を初期化する
   procedure initialize (
      p_array out tarraystr
   ) is
   begin
      p_array('壱') := 'AAA';
      p_array('弐') := 'BBB';
   end;
begin
   initialize(vname10_list);
   initialize(vname20_list);
   -- ...
   vname10_list.delete;
   vname20_list.delete;
end;
```

> ネストした表（NESTED TABLE）

```plsql
CREATE OR REPLACE PROCEDURE INITIAL_TEST2 IS

    TYPE TARRAY10 IS
        TABLE OF VARCHAR2(10) NOT NULL;
    VNAME_LIST TARRAY10 := TARRAY10('AAA', 'BBB');
    VNULL_LIST TARRAY10;
BEGIN
    VNAME_LIST(0.5) := 'ABC';
    DBMS_OUTPUT.PUT_LINE(VNAME_LIST(1)); -- 1から始まる

   -- インデクスに数値へと暗黙変換できない文字列は使用できない。
   -- vname_list('壱') := 'ABC'; -- エラー

   -- vnull_list(1) := 'ABC'; -- コレクションは初期化されていません。エラー

    VNULL_LIST := TARRAY10();
    VNULL_LIST.EXTEND(100); -- コレクションのサイズを100に拡張
    VNULL_LIST(100) := 'ABC';
    DBMS_OUTPUT.PUT_LINE(VNULL_LIST(100));
    VNAME_LIST.DELETE(1);
    DBMS_OUTPUT.PUT_LINE(VNAME_LIST(2));
    VNULL_LIST.DELETE();
END;
/

BEGIN
    INITIAL_TEST2();
END;
```

> VARRAY (可変長配列 : Variable ARRAY)

```plsql
create or replace procedure initial_test3 is
   type tarray10 is
      varray(100) of varchar2(10) not null;
   vname_list  tarray10 := tarray10(
      'AAA',
      'BBB'
   );
   vempty_list tarray10 := tarray10();
   vnull_list  tarray10;
begin
   vname_list(2) := 'ABC';
   -- vname_list(50) := 'ABC'; -- 拡張されていない範囲への代入はエラー

   vname_list.extend(50);  -- 配列を +50 個初期化(=52)
   vname_list(50) := 'ABC';
   vname_list(52) := 'ABC';
   -- vname_list(53) := 'ABC'; -- エラーになる
   -- vname_list.extend(50);  -- さらに +50 すると宣言時の 100 を超え、エラーになる
   vname_list.extend(48);
   vempty_list.extend(50);  -- 空の配列も拡張できる

   -- vnull_list.extend(50);  -- 初期化していない配列の拡張はエラーになる
   vnull_list := tarray10();
   vnull_list.extend(50);  -- 初期化した後は拡張できる

   vname_list.delete;
   vempty_list.delete;
   vnull_list.delete;
end;
/

begin
   initial_test3;
end;
```

### ２次元配列の作り方

```plsql
create or replace procedure initial_9x9 is

   type telement is
      table of number index by binary_integer;
   type tsquare is
      table of telement index by binary_integer;
   vsquare tsquare;

   procedure initialize (
      p_array out tsquare
   ) is
   begin
      for i in 1..9 loop
         for j in 1..9 loop
            p_array(i)(j) := i * j;
         end loop;
      end loop;
   end;

begin
   initialize(vsquare);
   dbms_output.put_line('9x9 Multiplication Table:');
   for i in 1..9 loop
      for j in 1..9 loop
         continue when ( i < j );
         dbms_output.put(j
                         || ' * '
                         || i
                         || ' = '
                         || vsquare(i)(j) || chr(9));
      end loop;
      dbms_output.new_line;
   end loop;
end;
/

begin
   initial_9x9;
end;
```

### レコード型

> user_master DDL
```plsql
create table user_master (
   user_id     varchar(4) not null,
   dept_no     varchar(4),
   user_name   varchar(32),
   created_on  date default sysdate,
   modified_on date
);
```

```sql

```


### コレクション（配列）

