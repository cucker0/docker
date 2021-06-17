Docker Compose
==

## 是什么
Compose is a tool for defining and running multi-container Docker applications.

Compose是一个用于定义和运行多容器Docker应用的工具。

* 使用一个YAML文件配置应用服务，然后执行单条compose命令就可以创建并启动YAML配置文件中定义的服务

## 使用Compose的3个基本步骤
1. 编写一个`Dockerfile`文件，定义应用的环境
2. 编写一个`docker-compose.yml`文件，定义要启动的服务。这些服务能同时运行，当它们都是在独立的容器环境
3. 执行`docker compose up`命令，启动并运行整个应用。  
    也可以使用docker-compose二进制可执行文件命令执行：`docker-compose up`
    
## 安装Compose
* 先决条件
    * Linux 系统要求先安装Docker Engine
    * Mac和Windows的Docker Desktop，已经包含了Compose

* 方法1
    * 安装Compose
    
        直接下载docker-compose二进制文件
        ```bash
        sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" \
        -o /usr/local/bin/docker-compose
        ```
        如要安装其他版本，把`1.29.2`替换为其他版本即可。  
        详细的版本见[compose releases](https://github.com/docker/compose/releases)
    * 给docker-compose文件可执行权
        ```bash
        sudo chmod +x /usr/local/bin/docker-compose
        ```
    * 把docker-compose文件软链接到`/usr/bin`
    
        以确保从默认的EVN环境变量中能找到docker-compose命令
        ```bash
        sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
        ```
* 方法2
    ```bash
    pip install docker-compose
    ```
    
* 测试安装结果
    ```bash
    $ docker-compose --version
    docker-compose version 1.29.2, build 5becea4c
    ```
## 删除Compose
```bash
sudo rm -rf /usr/local/bin/docker-compose
sudo rm -rf /usr/bin/docker-compose
```

如果是pip安装的compose，则
```bash
pip uninstall docker-compose
```

## docker-compose CLI命令
[docker-compose CLI](https://docs.docker.com/compose/reference/)

>docker-compose --help 显示结果
```bash
Define and run multi-container applications with Docker.

Usage:
  docker-compose [-f <arg>...] [--profile <name>...] [options] [--] [COMMAND] [ARGS...]
  docker-compose -h|--help

Options:
  -f, --file FILE             Specify an alternate compose file
                              (default: docker-compose.yml)
  -p, --project-name NAME     Specify an alternate project name
                              (default: directory name)
  --profile NAME              Specify a profile to enable
  -c, --context NAME          Specify a context name
  --verbose                   Show more output
  --log-level LEVEL           Set log level (DEBUG, INFO, WARNING, ERROR, CRITICAL)
  --ansi (never|always|auto)  Control when to print ANSI control characters
  --no-ansi                   Do not print ANSI control characters (DEPRECATED)
  -v, --version               Print version and exit
  -H, --host HOST             Daemon socket to connect to

  --tls                       Use TLS; implied by --tlsverify
  --tlscacert CA_PATH         Trust certs signed only by this CA
  --tlscert CLIENT_CERT_PATH  Path to TLS certificate file
  --tlskey TLS_KEY_PATH       Path to TLS key file
  --tlsverify                 Use TLS and verify the remote
  --skip-hostname-check       Don't check the daemon's hostname against the
                              name specified in the client certificate
  --project-directory PATH    Specify an alternate working directory
                              (default: the path of the Compose file)
  --compatibility             If set, Compose will attempt to convert keys
                              in v3 files to their non-Swarm equivalent (DEPRECATED)
  --env-file PATH             Specify an alternate environment file

Commands:
  build              Build or rebuild services
  config             Validate and view the Compose file
  create             Create services
  down               Stop and remove resources
  events             Receive real time events from containers
  exec               Execute a command in a running container
  help               Get help on a command
  images             List images
  kill               Kill containers
  logs               View output from containers
  pause              Pause services
  port               Print the public port for a port binding
  ps                 List containers
  pull               Pull service images
  push               Push service images
  restart            Restart services
  rm                 Remove stopped containers
  run                Run a one-off command
  scale              Set number of containers for a service
  start              Start services
  stop               Stop services
  top                Display the running processes
  unpause            Unpause services
  up                 Create and start containers
  version            Show version information and quit
```

## compose file的编写
[Compose file reference](compose_file.md)

## compose演示示例
[Get started with Docker Compose](https://docs.docker.com/compose/gettingstarted/)
