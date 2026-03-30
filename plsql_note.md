

## PL/SQL の基本データ型

### 文字・数値リテラル

### 改行コード

CHR(13): キャリッジリターン（CR）
CHR(10): ラインフィード（LF）

Windows 系: CR + LF
UNIX 系: LF のみ

### 文字列リテラルの同士比較の不思議

```plsql
SELECT 'ABC' = 'ABC ' FROM DUAL; -- TRUE
```


### エスケープ・シーケンス

| 文字 | アスキーコード | 補足 |
| - | - | - |
| タブ | CHR(9) | \t 相当 |
| CR | CHR(13) |  |
| LF | CHR(10) |  |
| 改行 | CHR(13)  CHR(10) |  |
|  | CHR(10) |  |
| スペース | CHR(32) |  |
| 引用符(') | CHR(39) |  |


## PL/SQL のブロック構造

### コメント

1. `--`: 行コメント
2. `/* */`: ブロックコメント

> ブロックコメントを使うと、エラー行の位置が正しくないので、行コメントだけを使用

### ブロック

```plsql
declare
-- 宣言
begin
  -- 処理
  null
end;
```

## PL/SQL の例外処理

```plsql
DECLARE
    VNUM NUMBER(2);
BEGIN
    VNUM := 1 / 0;
    DBMS_OUTPUT.PUT_LINE('数値= ' || VNUM);
EXCEPTION
    WHEN ZERO_DIVIDE THEN
        NULL; -- 何もしたいという命令
        DBMS_OUTPUT.PUT_LINE('計算できませんでした');
    WHEN OTHERS THEN
        RAISE;
END;
```

### ユーザー定義例外

```plsql
CREATE OR REPLACE PROCEDURE IS_OCT (
    P_OCTSTR IN VARCHAR2
) IS
    EINVALIDPARAM EXCEPTION;
BEGIN
    IF ( LTRIM(P_OCTSTR, '01234567') IS NOT NULL ) THEN
        RAISE EINVALIDPARAM;
    END IF;

    DBMS_OUTPUT.PUT_LINE('8進数です');
EXCEPTION
    WHEN EINVALIDPARAM THEN
        DBMS_OUTPUT.PUT_LINE('8進数ではありません');
END;
/

CALL IS_OCT('700');

CALL IS_OCT('800');
```

## ストアドプロシージャ

### サブプログラムのオーバーロード

> 1. パッケージ オーヴァーロードの プロシージャ名、引数名を一致すべき

```plsql
CREATE OR REPLACE PACKAGE OVERLOADING IS
    FUNCTION COMPLEX (
        N NUMBER
    ) RETURN NUMBER;

    FUNCTION COMPLEX (
        N PLS_INTEGER
    ) RETURN NUMBER;

END;
/

CREATE OR REPLACE PACKAGE BODY OVERLOADING IS

    FUNCTION COMPLEX (
        N NUMBER
    ) RETURN NUMBER IS
    BEGIN
        RETURN 0;
    END;

    FUNCTION COMPLEX (
        N PLS_INTEGER
    ) RETURN NUMBER IS
    BEGIN
        RETURN 1;
    END;

END;
/

DECLARE
    N NUMBER := 1;
    P PLS_INTEGER := 2;
BEGIN
    DBMS_OUTPUT.PUT_LINE(OVERLOADING.COMPLEX(N)); -- 0
    DBMS_OUTPUT.PUT_LINE(OVERLOADING.COMPLEX(P)); -- 1
END;
```

### ローカルサブプログラム

> 1. ローカル変数と同じようにスコープは該当ブロックに限定される。
> 2. ローカル・サブプログラムは必ず変数の宣言の後に記述しなければならない。

```plsql
create or replace procedure local_subprogram_sample is
  -- ローカル変数
   vnum  number;
   vdate date;
  
  -- ローカル・サブプログラム(1)
   function add (
      n1 number,
      n2 number
   ) return number is
   begin
      return n1 + n2;
   end;
  -- ローカル・サブプログラム(2)オーバーロードも可能
   function add (
      dt date,
      d  number
   ) return date is
   begin
      return dt + d;
   end;
begin
   vnum := 10;
  --  vdate := date '2026-03-30'; -- 日付リテラル
   vdate := timestamp '2026-03-30 12:12:12'; -- タイムスタンプリテラルも可能
   dbms_output.put_line('数値の加算: ' || add(
      vnum,
      5
   ));
   dbms_output.put_line('日付の加算: ' || to_char(
      add(
         vdate,
         5
      ),
      'YYYY-MM-DD HH24:MI:SS'
   ));
end;
/

call local_subprogram_sample();
```

> ローカル・サブプログラムのスコープの確認

```plsql
declare
  -- スコープA
   function local_sub_twins return varchar2 is
   begin
      return 'あいう';
   end;
begin
   declare
  -- スコープB
      function local_sub_twins return varchar2 is
      begin
         return 'ABC';
      end;
   begin
      dbms_output.put_line(local_sub_twins);
   end;
   dbms_output.put_line(local_sub_twins);
end;
/
```


## ストアドプロシージャの実行とデバッグ

```plsql
create or replace procedure exception_test (
   p_dummy out number
) is
   edummy exception;
begin
   p_dummy := 1;
   raise edummy;
end;
/

declare
   vnum number := 9999;
begin
   exception_test(vnum);
   dbms_output.put_line('処理の結果: ' || vnum);
exception
   when others then
      dbms_output.put_line('例外処理の結果' || vnum);
end;
```

### 例外をスロー (RAISE) しながら戻り値を渡すには

> 1. プロシージャ
```plsql
create or replace procedure exception_test2 (
   p_dummy out nocopy number
) is
   edummy exception;
begin
   p_dummy := 1;
   raise edummy;
end;
/

declare
   vnum number := 9999;
begin
   exception_test2(vnum);
   dbms_output.put_line('処理の結果: ' || vnum);
exception
   when others then
      dbms_output.put_line('例外処理の結果: ' || vnum);
end;
```

> 2. ファンクション

```plsql
create or replace function exception_test3 (
   p_dummy out nocopy number
) return number is
   edummy exception;
begin
   p_dummy := 1;
   raise edummy;
   return 0; -- ここは実行されることはない
end;
/

declare
   vnum1 number := 9999;
   vnum2 number := 9999;
begin
   vnum1 := exception_test3(vnum2);
   dbms_output.put_line('処理の結果: ' || vnum1);
   dbms_output.put_line('処理の結果: ' || vnum2);
exception
   when others then
      dbms_output.put_line('例外処理の結果: ' || vnum1);
      dbms_output.put_line('例外処理の結果: ' || vnum2);
end;
```