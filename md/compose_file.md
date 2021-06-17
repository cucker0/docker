Compose file
==

## Compose file格式版本与Docker Engine版本的支持关系表

Compose file format |Docker Engine release
:--- |:---
[Compose specification](https://github.com/compose-spec/compose-spec/blob/master/spec.md) |19.03.0+
3.8 | 19.03.0+
3.7 | 18.06.0+
3.6 | 18.02.0+
3.5 | 17.12.0+
3.4 | 17.09.0+
3.3 | 17.06.0+
3.2 | 17.04.0+
3.1 | 1.13.1+
3.0 | 1.13.0+
2.4 | 17.12.0+
2.3 | 17.06.0+
2.2 | 1.13.0+
2.1 | 1.12.0+
2.0 | 1.10.0+ 

[Compose规范](https://github.com/compose-spec/compose-spec/blob/master/spec.md)

## Compose file version 3
[Version 3](https://docs.docker.com/compose/compose-file/compose-file-v3/)

### compose file结构和示例
```yaml
version: "3.9"
services:

  redis:
    image: redis:alpine
    ports:
      - "6379"
    networks:
      - frontend
    deploy:
      replicas: 2
      update_config:
        parallelism: 2
        delay: 10s
      restart_policy:
        condition: on-failure

  db:
    image: postgres:9.4
    volumes:
      - db-data:/var/lib/postgresql/data
    networks:
      - backend
    deploy:
      placement:
        max_replicas_per_node: 1
        constraints:
          - "node.role==manager"

  vote:
    image: dockersamples/examplevotingapp_vote:before
    ports:
      - "5000:80"
    networks:
      - frontend
    depends_on:
      - redis
    deploy:
      replicas: 2
      update_config:
        parallelism: 2
      restart_policy:
        condition: on-failure

  result:
    image: dockersamples/examplevotingapp_result:before
    ports:
      - "5001:80"
    networks:
      - backend
    depends_on:
      - db
    deploy:
      replicas: 1
      update_config:
        parallelism: 2
        delay: 10s
      restart_policy:
        condition: on-failure

  worker:
    image: dockersamples/examplevotingapp_worker
    networks:
      - frontend
      - backend
    deploy:
      mode: replicated
      replicas: 1
      labels: [APP=VOTING]
      restart_policy:
        condition: on-failure
        delay: 10s
        max_attempts: 3
        window: 120s
      placement:
        constraints:
          - "node.role==manager"

  visualizer:
    image: dockersamples/visualizer:stable
    ports:
      - "8080:8080"
    stop_grace_period: 1m30s
    volumes:
      - "/var/run/docker.sock:/var/run/docker.sock"
    deploy:
      placement:
        constraints:
          - "node.role==manager"

networks:
  frontend:
  backend:

volumes:
  db-data:
```

### Service配置
使用一个yaml文件来定义 services, networks, volumes.

默认使用的compose file路径为：`./docker-compose.yml`

#### build
配置镜像构建时要应用的设置项

##### context
指定build构建时的上下文目录，即构建阶段的工作目录，该目录下包含`Dockerfile`文件

* 示例
    ```yaml
    build:
      context: ./dir
    ```
##### dockerfile

## Compose file version 2
[Version 2](https://docs.docker.com/compose/compose-file/compose-file-v2/)