在一个docker容器中运行多个程序进程的Dockerfile编写
==

## 背景知识
Docker容器的哲学是一个Docker容器只运行一个进程。

有时候我们就是需要在一个Docker容器中运行多个进程，

那么基本思路是在Dockerfile 的`CMD` 或者 `ENTRYPOINT` 运行一个"东西",然后再让这个"东西"运行多个其他进程。

简单说来是用Bash Shell脚本或者三方进程守护 (Monit, Skaware S6, Supervisor)，其他没讲到的三方进程守护工具同理。

## Shell脚本
入口文件运行一个Bash Shell 脚本, 然后在这个脚本内去拉起多个进程。

注意最后要增加一个死循环不要让这个脚本退出,否则拉起的进程也退出了。

用Bash Shell 的方式,任意发行版的linux都支持,  
缺点是不能拉起crash(崩溃)的进程,也就是只能拉起运行**不能守护**  
如果不关心进程crash问题那么可以用这种方式

* run.sh
    ```bash
    #!/bin/bash
    
    # start 1
    start1  > /var/log/start1.log 2>&1 &
    # start 2
    start2 > /var/log/start2.log 2>&1 &
    
    # just keep this script running
    while [[ true ]]; do
        sleep 1
    done
    ```

* 在Dockerfile的入口中运行run.sh
    ```text
    FROM ubuntu:latest
    ...
    COPY ./run.sh /
    ENTRYPOINT  ["run.sh"]
    ```

## 第三方进程守护
### dumb-init
* dumb-init是什么

    [dumb-init官方](https://github.com/Yelp/dumb-init)
    
    A minimal init system for Linux containers
    一个最小化的Linux容器初始化系统。
    
    dumb-init是一个简单的进程监控器和init系统，  
    设计为在最小容器环境(如Docker)中作为PID 1运行。  
    它被部署为一个用C编写的小型静态链接二进制文件。

    ServiceMesh的数据平面Envoy Proxy的容器镜像就是使用的dumb-init

* Dockerfile示例
    ```text
    # Runs "/usr/bin/dumb-init -- /my/script --with --args"
    ENTRYPOINT ["/usr/bin/dumb-init", "--"]
    
    # or if you use --rewrite or other cli flags
    # ENTRYPOINT ["dumb-init", "--rewrite", "2:3", "--"]
    
    CMD ["/my/script", "--with", "--args"]
    ```

### tini
* 是什么

    [tini官方](https://github.com/krallin/tini)  
    A tiny but valid init for containers
    容器的一个小而有效的init
* Dockerfile示例
    ```text
    # Add Tini
    ENV TINI_VERSION v0.19.0
    ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
    RUN chmod +x /tini
    ENTRYPOINT ["/tini", "--"]
    
    # Run your program under Tini
    CMD ["/your/program", "-and", "-its", "arguments"]
    # or docker run your-image /your/program ...
    ```

### Monit
* 是什么
    [monit](https://mmonit.com/monit/)
    
    Monit和Supervisor还是有很大区别的，Supervisor管理的都是前台执行的进程，  
    Monit既可以管理前台进程也可以管理后台进程，  
    简单的说，在CentOS中使用service xxx start 启动的程序，使用Monit可以直接管理，  
    这就解决了很多没有前台方式启动的程序不能用Supervisor来管理的问题。

monit监控的服务无需前台运行，使用一般的服务文件启动即可。但是有一点限制就是，这个服务必须要有pid文件，如果某个服务没有pid文件，那么monit也就没办法操作了。

* Dockerfile示例

    在容器中启动sshd和apache
    ```text
    FROM centos  
    
    # 配置sshd服务--start
    RUN echo "root:pw12346" |chpasswd
    RUN ssh-keygen -t das -f /etc/ssh/ssh_host_das_key
    RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key
    RUN sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config
    RUN mkdir /var/run/sshd  
    
    ## install ssh, apach, monit
    RUN yum install -y monit openssh-server httpd
    RUN chmod 700 /etc/monit.conf
    COPY monit-sshd.conf /etc/monit.d/monit-sshd.conf
    COPY monit-httpd.conf /etc/monit.d/monit-httpd.conf
    
    EXPOSE 22 80 9001
    ENTRYPOINT ["/usr/bin/monit","-I"]
    ```
    monit的默认配置文件：
    /etc/monit.conf, /etc/monit.conf, /usr/local/etc/monit.conf 
    
    * monit-sshd.conf
        ```text
        check process sshd with pidfile /var/run/sshd.pid
            every 2 cycles
            start program = "/sbin/service sshd start"
            stop program = "/sbin/service sshd stop"
            if failed port 22 type TCP then start
        ```
    * monit-httpd.conf
        ```text
        check process httpd with pidfile /var/run/httpd/httpd.pid
            start program = "/sbin/service httpd start"
            stop program = "/sbin/service httpd stop"
            if failed port 80 type TCP then start
        ```
    
    * build image
        ```bash
        docker buld -t momit/sshd_httpd:0.1 .
        ```
        
    * test image
        ```bash
        docker run -d -p 80:80 -p 2222:22 -p 9001:9001 momit/sshd_httpd:0.1
        ```
        访问 `http://宿主机ip:9001`
### Supervisor
官网 http://www.supervisord.org/

Supervisor要以前台程序运行,如果是后台的方式docker会退出.

Supervisor的配置文件
```text
[supervisord]
nodaemon=true
```

* Dockerfile示例
    ```text
    ENTRYPOINT ["supervisord", "-c", "/etc/supervisor/conf.d/youconf.conf"]
    ```

### Skaware S6
* 是什么

    Supervisor是常见的进程守护程序，不过程序文件太大，想要容器镜像尽量小,在特别是用Alpine作为基础镜像的时候推荐使用Skaware S6
    参考这个微服务基础镜像 https://github.com/nicholasjackson/microservice-basebox 他就是用 Skaware 作为进程守护程序运行多个进程的
    如果基础容器镜像是本身就是Alpine,那就再合适不过了

* Dockerfile示例
    ```text
    # skaware s6 daemon runner
    RUN mkdir /s6 \
     && wget --no-check-certificate https://github.com/just-containers/skaware/releases/download/v1.21.2/s6-2.6.1.1-linux-amd64-bin.tar.gz \
     && tar -xvzf s6-2.6.1.1-linux-amd64-bin.tar.gz --directory /s6 --strip-components=1 \
     && mv /s6/bin/* /usr/bin \
     && rm -rf s6-2.6.1.1-linux-amd64-bin.tar.gz \
     && rm -rf /s6 \
     && cd /usr/bin/ \
     && chmod -R 755 s6-accessrules-cdb-from-fs s6-accessrules-fs-from-cdb \
        s6-applyuidgid s6-cleanfifodir s6-connlimit s6-envdir s6-envuidgid \
        s6-fdholder-daemon s6-fdholder-delete s6-fdholder-deletec s6-fdholder-getdump \
        s6-fdholder-getdumpc s6-fdholder-list s6-fdholder-listc s6-fdholder-retrieve \
        s6-fdholder-retrievec s6-fdholder-setdump s6-fdholder-setdumpc s6-fdholder-store \
        s6-fdholder-storec s6-fdholder-transferdump s6-fdholder-transferdumpc s6-fdholderd \
        s6-fghack s6-ftrig-listen s6-ftrig-listen1 s6-ftrig-notify s6-ftrig-wait s6-ftrigrd \
        s6-ioconnect s6-ipcclient s6-ipcserver s6-ipcserver-access s6-ipcserver-socketbinder \
        s6-ipcserverd s6-log s6-mkfifodir s6-notifyoncheck s6-setlock s6-setsid s6-setuidgid \
        s6-softlimit s6-sudo s6-sudoc s6-sudod s6-supervise s6-svc s6-svlisten s6-svlisten1 \
        s6-svok s6-svscan s6-svscanctl s6-svstat s6-svwait s6-tai64n s6-tai64nlocal s6lockd ucspilogd \
     && cd -
    
    # 预处理s6配置文件
    RUN mkdir -p /etc/s6/.s6-svscan  \
     && ln -s /bin/true /etc/s6/.s6-svscan/finish  \
     && mkdir -p /etc/s6/cron \
     && mkdir -p /etc/s6/app \
     && ln -s /bin/true /etc/s6/cron/finish \
     && ln -s /bin/true /etc/s6/app/finish
    
    # corotab 文件内容
    ADD cronfile /var/spool/cron/root
    # 运行Bash 脚本
    ADD cron.run /etc/s6/cron/run
    ADD app.run /etc/s6/app/run
    
    ENTRYPOINT ["/usr/bin/s6-svscan","/etc/s6"]
    ```
    * cron.run example
        ```text
        #!/usr/bin/env bash
        exec crond -n
        ```

    * app.run example
        ```text
        #!/usr/bin/env bash
        exec app
        ```
### s6-overlay
* 是什么
    
    [s6-overlay 官网](https://github.com/just-containers/s6-overlay)  
    s6-overlay 是基于 Skaware S6适用于容器的进程守护工具
* Dockerfile示例
    ```text
    # Install s6-overlay 进程守护管理.
    ENV S6_VERSION v1.21.4.0
    RUN curl -L "https://github.com/just-containers/s6-overlay/releases/download/$S6_VERSION/s6-overlay-amd64.tar.gz" > /tmp/s6-overlay-amd64.tar.gz
    RUN tar xzf /tmp/s6-overlay-amd64.tar.gz -C / --exclude="./bin" && \
        tar xzf /tmp/s6-overlay-amd64.tar.gz -C /usr ./bin \
        && rm /tmp/s6-overlay-amd64.tar.gz
    ENV S6_BEHAVIOUR_IF_STAGE2_FAILS 1
    
    # Set up a standard volume for logs.
    VOLUME ["/var/log/services"]
    
    
    # 设置入口为 s6-based init.
    ENTRYPOINT ["/init"]
    ```

### runit
[runit官网](http://smarden.org/runit/)  
具体的使用方法见官网  
在Docker生态圈, phusion/baseimage-docker, gitlab 在使用runit作为进程管理工具

* 下面以要运行cron 和 ssh 为例
    ```text
    /etc/service/  // 为配置文件目录
    
    /etc/service/sshd  // 为要运行的程序目录
    /etc/service/sshd/run  // 为需要运行的程序入口脚本文件
    ```

    * /etc/service/sshd
        ```text
        #!/bin/sh
        set -e
        exec /usr/sbin/sshd -D
        ```
    * /etc/service/sshd/run
        ```text
        #!/bin/sh
        exec /usr/sbin/cron -f
        ```
    * Dockerfile示例
        ```text
        ENTRYPOINT ["/usr/bin/runsvdir","-P","/etc/service"]
        ```

### Systemd
在 docker 中使用 Systemd 需要在 docker run 的时候开启特权模式 `--privileged`,
所以不推荐

* Dockerfile示例
    ```text
    ENTRYPOINT ["/usr/sbin/init"]
    ```

运行容器
```bash
docker run -itd --name rockylinux --privileged rockylinux:9.1 /usr/sbin/init

// 或
docker run -itd --name rockylinux --privileged rockylinux:9.1
```
