---
layout: post
title: Github-SSH
date: 2024-05-20 11:30:00 +0900
category: Git
tag: 
  - SSH
---

# {{ page.title }}

## 既存の SSH キーの確認

> ls -al ~/.ssh を入力して、既存の SSH キーが存在するかどうかを確認します。

```bash
$ ls -la ~/.ssh
```

> ディレクトリの一覧から、公開 SSH キーをすでに持っているか確認します。 既定では、GitHub でサポートされている公開鍵のファイル名は次のいずれかです。

- id_rsa.pub
- id_ecdsa.pub
- id_ed25519.pub

## 新しい SSH キーを生成する

> 以下のテキストを貼り付け、例で使用されているメールを GitHub メール アドレスに置き換えます。

```bash
$ ssh-keygen -t ed25519 -C "your_email@example.com"
```

## アカウントへの新しい SSH キーの追加

> SSH 公開鍵をクリップボードにコピーします

```bash
$ clip < ~/.ssh/id_ed25519.pub
```

> Github Add SSH key

![Add-SSH](/assets/img/git/github-add-ssh.png)

## Proxy が設定した場合、config を以下の設定にします

```
PS C:\Users\NC> cat .\.ssh\config
# Read more about SSH config files: https://linux.die.net/man/5/ssh_config
Host *
    ProxyCommand "C:\Program Files\Git\mingw64\bin\connect.exe" -H 192.168.0.254:8080 %h %p
```