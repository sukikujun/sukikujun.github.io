---
layout: post
title: Docker-Redis集群
date: 2024-06-06 10:10:00 +0900
category: Docker
tag: 
  - Docker
  - Redis
---

# {{ page.title }}

## bitnami/redis

- Command
  - 1.Master コンテナーを起動します
  ```bash
  docker run --name redis-master -d -e REDIS_REPLICATION_MODE=master -e REDIS_PASSWORD=masterpassword123 -v D:\docker\redis:/bitnami --network mynet -p 6379:6379 bitnami/redis:latest
  ```
  - 2.Slave コンテナーを起動します
  ```bash
  docker run --name redis-replica -d --link redis-master:master -e REDIS_REPLICATION_MODE=slave -e REDIS_MASTER_HOST=master -e REDIS_MASTER_PORT_NUMBER=6379 -e REDIS_MASTER_PASSWORD=masterpassword123 -e REDIS_PASSWORD=password123 --network mynet -p 6380:6379 bitnami/redis:latest
  ```
- Dockerfile
  - 1.ファイル作成
  ```yml
  version: '2'

  networks:
    redis-net:
      driver: bridge

  services:
    redis-master:
      image: 'bitnami/redis:latest'
      ports:
        - 6379:6379
      environment:
        - REDIS_REPLICATION_MODE=master
        - REDIS_PASSWORD=masterpassword123
      volumes:
        - D:\docker\redis\data:/bitnami'
      networks:
        - redis-net

    redis-replica:
      image: 'bitnami/redis:latest'
      ports:
        - 6380:6379
      depends_on:
        - redis-master
      environment:
        - REDIS_REPLICATION_MODE=slave
        - REDIS_MASTER_HOST=redis-master
        - REDIS_MASTER_PORT_NUMBER=6379
        - REDIS_MASTER_PASSWORD=masterpassword123
        - REDIS_PASSWORD=password123
      networks:
        - redis-net
  ```
  - 2.スタート
  ```bash
  docker compose up -d
  ```

> テスト

![](/assets/img/docker/redis/redis_master.png)
![](/assets/img/docker/redis/redis_slave.png)
