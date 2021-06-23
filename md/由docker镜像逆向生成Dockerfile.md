由docker镜像逆向生成Dockerfile
==

## why
我们在使用docker的时候可能会遇到这样的场景，我们使用Dockerfile创建了一个镜像，  
然后当我们想把Dockerfile拿出来修改一下或者是复制一下的时候，却找不到了，  
我们不能再重新写吧，这时候我们可以**通过已有的镜像来获得Dockerfile**。


## how
### 使用docker history
```bash
docker history --format {{.CreatedBy}} --no-trunc=true 镜像 |sed "s,/bin/sh[ ]-c[ ]\#(nop)[ ][ ]*,,g" |sed "s,/bin/sh[ ]-c,RUN,g" |sed 's, && ,\n  & ,g' |tac
```
* 命令解说
    ```text
    docker history --format {{.CreatedBy}} --no-trunc=true 镜像
    // 查看镜像的history信息的CREATED BY字段，信息不截断  
    
    sed "s,/bin/sh[ ]-c[ ]\#(nop)[ ][ ]*,,g"
    // "/bin/sh -c #(nop)  " 替换为 "空"
    
    sed "s,/bin/sh[ ]-c,RUN,g"
    // "/bin/sh -c" 替换为 "RUN"
    
    sed 's, && ,\n  & ,g'
    // 把 && 命令输出成多行
    
    tac
    // 内容反转
    ```

缺点：少了FROM指令信息

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
        $ docker history --format {{.CreatedBy}} --no-trunc=true hanxiao/mynginx:4.1 |sed "s,/bin/sh[ ]-c[ ]\#(nop)[ ][ ]*,,g" |sed "s,/bin/sh[ ]-c,RUN,g" |sed 's, && ,\n  & ,g' |tac
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

### dfimage容器内分析镜像
```bash
docker run -v /var/run/docker.sock:/var/run/docker.sock --rm alpine/dfimage 镜像

// 或
$ alias dfimage="docker run -v /var/run/docker.sock:/var/run/docker.sock --rm alpine/dfimage"
$ dfimage 镜像
```
https://hub.docker.com/r/alpine/dfimage

`dfimage`使用的go语言写的镜像分析[WhaleTail](https://github.com/sevck/WhaleTail)