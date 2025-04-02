Dockerfile
==

## Table Of Contents
* [Dockerfile是什么](#Dockerfile是什么)
    * [构建步骤](#构建步骤)
* [Dockerfile构建过程分析](#Dockerfile构建过程分析)
    * [Dockerfile基础知识](#Dockerfile基础知识)
    * [构建流程](#构建流程)
* [Dockerfile指令关键字](#Dockerfile指令关键字)
    * [ARG](#ARG)
    * [FROM](#FROM)
    * [MAINTAINER (deprecated)](#MAINTAINER-deprecated)
    * [ENV](#ENV)
    * [WORKDIR](#WORKDIR)
    * [RUN](#RUN)
    * [ADD](#ADD)
    * [COPY](#COPY)
    * [LABEL](#LABEL)
    * [USER](#USER)
    * [VOLUME](#VOLUME)
    * [CMD](#CMD)
    * [ENTRYPOINT](#ENTRYPOINT)
    * [EXPOSE](#EXPOSE)
    * [ONBUILD](#ONBUILD)
    * [STOPSIGNAL](#STOPSIGNAL)
    * [HEALTHCHECK](#HEALTHCHECK)
    * [SHELL](#SHELL)
    * [特别说明](#特别说明)
        * [ADD or COPY](#ADD-or-COPY)
        * [CMD与ENTRYPOINT的交互](#CMD与ENTRYPOINT的交互)
        * [ENTRYPOINT与CMD组合使用的不同情况](#ENTRYPOINT与CMD组合使用的不同情况)
* [自定义镜像](#自定义镜像)


## Dockerfile是什么
[Dockerfile reference](https://docs.docker.com/engine/reference/builder)  
[environment-replacement](https://docs.docker.com/engine/reference/builder/#environment-replacement)

Dockerfile是用来构建docker image的构建文件。
由一系列命令和参数构成的脚本文件，是一个文本文件。

centos7 Dockerfile示例
```bash
FROM scratch
ADD centos-7-x86_64-docker.tar.xz /

LABEL \
    org.label-schema.schema-version="1.0" \
    org.label-schema.name="CentOS Base Image" \
    org.label-schema.vendor="CentOS" \
    org.label-schema.license="GPLv2" \
    org.label-schema.build-date="20201113" \
    org.opencontainers.image.title="CentOS Base Image" \
    org.opencontainers.image.vendor="CentOS" \
    org.opencontainers.image.licenses="GPL-2.0-only" \
    org.opencontainers.image.created="2020-11-13 00:00:00+00:00"

CMD ["/bin/bash"]
```

### 构建步骤
1. 编写Dockerfile文件
2. docker build构建镜像
    ```bash
    docker build [OPTIONS] PATH | URL | -
    ```
    
    PATH | URL: 指定build时的上下文目录，即运行docker build时的工作目录（workdir）
    `-` : 无上下文目录。Dockerfile 从 `STDIN` 读取。将不支持ADD,COPY命令
    Options:
    ```text
    -f, --file string             Name of the Dockerfile (Default is 'PATH/Dockerfile')
    -t, --tag list                Name and optionally a tag in the 'name:tag' format
    ```
    Build with -
    ```bash
    # Dockerfile从/opt/docker/Dockerfile读取
    docker build - < /opt/docker/Dockerfile
    
    # Dockerifle从/opt/docker/context.tar.gz读取
    docker build - < /opt/docker/context.tar.gz
    ```
        
    * 示例1
        ```bash
        cd /mydocker/jdk_tomcat
        docker build -f ./Dockerfile -t hanxiao2100/tomcat:10 .
        ```
    
3. docker run

## Dockerfile构建过程分析
### Dockerfile基础知识
* Dockerfile指令必须大写，每个指令后需要至少有一个参数
* 指令按照Dockerfilew文件，从上到下，顺序执行
* 行注释符：`#`
* 连接符、默认的转义字符：`\ `反斜杠

    自定义转义符，建议写在Dockerfile的开头。  
    如：定义`(backtick反引号)为转义符
    ```text
    # escape=`
    ```
* 每条指令都会创建一个新的镜像层，并对新的镜像进行提交

### 构建流程
1. docker daemon读取Dockerfile文件，从上往下顺序执行
2. docker daemon从基础镜像(basic image)运行一个容器
3. 执行一条指令并对容器做出修改
4. 执行类似docker commit操作，提交一个新的镜像层
5. docker daemon在基于上面提交的新镜像运行一个容器
6. 然后再执行Dockerfile文件中的下一条指令。依此执行下去，直到所有指令都执行完成

## Dockerfile指令关键字
### 注释符
与shell、python注释符相同
```text
# 
```

### ARG    
```text
定义变量，用于用户执行docker build命令时，把变量传递给Dockerfile引用。

可以放在 Dockerfile任何位置。这是唯一一个可以放在 FROM 指令之前的指令

可以定义多个ARG，写多行
```
* syntax
    ```text
    ARG <name>[=<default value>]
    ```
* 示例
    ```text
    ARG 
    ```
* 如何传参给ARG定义的变量
    ```bash
    docker build -f Dockerfile_PATH --build-arg <varname1>=<value1> --build-arg <varname2>=<value2> PATH
    ```
    
### FROM
```text
初始化新的构建阶段(build stage)，并设置基础镜像(Base Image)

FROM <base_image> 背后所做的操作就是：ADD base_image的/ /
    也即使把基础镜像的 整个 RootFS 复制过来，
    所有docker history查看镜像的最后一条都是 `/bin/sh -c #(nop) ADD file:xxx in /`

Dockerfile必须以一个 FORM 指令开始，即一般以 FORM 为第一行。Docker 17.05即之后支持多FROM
当然如有变量要传递，ARG可以在FROM之前。
"FROM之前定义的ARG变量，只能FROM引用"，FROM之后的指令不要引用

因为FROM指令之前还没有进入构建阶段。如果FROM 之后的指令引用了FROM之前定义的ARG变量，那么其变量没有值。
```
* syntax
    ```dockerfile
    FROM [--platform=<platform>] <image>[:<tag>] [AS <name>]
    ```
    或
    ```dockerfile
    FROM [--platform=<platform>] <image>[@<digest>] [AS <name>]
    ```
    * 省略`:tag`，缺省为`latest`
    * AS name: 设置阶段名
    
* 示例
  
    示例1
    ```dockerfile
    
    ARG VERSION=latest
    FROM busybox:$VERSION
    ```
    
    示例2
    ```bash
    FROM alpine:3.13
    ```
    
* [多FROM的用法](Dockerfile多FROM指令存在的意义.md)
 
### MAINTAINER (deprecated)
```text
设置维护作者信息，如姓名、email等

已弃用，使用LABEL，可以设置更多灵活的版本信息
```

* syntax
    ```dockerfile
    MAINTAINER <name>
    ```
* 示例
    ```text
    MAINTAINER "NGINX Docker Maintainers <docker-maint@nginx.com>"
    ```
    
    LABEL表示方法
    ```text
    LABEL maintainer="NGINX Docker Maintainers <docker-maint@nginx.com>"
    ```

### ENV
```text
设置环境变量，已设置的变量可在构建阶段中使用，也可以在容器中使用。

可写多个
```
* syntax
    ```dockerfile
    ENV <key>=<value> ...
    ```
* 示例
    ```dockerfile    
    ENV MY_NAME="John Doe" MY_DOG=Rex\ The\ Dog \
        MY_CAT=fluffy
    ENV MY_NAME="John Doe"
    ENV MY_CAT=fluffy
    ```
    
    **添加系统环境变量**  
    ```dockerfile  
    ENV PATH=$PATH:/usr/local/siege/bin
    ```
    相当于在 /etc/profile 添加 export PATH=$PATH:/usr/local/siege/bin  
    但Dockerfile中`RUN echo export PATH=$PATH:/usr/local/siege/bin >> /root/.bash_profile`，在容器中不生效。需要在运行的容器中执行 `. /etc/profile` 
    如果非要这么干，可以 `RUN echo export PATH=$PATH:/usr/local/siege/bin >> /root/.bash_profile`
    
### WORKDIR
为Dockerfile中的`RUN`, `CMD`, `ENTRYPOINT`, `COPY`, `ADD`指令设置"工作目录"

可写多个，建议只写一个。

多个WORKDIR相对路径将最终合并成一个.

多个WORKDIR绝对路径的，只有最后一个生效。

基础镜像中的`WORKDIR`值 不会被子镜像继承。

**一个镜像中，`WORKDIR`缺省的默认值为`/`**

[参考官网](https://docs.docker.com/engine/reference/run/#workdir)

* syntax
    ```text
    WORKDIR /path/to/workdir
    ```
    * 如果指定的工作目录不存在(容器中)，则自动创建
    * `docker run -w "工作目录路径"`将覆盖Dockerfile中指定的`WORKDIR`
    * `WORKDIR`可以引用ENV环境变量
* 示例
    ```dockerfile
    # 示例1
    WORKDIR /usr/local/service
    
    # 示例2
    ENV DIRPATH=/path
    WORKDIR $DIRPATH/service
    ```
### RUN
镜像构建时需要运行的命令

`RUN`指令将在当前镜像的最顶层(可写层)执行命令并提交结果。每执行一次`RUN`将生成一个镜像，该镜像将用于`Dockerfile`下一步的指令。

分层运行指令并提交结果，类似于git的源码管理。

可写多个该指令

* syntax
    * shell form
        ```dockerfile
        RUN <command>
        ```
        the command is run in a shell, which by default is  
        `/bin/sh -c` on Linux  
        or `cmd /S /C` on Windows
        
        * 可以使用`SHELL`指令修改exec from格式的默认shell
    * exec form
        ```dockerfile
        RUN ["executable", "param1", "param2"]
        ```
        * executable写绝对路径。不能使用env环境变量
        * 尽量避免使用 `/bin/sh -c ''`这种shell壳来执行命令。
        * executable一般为二进制可执行文件，尽量不写shell脚本
        * JSON数组的元素必须使用`"`双引号包裹

* 示例
    ```dockerfile
    RUN yum -y install nginx
    RUN groupadd -r mysql && useradd -r -g mysql mysql
    ```
* 注意事项
    * `RUN`指令会产生的缓存，缓存不会自动清除，即docker build时会使用到`RUN`产生的缓存
        ```dockerfile
        RUN yum -y install redis
        ```
        会下载redis安装包并缓存
        
    * docker build时不使用缓存
        ```text
        docker build --no-cache
        ```

### ADD
将宿主机上的文件、目录、远端的URL资源复制到镜像中。

有本地tar压缩文件提取到镜像，下载URL资源到镜像的功能

* syntax
    ```dockerfile
    ADD [--chown=<user>:<group>] <src>... <dest>

    # 路径中有空格的解决方法
    ADD [--chown=<user>:<group>] ["<src>",... "<dest>"]
    ```
    * <src>必须位于build的上下文目录内(build context)。不能超出此路径范围
    * 当<src>为目录时，则复制目录下的全部内容，包括文件系统元数据。
    * 如果 <src> 资源为宿主机本地的tar压缩包文件（.gz, tar.gz, .xz, tar.xz, .gzip, .bzip2等），在镜像中将解压到<dest>目录，行为类似于 tar -x XX.tar.gz -C <dest> 
        即**将本地的tar文件提取到镜像中**
    * 如果 <src> 资源为URL资源时，在镜像中将不解压，直接下载
    * 当<src>为其它任何类型的文件，且<dest>以/结尾，则镜像中<src>将复制为<dest>/base(<src>)
        示例：
        >ADD ./app/start.sh /data/
        
        则 `start.sh` 将复制到镜像的 `/data/app/start.sh`
    * 当有多个<src>时，<dest>必须以/结尾
    * --chown=<user 只对linux系统有效
    * 当<dest>目录不存在时，将会自动创建该目录
* 示例
    ```dockerfile
    # pkg/etc/named/ 下的所以文件或子目录下的文件，都复制到 /usr/local/bind/etc/named/ 下，不创建子目录。
    ADD pkg/etc/named/* /usr/local/bind/etc/named/
    # pkg/etc/named/ 下的所以文件或子目录下的文件，都复制到 /usr/local/bind/etc/named/ 下，保持原的子目录结构
    ADD pkg/etc/named/ /usr/local/bind/etc/named/
    ADD test.txt /absoluteDir/
    ADD hom* /mydir/
    ADD hom?.txt /mydir/
    ADD --chown=55:mygroup files* /somedir/
    ADD --chown=1 files* /somedir/
    ADD ./glibc-2.28/libc.a ./glibc-2.28/libc_pci.a ./glibc-2.28/*.so /usr/lib/
    ADD ["./glibc-2.28/libc.a", "./glibc-2.28/libc_pci.a", "/usr/lib/"]
    ```


### COPY
从宿主上复制文件或目录到镜像中


* syntax
    ```dockerfile
    COPY [--chown=<user>:<group>] <src> ... <dest>
    
    # 路径中有空格
    COPY [--chown=<user>:<group>] ["<src>", ... "<dest>"]
    ```
    * \<src>必须位置build的上下文目录内。不能超出此路径范围
    * 当\<src>为目录时，则复制目录下的全部内容，包括文件系统元数据。
    * 当\<dest>目录不存在时，将会自动创建该目录
    * \<src>不支持URL
   
* 示例
    ```dockerfile
    COPY test.txt /absoluteDir/
    COPY hom* /mydir/
    COPY --chown=55:mygroup files* /somedir/
    COPY --chown=bin files* /somedir/
   
    # 复制目录， 把 ./go 目录复制到镜像的 /usr/local/go/
    COPY ./go /usr/local/go/
    相当于
    COPY ./go/* /usr/local/go/
    ```

#### COPY --from=
从build阶段中复制文件到镜像中，  
或从指定的镜像中复制文件到此镜像中(把外部的镜像作为一个"build stage")

[参考multistage-build](https://docs.docker.com/develop/develop-images/multistage-build/)
   
* syntax
    ```dockerfile
    COPY --from=<build_stage_name> <src> <dest>

    # 或
    COPY --from=<image> <src> <dest>
    ```
   
* 示例1
    ```dockerfile
    FROM golang:1.16 AS builder
    WORKDIR /go/src/github.com/alexellis/href-counter/
    RUN go get -d -v golang.org/x/net/html  
    COPY app.go    ./
    RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o app .

    FROM alpine:latest  
    RUN apk --no-cache add ca-certificates
    WORKDIR /root/
    COPY --from=builder /go/src/github.com/alexellis/href-counter/app ./
    CMD ["./app"] 
    ```
   
* 示例2
    ```dockerfile
    COPY --from=nginx:latest /etc/nginx/nginx.conf /nginx.conf
    # 复制目录
    COPY --from=nginx:latest /usr/local/nginx /usr/local/nginx/
    
    # 复制多个文件
    ARG glibc_dir=/usr/local/src/glibc-2.28
    # 或
    # ENV glibc_dir=/usr/local/src/glibc-2.28
    COPY --from=cucker/golang:1.17.1-glibc-static ${glibc_dir}/*.a \
        ${glibc_dir}/nptl/libpthread.a \
        ${glibc_dir}/dlfcn/libdl.a \
        /usr/lib64/
   ```
### LABEL
给镜像设置metadata元数据。

可以添加维护作者信息、项目的组织信息、licensing许可信息、版本信息等

可写多个

* syntax
    ```dockerfile
    LABEL <key>=<value> <key>=<value> <key>=<value> ...
    ```
* 示例
    ```dockerfile
    LABEL maintainer="NGINX Docker Maintainers <docker-maint@nginx.com>"
    LABEL com.example.version="0.0.1-beta"
    LABEL vendor1="ACME Incorporated"
    LABEL vendor2=ZENITH\ Incorporated
    
    LABEL multi.label1="value1" \
          multi.label2="value2" \
          other="value3"
    ```  

### USER
镜像运行时使用的用户和组。

为Dockerfile文件中的RUN, CMD, ENTRYPOINT指令指定运行的用户和组

* syntax
    ```dockerfile
    USER <user>[:<group>]
    
    # or
    USER <UID>[:<GID>]
    ```
* 示例
    ```dockerfile
    # Create a group and an user
    RUN groupadd -r postgres && useradd --no-log-init -r -g postgres postgres
    # 为后续命令指定用户
    USER postgres
    ```

### VOLUME
创建容器数据卷。用于数持久化

创建具体指定名称的挂载点，将其标识为用来保存来自宿主机或其他容器的数据卷

* syntax
    ```dockerfile
    VOLUME ["/data", "/data2"]
    ```
    值可以是一个json数组 或是多个参数的字符串（空格隔开）
* 示例
    ```bash
    VOLUME ["/var/log", "/var/db"]
    
    # 或
    VOLUME /var/log /var/db
    ```

### CMD
设置容器启动时要运行的主命令(main command)，或为`ENTRYPOINT`定义默认的参数

Dockerfile中只需要一个`CMD`，如果有写多个`CMD`，只有最后一个`CMD`生效，所以建议只写一个

`CMD`在镜像构建阶段中不会做任何事情。

而`RUN`是会执行的命令，并会提交结果

* syntax（有三种格式）
    * exec form，首选格式
        ```dockerfile
        CMD ["executable","param1","param2"]
        ```
        * 执行的命令：`executable param1 param2`
        * 进程的PID为1
        * executable为非shell的可执行程序时，要求写完整路径
        * []JSON数组里的元素必须以双引`"`号包裹，不能是单引号`'`
        * 不能引用环境变量
                    
            不可用示例
            ```dockerfile
            CMD [ "echo", "$HOME" ]
            ```
            如果非要使用环境变量，可以这么干
            ```dockerfile
            CMD [ "sh", "-c", "echo $HOME" ]
            ```
    * 作为`ENTRYPOINT []`的默认参数，这也是exec form。这也是CMD的主要用途。[参考 CMD为ENTRYPOINT定义默认参数](Dockerfile中ENTRYPOINT和CMD的区别.md#CMD为ENTRYPOINT定义默认参数)
        ```dockerfile
        CMD ["param1","param2"]
        ```
    * shell form
        ```dockerfile
        CMD command param1 param2
        ```
        * 执行的命令：`/bin/sh -c "command param1 param2"`
        * 执行的程序为/bin/sh的子进程，PID不是1。会有类似 ENTRYPOINT shell格式的问题
        
* 当docker run容器指定了额外的参数时，`CMD`定义的命令将会被覆盖。**上面三种格式都一样**。    
    `docker run <image>  param1 param2`相当于，新建 `CMD [param1, param2]`，覆盖原来的CMD

* 示例
    ```dockerfile
    FROM debian:buster-slim
        
    CMD ["/usr/sbin/nginx", "-g", "daemon off;"]
    ```
    ```dockerfile
    FROM ubuntu
    CMD ["/usr/bin/wc","--help"]
    ```

### ENTRYPOINT
设置容器启动时要运行的主命令(main command)

ENTRYPOINT 的目的和 CMD 一样，都是指定容器启动时要运行的程序及参数

只需要一个`ENTRYPOINT`，如果有写多个`ENTRYPOINT`，只有最后一个`ENTRYPOINT`生效，所以建议只写一个

* syntax（有两种格式）

    * exec form，首选格式
        ```dockerfile
        ENTRYPOINT ["executable", "param1", "param2"]
        ```
        * 执行的命令：`executable param1 param1`
        * 会追加`CMD` 或`docker run <image> param ...`的参数，到`ENTRYPOINT []`的最后面
        * 启动容器后传递参数的情况`docker run <image> param1 param2 param3`  
            建新建一个`CMD [param1, param2, param3]`, 覆盖原来定义的CMD，  
            再讲新的CMD参数追加到`ENTRYPOINT`的命令后面
        * 启动的程序进程ID为1，PID 1
        * []JSON数组里的元素必须以双引`"`号包裹，不能是单引号`'`
        * 不能引用环境变量
            
            不可用示例
            ```dockerfile
            ENTRYPOINT [ "echo", "$HOME" ]
            ```
            如果非要使用环境变量，可以这么干
            ```dockerfile
            ENTRYPOINT [ "sh", "-c", "echo $HOME" ]
            ```
        * 当docker run容器指定了额外的参数时，`CMD`定义的命令将会被覆盖。  
              `docker run <image>  param1 param2`相当于，新建 `CMD [param1, param2]`，覆盖原来的CMD
    
    * shell form
        ```dockerfile
        ENTRYPOINT command param1 param2
        ```
        * 执行的命令：`/bin/sh -c "command param1 param2"`，执行的程序是一个/bin/sh的子进程
        * **不接收`CMD` 或`docker run <image> param ...`的参数** 
        * 启动的程序**进程ID不是1**  
            如果非要把启动程序的PID弄为1(主进程)，可以这么干，在原来的命令前加 exec，表示使用可执行程序来运行
            ```dockerfile
            FROM ubuntu
            ENTRYPOINT exec command param1 param2
            ```
        * Docker daemon与容器之间不能传递Unix signals，所以执行像`docker stop <container>`时，容器中的程序不能接受到`SIGTERM`，会出现超时（默认10s），最后容器被强制kill

* 启动容器时覆盖镜像中默认的 ENTRYPOINT
    ```bash
    docker run --entrypoint 可执行的二进制程序
    
    # 下列的情况将不生效
        docker run --entrypoint sh -c "..."
        docker run --entrypoint /bin/sh -c "..."
    ```

### EXPOSE
**通知Docker daemon**：当前容器在运行时**监听**了指定的端口。还没有发布端口

主要对于发布随机端口有用（docker run -P）。

EXPOSE指定的端口与发布的端口没有直接的关系。docker run -p 本机端口8888:容器8080 是否发布成功，与容器是否监听了8080端口有关系

可写多个该指令，结果为并集

也可以只写一个该指令，EXPOSE可以同时指定多个端口

* syntax
    ```dockerfile
    EXPOSE <port> [<port>/<protocol>...]
    ```
    * `<port>/<protocol>`，省略`/<protocol>`时，表示`TCP`
* 示例
    ```dockerfile
    EXPOSE 80/tcp 443/tcp
    EXPOSE 53/udp
    ```    
* 映射容器中的端口到宿主机，并对外发布
    * 语法
    
        `-p`单个映射
        ```bash
        docker run -p [host_ip:]<host_port>:<container_port[/protocol]> ...
        ```
        * 省略`host_ip:`，表示映入主机的IP为`0.0.0.0`，即所有IP
        * `/protocol`，可选项有：`/tcp`, `/udp`, `/sctp`，缺省时默认为`/tcp`
        `-P`批量映射（主机随机大号端口）
        ```bash
        docker run -P <image>
        ```
        一次性自动映射容器中的端口到宿主机，并对外发布。映射的主机端口号是随机的（使用比较大的端口号）
        
    * 示例
        ```bash
        docker run -p 80:80 443:443/tcp 53:53/udp -d --name centos01 nginx:1.21.0
        ```
### ONBUILD
给镜像添加一条触发指令，当该镜像作为基础镜像（父镜像），其下游镜像(子镜像)在执行docker build时，此基础镜像就会执行已定义的触发指令。
孙及更小的后代docker build时不会在执行其原始祖先的ONBUILD指令。  
因为原始祖先的ONBUILD指令已经在原始祖先的子镜像中执行了，执行的结果已经被继承下来了。

触发指令将在下游镜像build构建的上下文中执行，效果如同：在紧跟下游的Dockerfile`FROM`指之后插入了这条触发指令

我们使用父镜像(即这个Dockerfile中含ONBUILD指令的镜像)时，`ONBUILD`不会生产任何作用，它只对基于它为基础镜像的下游镜像有作用。

可写多个该指令

使用场景
```text
在实际工作中，利用ONBUILD指令,通常用于创建一个模板镜像，
后续可以根据该模板镜像创建特定的子镜像，
需要在子镜像构建过程中执行的一些通用操作
就可以在模板镜像对应的dockerfile文件中用ONBUILD指令指定。 

从而减少dockerfile文件的重复内容编写。
```

* syntax
    ```dockerfile
    ONBUILD <INSTRUCTION>
    ```
* 示例
    ```dockerfile
    ONBUILD ADD . /app/src
    ONBUILD RUN /usr/local/bin/python-build --dir /app/src
    ```
    
* 注意事项
    * 不能使用链式的`ONBUILD`，即`ONBUILD ONBUILD`不支持
    * `ONBUILD`无法触发`FROM`、`MAINTAINER`
    * 在`ONBUILD`使用`ADD`、`COPY`时，就确保引用资源在宿主机上存在，否则build构建将失败

* [ONBUILD实验测试](ONBUILD_test.md)

### STOPSIGNAL
定义执行`docker stop`发送给当前容器的stop-signal（停止信号）。

以便容器在退出前，可以先做一些事情，实现容器的平滑退出。

* syntax
    ```dockerfile
    STOPSIGNAL signal
    ```
    * signal可以是无符号的数字，该信号与kernel的syscall表的位置对应。如9，表示强制退出信号
    * signal也可以是信号名，要求符合SIGNAME格式。如SIGKILL，即kill信号
* 示例（[nginx Dockerfile](https://hub.docker.com/_/nginx)）
    ```text
    FROM debian:buster-slim
    
    LABEL maintainer="NGINX Docker Maintainers <docker-maint@nginx.com>"
    ...
    ENTRYPOINT ["/docker-entrypoint.sh"]
    
    EXPOSE 80
    
    STOPSIGNAL SIGQUIT
    
    CMD ["nginx", "-g", "daemon off;"]
    ```
* 为什么要有STOPSIGNAL
    ```text
    主要的目的是为了让容器内的应用程序在接收到stop-signal(停止信号)之后可以先做一些事情，实现容器的平滑退出。
    默认情况下，容器将在一段时间之后强制退出，会造成业务的强制中断，这个时间默认是10s  
  
    docker stop <container> 发送的默认stop-signal是SIGTERM，在docker stop的时候会给容器内PID为1的进程发送这个signal，
    另外也可以通过create/run的参数--stop-signal可以设置自己需要的signal，效果与Dockerfile同定义STOPSIGNAL相同。
    以上两种方式指定了 stop-signal后，执行 docker stop <container> 时就会发送指定的stop-signal停止信号
    ```
    
### HEALTHCHECK
容器健康检测。  
通知Docker daemon：怎样检测当前容器是一直在工作的。

例如：可以检测WEB服务器卡在无限一循环中，无法处理新的连接，但服务进程却一直运行

* syntax

    两种格式
    * 通过运行容器内的命令来检测容器是否健康
        ```dockerfile
        HEALTHCHECK [OPTIONS] CMD
        ```
        OPTIONS:
        * `--interval=DURATION` (default: 30s)
        * `--timeout=DURATION` (default: 30s)
        * `--start-period=DURATION` (default: 0s)
        * `--retries=N` (default: 3)
    
    * 禁止从基础镜像中继承任何的健康检测
        ```dockerfile
        HEALTHCHECK NONE
        ```
* 示例
    ```dockerfile
    HEALTHCHECK --interval=5m --timeout=3s \
      CMD curl -f http://localhost/ || exit 1
    ```

### SHELL
为`shell form`格式的命令指定新的默认shell，会覆盖`shell form`命令原来默认的shell。

`shell form`格式的指令主要有:   
    `CMD command param1 param2`、  
    `ENTRYPOINT command param1 param2`、  
    `RUN <command>`

SHELL指令可以出现多次。每一条SHELL指令都会覆盖所有以前的SHELL指令，并影响所有后续指令。

* Linux的`shell form`默认shell是`["/bin/sh", "-c"]`
* Windows的`shell form`默认shell是`["cmd", "/S", "/C"]`

* syntax
    ```dockerfile
    SHELL ["executable", "parameters"]
    ```
* 示例
   ```dockerfile
   FROM microsoft/windowsservercore

   # Executed as cmd /S /C echo default
   RUN echo default

   # Executed as cmd /S /C powershell -command Write-Host default
   RUN powershell -command Write-Host default

   # Executed as powershell -command Write-Host hello
   SHELL ["powershell", "-command"]
   RUN Write-Host hello

   # Executed as cmd /S /C echo hello
   SHELL ["cmd", "/S", "/C"]
   RUN echo hello
   ```
    

### 特别说明
#### ADD or COPY
* 只做复制的情况下，建议使用COPY，因为直接透明
* 如果需要把宿主机本地的tar压缩文件提取到镜像中，或下载URL资源到镜像中建议使用ADD

#### CMD与ENTRYPOINT的交互
CMD和ENTRYPOINT都能定义容器启动时要执行的命令。

**CMD与ENTRYPOINT组合使用的规则**
1. Dockerfile中至少要指定一个`CMD`或`ENTRYPOINT`命令
2. 把容器当可执行文件用，使用`ENTRYPOINT`
3. `CMD`用于给`ENTRYPOINT`命令定义默认参数，当docker run有传递参数时，该默认参数会被覆盖。  
    且`ENTRYPOINT`只能用 exec form写法
4. `CMD`用于在容器中执行特殊的命令
5. 当docker run容器指定了额外的参数时，`CMD`定义的命令将会被覆盖。  
    `docker run <image>  param1 param2`相当于，新建 `CMD [param1, param2]`，覆盖原来的CMD


#### ENTRYPOINT与CMD组合使用的不同情况
* 其中`CMD`和`ENTRYPOINT`指令不区分先后顺序，哪个在前都一样

\# |No ENTRYPOINT |ENTRYPOINT exec_entry p1_entry |ENTRYPOINT ["exec_entry", "p1_entry"]
:--- |:--- |:--- |:--- 
No CMD |error, not allowed |/bin/sh -c exec_entry p1_entry |exec_entry p1_entry  
CMD ["exec_cmd", "p1_cmd"] |exec_cmd p1_cmd |/bin/sh -c exec_entry p1_entry |exec_entry p1_entry exec_cmd p1_cmd <br>不建议，一般运行不通  
CMD ["p1_cmd", "p2_cmd"] |p1_cmd p2_cmd |/bin/sh -c exec_entry p1_entry |exec_entry p1_entry p1_cmd p2_cmd
CMD exec_cmd p1_cmd |/bin/sh -c exec_cmd p1_cmd |/bin/sh -c exec_entry p1_entry |exec_entry p1_entry /bin/sh -c exec_cmd p1_cmd <br>不建议，一般运行不通  

* ENTRYPOINT 看上去与 CMD 很像，它们都可以指定要执行的命令及其参数。不同的地方在于 ENTRYPOINT 不会被忽略，一定会被执行，即使运行 docker run 时指定了其他命令。

* `ENTRYPOINT exec_entry p1_entry` shell格式写法，直接忽略`CMD参数`和`docker run <image> 参数`

* 如果在基础镜像(BASIC IMAGE)中定义了`CMD`，`ENTRYPOINT`将重置`CMD`为空值，那么必须在当前的镜像中定义`CMD`的值

* [Dockerfile中ENTRYPOINT和CMD的区别](Dockerfile中ENTRYPOINT和CMD的区别.md)

## 自定义镜像
* [自定义镜像--tomcat](custom_image.md)

## Dockerfile最佳实践
* 使用`RUN`指令安装应用和软件，构建镜像
* 如果镜像的用途是运行应用程序或服务，如运行一个MySQL，  
    应该优先使用`ENTRYPOINT`指令的exec格式写法。  
    `CMD` 可为 `ENTRYPOINT` 提供额外的默认参数，
    同时可利用 `docker run <image> 参数1 ...` 命令行替换默认参数。
* 如果想为容器设置默认的启动命令，可使用`CMD`指令。  
    用户可在`docker run <image> 参数1 ...`命令行中替换此默认命令
