由docker镜像逆向生成Dockerfile
==

## why
我们在使用docker的时候可能会遇到这样的场景：我们只有image，但想生成构建该image的Dockerfile，
这时候我们可以**通过已有的镜像来获得Dockerfile**。


## how
### 使用docker history
通过docker history <IMAGE> 查看镜像信息来分析生成Dockerfile。

缺点：少了FROM指令信息，多出来自BASIC_IMAGE的一些指令信息

* 通用脚本
    dfimage.sh
    ```bash
    #!/bin/bash
    set -u
    
    USAGE_TIPS="Usage: ./dfimage.sh <IMAGE>"
    
    if [ !$1 ];
       echo ${USAGE_TIPS}
       exit 1
    fi
    
    case "$OSTYPE" in
        linux*)
            docker history --no-trunc --format "{{.CreatedBy}}" $1 | # extract information from layers
            tac                                                    | # reverse the file
            sed 's,^\(|3.*\)\?/bin/\(ba\)\?sh -c,RUN,'             | # change /bin/(ba)?sh calls to RUN
            sed 's,^RUN #(nop) *,,'                                | # remove RUN #(nop) calls for ENV,LABEL...
            sed 's,  *&&  *, \\\n \&\& ,g'                           # pretty print multi command lines following Docker best practices
        ;;
        darwin*)
            docker history --no-trunc --format "{{.CreatedBy}}" $1 | # extract information from layers
            tail -r                                                | # reverse the file
            sed -E 's,^(\|3.*)?/bin/(ba)?sh -c,RUN,'               | # change /bin/(ba)?sh calls to RUN
            sed 's,^RUN #(nop) *,,'                                | # remove RUN #(nop) calls for ENV,LABEL...
            sed $'s,  *&&  *, \\\ \\\n \&\& ,g'                      # pretty print multi command lines following Docker best practices
        ;;
        *)
            echo "unknown OSTYPE: $OSTYPE"
        ;;
    esac
    ```

* shell命令
    ```bash
    docker history --format {{.CreatedBy}} --no-trunc=true 镜像 |
        sed "s,/bin/\(ba\)\?sh[ ]-c[ ]\#(nop)[ ][ ]*,,g" |
        sed "s,/bin/\(ba\)\?sh[ ]-c,RUN,g" |
        sed 's,  *&&  *, \\\n \&\& ,g' |
        tac
    ```
    * 命令解说
        ```text
        docker history --format {{.CreatedBy}} --no-trunc=true 镜像
        // 查看镜像的history信息的CREATED BY字段，信息不截断  
        
        sed "s,/bin/\(ba\)\?sh[ ]-c[ ]\#(nop)[ ][ ]*,,g"
        // ENV,LABEL...中的 "/bin/sh -c #(nop)  "或"/bin/bash -c #(nop)  " 都 替换为 "空"
        
        sed "s,/bin/\(ba\)\?sh[ ]-c,RUN,g"
        // "/bin/sh -c" 或 ""/bin/bash -c"" 替换为 "RUN"
        
        sed 's,  *&&  *, \\\n \&\& ,g'
        // 把多个&&命令输出成多行
        
        tac
        // 内容反转
        ``` 

* 示例
    * 源Dockerfile
        ```text
        FROM centos
        LABEL maintainer="NGINX Docker Maintainers <docker-maint@nginx.com>"
        RUN yum install -y nginx
        RUN echo "Nginx Web: CMD defining default arguments for an ENTRYPOINT" > /usr/share/nginx/html/index.html
        EXPOSE 80
        CMD ["-g", "daemon off;"]
        ENTRYPOINT ["/usr/sbin/nginx"]
        ```    
        生成的image为 `hanxiao/mynginx:4.1`
    
    * 由docker history逆向生成Dockerfile
    ```bash
        $ docker history --format {{.CreatedBy}} --no-trunc=true hanxiao/mynginx:4.1 |
            sed "s,/bin/\(ba\)\?sh[ ]-c[ ]\#(nop)[ ][ ]*,,g" |
            sed "s,/bin/\(ba\)\?sh[ ]-c,RUN,g" |
            sed 's,  *&&  *, \\\n \&\& ,g' |
            tac
        ADD file:bd7a2aed6ede423b719ceb2f723e4ecdfa662b28639c8429731c878e86fb138b in / 
        LABEL org.label-schema.schema-version=1.0 org.label-schema.name=CentOS Base Image org.label-schema.vendor=CentOS org.label-schema.license=GPLv2 org.label-schema.build-date=20201204
        CMD ["/bin/bash"]
        LABEL maintainer=NGINX Docker Maintainers <docker-maint@nginx.com>
        RUN yum install -y nginx
        RUN echo "Nginx Web: CMD defining default arguments for an ENTRYPOINT" > /usr/share/nginx/html/index.html
        EXPOSE 80
        CMD ["-g" "daemon off;"]
        ENTRYPOINT ["/usr/sbin/nginx"]
        ```

### DockerImage2Df容器工具
[dockerimage2df](https://github.com/cucker0/dockerimage2df)

```bash
# Command alias
echo "alias image2df='docker run -v /var/run/docker.sock:/var/run/docker.sock --rm cucker/image2df'" >> ~/.bashrc
. ~/.bashrc

# Excute command
image2df <IMAGE
```

* For example
    ```bash
    $ echo "alias image2df='docker run -v /var/run/docker.sock:/var/run/docker.sock --rm cucker/image2df'" >> ~/.bashrc
    $ . ~/.bashrc
    $ docker pull mysql
    $ image2df mysql
    
    ========== Dockerfile ==========
    FROM mysql:latest
    RUN groupadd -r mysql && useradd -r -g mysql mysql
    RUN apt-get update && apt-get install -y --no-install-recommends gnupg dirmngr && rm -rf /var/lib/apt/lists/*
    ENV GOSU_VERSION=1.12
    RUN set -eux; \
        savedAptMark="$(apt-mark showmanual)"; \
        apt-get update; \
        apt-get install -y --no-install-recommends ca-certificates wget; \
        rm -rf /var/lib/apt/lists/*; \
        dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')"; \
        wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch"; \
        wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc"; \
        export GNUPGHOME="$(mktemp -d)"; \
        gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4; \
        gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu; \
        gpgconf --kill all; \
        rm -rf "$GNUPGHOME" /usr/local/bin/gosu.asc; \
        apt-mark auto '.*' > /dev/null; \
        [ -z "$savedAptMark" ] || apt-mark manual $savedAptMark > /dev/null; \
        apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
        chmod +x /usr/local/bin/gosu; \
        gosu --version; \
        gosu nobody true
    RUN mkdir /docker-entrypoint-initdb.d
    RUN apt-get update && apt-get install -y --no-install-recommends \
            pwgen \
            openssl \
            perl \
            xz-utils \
        && rm -rf /var/lib/apt/lists/*
    RUN set -ex; \
        key='A4A9406876FCBD3C456770C88C718D3B5072E1F5'; \
        export GNUPGHOME="$(mktemp -d)"; \
        gpg --batch --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
        gpg --batch --export "$key" > /etc/apt/trusted.gpg.d/mysql.gpg; \
        gpgconf --kill all; \
        rm -rf "$GNUPGHOME"; \
        apt-key list > /dev/null
    ENV MYSQL_MAJOR=8.0
    ENV MYSQL_VERSION=8.0.24-1debian10
    RUN echo 'deb http://repo.mysql.com/apt/debian/ buster mysql-8.0' > /etc/apt/sources.list.d/mysql.list
    RUN { \
            echo mysql-community-server mysql-community-server/data-dir select ''; \
        echo mysql-community-server mysql-community-server/root-pass password ''; \
        echo mysql-community-server mysql-community-server/re-root-pass password ''; \
        echo mysql-community-server mysql-community-server/remove-test-db select false; \
        } | debconf-set-selections \
        && apt-get update \
        && apt-get install -y \
            mysql-community-client="${MYSQL_VERSION}" \
            mysql-community-server-core="${MYSQL_VERSION}" \
        && rm -rf /var/lib/apt/lists/* \
        && rm -rf /var/lib/mysql && mkdir -p /var/lib/mysql /var/run/mysqld \
        && chown -R mysql:mysql /var/lib/mysql /var/run/mysqld \
        && chmod 1777 /var/run/mysqld /var/lib/mysql
    VOLUME [/var/lib/mysql]
    COPY dir:2e040acc386ebd23b8571951a51e6cb93647df091bc26159b8c757ef82b3fcda in /etc/mysql/
    COPY file:345a22fe55d3e6783a17075612415413487e7dba27fbf1000a67c7870364b739 in /usr/local/bin/
    RUN ln -s usr/local/bin/docker-entrypoint.sh /entrypoint.sh # backwards compat
    ENTRYPOINT ["docker-entrypoint.sh"]
    EXPOSE 3306 33060
    CMD ["mysqld"]
    ```