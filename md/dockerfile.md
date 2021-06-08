Dockerfile
==

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
    
    PATH | URL: 指定上下文目录，即运行docker build时的工作目录（workdir）
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
3. docker run

### Dockerfile构建过程分析
#### Dockerfile基础知识
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

#### 构建流程
1. docker daemon读取Dockerfile文件，从上往下顺序执行
2. docker daemon从基础镜像(basic image)运行一个容器
3. 执行一条指令并对容器做出修改
4. 执行类似docker commit操作，提交一个新的镜像层
5. docker daemon在基于上面提交的新镜像运行一个容器
6. 然后再执行Dockerfile文件中的下一条指令。依此执行下去，直到所有指令都执行完成

### Dockerfile指令关键字
* ARG
    
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
    
* FROM
    ```text
    初始化新的构建阶段(build stage)，并设置基础镜像(Base Image)

    Dockerfile必须以一个 FORM 指令开始，即一般以 FORM 为第一行。Docker 17.05即之后支持多FROM
    当然如有变量要传递，ARG可以在FROM之前。
    "FROM之前定义的ARG变量，只能FROM引用"，FROM之后的指令不要引用
    
    因为FROM指令之前还没有进入构建阶段。如果FROM 之后的指令引用了ROM之前定义的ARG变量，那么其变量没有值
    FROM之后的指令引用
    ```
    * syntax
        ```text
        FROM [--platform=<platform>] <image>[:<tag>] [AS <name>]
        ```
        或
        ```text
        FROM [--platform=<platform>] <image>[@<digest>] [AS <name>]
        ```
        * 省略`:tag`，缺省为`latest`
        * AS name: 设置阶段名
        
    * 示例
      
        示例1
        ```bash
        
        ARG VERSION=latest
        FROM busybox:$VERSION
        ```
        
        示例2
        ```bash
        FROM alpine:3.13
        ```
        
    * [多FROM的用法](Dockerfile多FROM指令存在的意义.md)
     
* MAINTAINER (deprecated)
    ```text
    设置维护作者信息，如姓名、email等

    已弃用，使用LABEL，可以设置更多灵活的版本信息
    ```
    
    * syntax
        ```text
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
    
* ENV
    ```text
    设置环境变量，可在构建阶段中使用已设置的变量。

    可写多个
    ```
    * syntax
        ```text
        ENV <key>=<value> ...
        ```
    * 示例
        ```bash
        ENV MY_NAME="John Doe" MY_DOG=Rex\ The\ Dog \
            MY_CAT=fluffy
        ENV MY_NAME="John Doe"
        ENV MY_CAT=fluffy
        ```
        
* WORKDIR
    ```text
    为Dockerfile中的RUN, CMD, ENTRYPOINT, COPY, ADD指令设置"工作目录"
    
    可写多个
    ```
    * syntax
        ```text
        WORKDIR /path/to/workdir
        ```
    * 示例
        ```bash
        # 示例1
        WORKDIR /usr/local/service
        
        # 示例2
        ENV DIRPATH=/path
        WORKDIR $DIRPATH/service
        ```
* ADD
    ```text
    将宿主机上的文件复制到镜像中。
    
    如果 <src> 资源为宿主机本地的tar压缩包文件（.gzip, bzip2, xz），在镜像中将解压为目录，行为类似于 tar -x
    如果 <src> 资源为URL资源时，在镜像中将不解压
    ```
    * syntax
        ```text
        ADD [--chown=<user>:<group>] <src>... <dest>
  
        # 路径中有空格的解决方法
        ADD [--chown=<user>:<group>] ["<src>",... "<dest>"]
        ```
        * <src>为目录时，不复制目录，只复制目录下的内容
* COPY
* LABEL
* USER
* VOLUME
* CMD
* ENTRYPOINT
* EXPOSE
* STOPSIGNAL
* ONBUILD