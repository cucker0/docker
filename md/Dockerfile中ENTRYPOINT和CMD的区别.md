Dockerfile中ENTRYPOINT和CMD的区别
==


## 示例
* 测试环境
    ```text
    OS：CentOS Linux release 7.9.2009 (Core)
    Docker: docker-ce-20.10.6-3.el7.x86_64
    ```

### ENTRYPOINT []
exec form

* Dockerfile

    /mydocker/Dockerfile
    ```text
    FROM centos
    LABEL maintainer="NGINX Docker Maintainers <docker-maint@nginx.com>"
    RUN yum install -y nginx
    RUN echo "nginx web test" > /usr/share/nginx/html/index.html
    EXPOSE 80
    # 也可写成 ENTRYPOINT ["nginx"]，会自动从环境变量中查找可执行的nginx命令
    ENTRYPOINT ["/usr/sbin/nginx"]
    ```

* 构建镜像
    ```bash
    cd /mydocker
    docker build -t hanxiao/mynginx:2.3 .
    ```

* 测试镜像
    ```text
    docker run --name mynginx2_3 -p 5002:80 -it hanxiao/mynginx:2.3 -g "daemon off;"
    
    # 或
    docker run --name mynginx2_4 -p 5003:80 -it hanxiao/mynginx:2.3 "-g daemon off;"
    ```

    * 镜像后的都是要传递的参数
    
    * 容器启动后，tty会话一直处于光标闪烁状态。`Ctrl + P + Q` 快捷键可以让容器在后台运行
    
    * 小坑
    
        在给/usr/sbin/nginx 传参 "daemon off"少了";"会报下面的错误
    
        ```text
        nginx: [emerg] unexpected end of parameter, expecting ";" in command line
        ```

    * 浏览器访问
        ![](../image/image_test1.png)

    * 进入容器查看进程
        ```bash
        docker exec -ti mynginx2_3 /bin/bash
        ```
        ![](../image/image_test2.png)

* 其它测试
    * 只查看nginx版本信息
        ```bash
        docker run --rm hanxiao/mynginx:2.3 -V
        ```
        ![](../image/image_test4.png)
        
        * 容器启动时执行了：`/usr/sbin/nginx -V`
        * 给`ENTRYPOINT`定义的命令`/usr/sbin/nginx`追加了参数`-V`

    * 假设想在查看nginx版本信息时，再执行`ps -ef`命令
        ```bash
        docker run --rm hanxiao/mynginx:2.3 -V ";ps -ef"
        ```
        报错
        ```text
        nginx: invalid option: ";ps -ef"
        ```
        即容器启动时执行的命令为：`/usr/sbin/nginx -V ";ps -ef"`
    
    * 传递多个参数(超过3个，能成功)
        ```bash
        docker run --rm hanxiao/mynginx:2.3 -t -v -h -V
        
        # 或
        docker run --rm hanxiao/mynginx:2.3 "-t" "-v" "-h" "-V"
        ```
        ![](../image/image_test5.png)
        
    * docker run时，多个参数合成一个参数（不可行）
        ```bash
        docker run --rm hanxiao/mynginx:2.3 "-h -v -V -t"
        ```
        报错
        ```text
        nginx: invalid option: " "
        ```
    
    * 结论
    
        docker run 镜像后的参数，相当于新加了一条`CMD`指令（并会覆盖原来定义的CMD），最后这些参数追加到`ENTRYPOINT []`命令后面作为参数

### CMD []
* Dockerfile

    /mydocker/Dockerfile2
    ```text
    FROM centos
    LABEL maintainer="NGINX Docker Maintainers <docker-maint@nginx.com>"
    RUN yum install -y nginx
    RUN echo "nginx web test" > /usr/share/nginx/html/index.html
    EXPOSE 80
    # 前台启动nignx，命令：nginx -g "daemon off;"
    CMD ["nginx", "-g", "daemon off;"]
    ```

* 构建镜像
    ```bash
    docker build -f /mydocker/Dockerfile2 -t hanxiao/mynginx:3.2 /mydocker
    ```

* 测试镜像
    ```bash
    docker run -d --name mynginx3_2 -p 5003:80 hanxiao/mynginx:3.2
    ```
    
    * 浏览器访问 http://<IP>:5003，访问正常
    
    * 查看容器运行的进程
        ```bash
        docker exec -it mynginx3_2 /bin/bash
        ```
        ![](../image/image_test21.png)
    
* 其它测试
    * 假设想在查看nginx版本信息时，再执行`ps -ef`命令
        ```bash
        docker run --rm hanxiao/mynginx:3.2 bin/bash -c "nginx -V; ps -ef"
        ```
        
        ![](../image/image_test22.png)
        * 执行成功，容器启动时执行的命令：bin/bash -c nginx -V; ps -ef
        * 已经把`CMD`定义的命令`nginx -g "daemon off;"`覆盖了
        * 尝试了以下启动命令
            ```bash
            docker run --rm hanxiao/mynginx:3.2 "nginx -V; ps -ef"
            docker run --rm hanxiao/mynginx:3.2 "nginx -V &&  ps -ef"
            docker run --rm hanxiao/mynginx:3.2 "/usr/sbin/nginx -V &&  ps -ef"
            docker run --rm hanxiao/mynginx:3.2 "/usr/sbin/nginx -V ; ps -ef"
            docker run --rm hanxiao/mynginx:3.2 "/usr/sbin/nginx -V; ps -ef"
            docker run --rm hanxiao/mynginx:3.2 "/bin/bash -c 'nginx -V ; ps -ef'"
            docker run --rm hanxiao/mynginx:3.2 "/bin/bash -c 'nginx -V'"
            docker run --rm hanxiao/mynginx:3.2 '/bin/bash -c "nginx -V"'
            docker run --rm hanxiao/mynginx:3.2 "/bin/bash -c 'nginx -V'"
            ```
            都提示类似如下的错误
            ```text
            docker: Error response from daemon: OCI runtime create failed: container_linux.go:367: starting container process caused: exec: "/usr/sbin/nginx -V; ps -ef": stat /usr/sbin/nginx -V; ps -ef: no such file or directory: unknown.
            ```

### CMD为ENTRYPOINT []定义默认参数
* Dockerfile

    /mydocker/Dockerfile3
    ```bash
    FROM centos
    LABEL maintainer="NGINX Docker Maintainers <docker-maint@nginx.com>"
    RUN yum install -y nginx
    RUN echo "Nginx Web: CMD defining default arguments for an ENTRYPOINT" > /usr/share/nginx/html/index.html
    EXPOSE 80
    CMD ["-g", "daemon off;"]
    ENTRYPOINT ["/usr/sbin/nginx"]
    ```
    * **其中`CMD`和`ENTRYPOINT`不分先后顺序**，
    
    * 最终执行的命令：`/usr/sbin/nginx -g daemon off;`
    
* 构建镜像
    ```bash
    docker build -f /mydocker/Dockerfile3 -t hanxiao/mynginx:4.1 /mydocker
    ```
* 测试镜像
    * 运行容器
    ```bash
    docker run -d --name mynginx4_1 -p 5040:80 hanxiao/mynginx:4.1
    ```
    
    * 查看容器进程
    ```bash
    docker exec -it mynginx4_1 ps -aux
    ```
    ![](../image/image_test41.png)
    
* 其它测试
    * docker run时传参
        ```bash
        docker run --rm hanxiao/mynginx:4.1 -h
        ```
        ![](../image/image_test42.png)
        * 此时已经把`CMD`定义的默认参数`-g daemon off;`覆盖了，替换为`-h`，容器里启动时执行了如下命令
            ```bash
            /usr/sbin/nginx -h
            ```
### ENTRYPOINT shell格式
结论：ENTRYPOINT shell格式，不接收`CMD`或`docker run`传递的参数

* Dockerfile

    /mydocker/Dockerfile4
    ```text
    FROM centos
    LABEL maintainer="NGINX Docker Maintainers <docker-maint@nginx.com>"
    RUN yum install -y nginx
    RUN echo "Nginx Web: CMD defining default arguments for an ENTRYPOINT" > /usr/share/nginx/html/index.html
    EXPOSE 80
    ENTRYPOINT /usr/sbin/nginx -v
    CMD ["-h", "-V"]
    ```
* 构建镜像
    ```bash
    docker build -f /mydocker/Dockerfile4 -t hanxiao/mynginx:7.1 /mydocker
    ```
* 测试镜像
    * 运行容器
    ```bash
    docker run --rm hanxiao/mynginx:7.1
    
    docker run --rm hanxiao/mynginx:7.1 -t
    ```
    以上两种条命令的结果都是一样的
    ![](../image/image_test71.png)
    说明：ENTRYPOINT没有`CMD`或`docker run`传递的参数，最终只运行了`/usr/sbin/nginx -v`  

## 结论
* CMD和ENTRYPOINT都可以定义容器启动时要执行主命令
* Dockerfile中定义的CMD会被`docker run <image> param1 param2 ...`传递的参数覆盖
* ENTRYPOINT shell格式，不接收`CMD`或`docker run`传递的参数
* ENTRYPOINT [] exec格式，有`docker run`传递的参数时，只追加`docker run`传递的参数，没有时则追加Dockerfile中CMD定义的参数
* ENTRYPOINT与CMD同时存在于Dockerfile中，不区分先后顺序
* ENTRYPOINT []、CMD [] exec格式中，非sh的可执行程序不能使用环境变量
* ENTRYPOINT []、CMD [] exec格式启动的程序PID为1
* ENTRYPOINT、CMD shell格式启动的程序PID不是1，启动的程序是/bin/sh的子进程