

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


