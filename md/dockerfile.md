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
#### ARG    
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
    
#### FROM
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
 
#### MAINTAINER (deprecated)
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

#### ENV
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
    
#### WORKDIR
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
#### ADD
将宿主机上的文件、目录、远端的URL资源复制到镜像中。

有本地tar压缩文件提取到镜像，下载URL资源到镜像的功能

* syntax
    ```text
    ADD [--chown=<user>:<group>] <src>... <dest>

    # 路径中有空格的解决方法
    ADD [--chown=<user>:<group>] ["<src>",... "<dest>"]
    ```
    * <src>必须位置build的上下文目录内。不能超出此路径范围
    * 当<src>为目录时，则复制目录下的全部内容，包括文件系统元数据。
    * 如果 <src> 资源为宿主机本地的tar压缩包文件（.gzip, bzip2, xz），在镜像中将解压为目录，行为类似于 tar -x  
        即**将本地的tar文件提取到镜像中**
    * 如果 <src> 资源为URL资源时，在镜像中将不解压，直接下载
    * 当<src>为其它任何类型的文件，且<dest>以/结尾，则镜像中<src>将复制为<dest>/base(<src>)
    * 当有多个<src>时，<dest>必须以/结尾
    * --chown=<user 只对linux系统有效
    * 当<dest>目录不存在时，将会自动创建该目录
* 示例
    ```bash
    ADD test.txt /absoluteDir/
    ADD hom* /mydir/
    ADD hom?.txt /mydir/
    ADD --chown=55:mygroup files* /somedir/
    ADD --chown=1 files* /somedir/
    ```


#### COPY
从宿主上复制文件或目录到镜像中


* syntax
    ```bash
    COPY [--chown=<user>:<group>] <src>... <dest>
    
    # 路径中有空格
    COPY [--chown=<user>:<group>] ["<src>",... "<dest>"]
    ```
    * <src>必须位置build的上下文目录内。不能超出此路径范围
    * 当<src>为目录时，则复制目录下的全部内容，包括文件系统元数据。
    * 当<dest>目录不存在时，将会自动创建该目录
    * <src>不支持URL
   
* 示例
    ```bash
    COPY test.txt /absoluteDir/
    COPY hom* /mydir/
    COPY --chown=55:mygroup files* /somedir/
    COPY --chown=bin files* /somedir/
    ```

#### LABEL
给镜像设置metadata元数据。

可以添加维护作者信息、项目的组织信息、licensing许可信息、版本信息等

可写多个

* syntax
    ```bash
    LABEL <key>=<value> <key>=<value> <key>=<value> ...
    ```
* 示例
    ```bash
    LABEL maintainer="NGINX Docker Maintainers <docker-maint@nginx.com>"
    LABEL com.example.version="0.0.1-beta"
    LABEL vendor1="ACME Incorporated"
    LABEL vendor2=ZENITH\ Incorporated
    
    LABEL multi.label1="value1" \
          multi.label2="value2" \
          other="value3"
    ```  

#### USER
镜像运行时使用的用户和组。

为Dockerfile文件中的RUN, CMD, ENTRYPOINT指令指定运行的用户和组

* syntax
    ```bash
    USER <user>[:<group>]
    
    # or
    USER <UID>[:<GID>]
    ```
* 示例
    ```bash
    # Create a group and an user
    RUN groupadd -r postgres && useradd --no-log-init -r -g postgres postgres
    # 为后续命令指定用户
    USER postgres
    ```

#### VOLUME
创建容器数据卷。用于数持久化

创建具体指定名称的挂载点，用来保存来自宿主机或其他容器的数据卷

* syntax
    ```bash
    VOLUME ["/data", "/data2"]
    ```
    值可以是一个json数组 或是多个参数的字符串（空格隔开）
* 示例
```bash
VOLUME ["/var/log", "/var/db"]

# 或
VOLUME /var/log /var/db
```

#### CMD
#### ENTRYPOINT
设置容器启动时要运行的主命令(main command)

ENTRYPOINT 的目的和 CMD 一样，都是指定容器启动时要运行的程序及参数

#### EXPOSE
#### STOPSIGNAL
#### ONBUILD

#### ADD or COPY
* 只做复制的情况下，建议使用COPY，因为直接透明
* 如果需要把宿主机本地的tar压缩文件提取到镜像中，或下载URL资源到镜像中装饰使用ADD

