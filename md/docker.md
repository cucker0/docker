docker的使用
==

## 简介
**Docker**是一个开源的应用容器引擎；是一个轻量级容器技术；

Docker支持将软件编译成一个镜像；然后在镜像中各种软件做好配置，将镜像发布出去，其他使用者可以直接使用这个镜像；

运行中的这个镜像称为容器，容器启动是非常快速的

[docker官网](https://www.docker.com/)

## docker结构体系
![](../image/docker_architecture.svg)
![](../image/docker_architecture2.jpg)
![](../image/docker_architecture3.jpg)


**核心概念**
* docker host
    >安装了docker程序的主机

* docker daemon
    >docker守护进程，  
    监听docker API请求，  
    管理 images, containers, networks, and volumes  
    与其他docker services通信

* docker client
    >CLI, 管理docker的客户端
* docker registries
    >镜像仓库  
    A Docker registry stores Docker images.  
    Docker Hub is a public registry

* docker objects
    * images
         >用于创建container的镜像，可以包含一个或一组应用(多个应用)  
         An image is a read-only template with instructions for creating a Docker container. Often, an image is based on another image, with some additional customization.
    * containers
        >容器，一个可运行的镜像实例  
        A container is a runnable instance of an image. 
    * networks
        >网络
    * volumes
        卷，文件系统
    * plugins
        >插件
    * other objects


**使用docker的步骤**
1. 安装docker
2. 去docker registries仓库找到对应的image镜像
3. 使用docker运行这个镜像，就生成了基于这个镜像的docker容器
4. 对容器的启动/停止，可以控制对应用的启动/停止


## 安装docker
* [Install Docker Engine](https://docs.docker.com/engine/install/)
    * [Install Docker Engine on CentOS](https://docs.docker.com/engine/install/centos/)
    * [Install Docker Engine on Ubuntu](https://docs.docker.com/engine/install/ubuntu/)

### CentOS安装Docker Engine
[Install Docker Engine on CentOS](https://docs.docker.com/engine/install/centos/)

#### Prerequisites必要条件
* OS requirements

    you need a maintained version of CentOS 7 or 8.

    The `centos-extras` repository must be enabled. This repository is enabled by default, but if you have disabled it, you need to [re-enable it](https://wiki.centos.org/AdditionalResources/Repositories)

    The `overlay2` storage driver is recommended.
    
* Uninstall old versions
    ```bash
     yum -y remove docker \
                docker-client \
                docker-client-latest \
                docker-common \
                docker-latest \
                docker-latest-logrotate \
                docker-logrotate \
                docker-engine
    ```
    The contents of `/var/lib/docker/`, including images, containers, volumes, and networks, are preserved(先保存). The Docker Engine package is now called `docker-ce`.


#### Installation methods
* Install using the repository
    * SET UP THE REPOSITORY
        Install the `yum-utils` package (which provides the `yum-config-manager` utility) and set up the **stable** repository.
        ```bash
         yum install -y yum-utils
         yum-config-manager \
            --add-repo https://download.docker.com/linux/centos/docker-ce.repo
        ```
        These repositories are included in the docker.repo file above but are disabled by default. You can enable them alongside the stable repository. The following command enables the **nightly** repository.
        >sudo yum-config-manager --enable docker-ce-nightly
        
        To enable the test channel, run the following command:
        >sudo yum-config-manager --enable docker-ce-test
        
        You can disable the `nightly` or `test` repository by running the `yum-config-manager` command with the `--disable` flag. To re-enable it, use the --enable flag. The following command disables the nightly repository.
        
        >sudo yum-config-manager --disable docker-ce-nightly
  
    * INSTALL DOCKER ENGINE
        * Install the latest version of Docker Engine and containerd
            ```bash
            yum -y install docker-ce docker-ce-cli containerd.io
            ```
            Docker is installed but not started. The `docker` group is created, but no users are added to the group.      
            
        * To install `a specific version` of Docker Engine（安装指定版本的docker引擎）, 
        
            list the available versions in the repo, then select and install:
            ```bash
            yum list docker-ce --showduplicates |sort -r
            #  
            docker-ce.x86_64  3:18.09.1-3.el7                     docker-ce-stable
            docker-ce.x86_64  3:18.09.0-3.el7                     docker-ce-stable
            docker-ce.x86_64  18.06.1.ce-3.el7                    docker-ce-stable
            docker-ce.x86_64  18.06.0.ce-3.el7                    docker-ce-stable
            ```
            fully qualified package name, For example, `docker-ce-18.09.1`
            ```bash
            yum -y install docker-ce-<VERSION_STRING> docker-ce-cli-<VERSION_STRING> containerd.io
            ```
        * Start Docker
            ```bash
            systemctl start docker
            systemctl enable docker  (设置自动启动docker服务)
            ```
        * Verify that Docker Engine is installed correctly by running the `hello-world` image.
            >docker run hello-world
    
    * UPGRADE DOCKER ENGINE
        To upgrade Docker Engine, follow the installation instructions(即安装指定版docker这步), choosing the new version you want to install.
        
* Install from a package
    1. Go to `https://download.docker.com/linux/centos/` and choose your version of CentOS. Then browse to `x86_64/stable/Packages/` and download the `.rpm` file for the Docker version you want to install.
    2. Install Docker Engine, changing the path below to the path where you downloaded the Docker package.
        >yum -y install /path/to/package.rpm

* Install using the convenience script

    Docker provides convenience scripts at `get.docker.com` and `test.docker.com` for installing edge and testing versions of Docker Engine - Community into development environments quickly and non-interactively.
    ```bash
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    
    # 或
    wget -qO- https://get.docker.com |sh
    ```
    
    If you would like to use Docker as a non-root user, you should now consider adding your user to the “docker” group with something like:
    >usermod -aG docker <your-user>

#### Uninstall Docker Engine
1. Uninstall the Docker Engine, CLI, and Containerd packages:
    >yum -y remove docker-ce docker-ce-cli containerd.io

2. Images, containers, volumes, or customized configuration files on your host are not automatically removed. To delete all images, containers, and volumes:
    ```bash
    rm -rf /var/lib/docker
    rm -rf /var/lib/containerd
    ```
    You must delete any edited configuration files manually.

## docker的常用操作
[docker CLI命令行](https://docs.docker.com/engine/reference/commandline/docker/)

### 镜像操作
* 搜索镜像
    ```text
    docker search [OPTIONS] TERM
        
    Search the Docker Hub for images，从https://hub.docker.com/ docker hub中搜索镜像
    
    Options:
      -f, --filter filter   Filter output based on conditions provided
          --format string   Pretty-print search using a Go template
          --limit int       Max number of search results (default 25)
          --no-trunc        Don't truncate output 输出不截断

    ```
    
    示例
    ```text
    docker search mysql
  
    #
    NAME                              DESCRIPTION                                     STARS     OFFICIAL   AUTOMATED
    mysql                             MySQL is a widely used, open-source relation…   10766     [OK]       
    mariadb                           MariaDB Server is a high performing open sou…   4052      [OK]       
    mysql/mysql-server                Optimized MySQL Server Docker images. Create…   792                  [OK]
    percona                           Percona Server is a fork of the MySQL relati…   533       [OK]       
    centos/mysql-57-centos7           MySQL 5.7 SQL database server                   87                   
    mysql/mysql-cluster               Experimental MySQL Cluster Docker images. Cr…   81                   
    centurylink/mysql                 Image containing mysql. Optimized to be link…   59                   [OK]
    bitnami/mysql                     Bitnami MySQL Docker Image                      50                   [OK]
    databack/mysql-backup             Back up mysql databases to... anywhere!         43                   
    ```
    
    各项说明：
    ```text
    NAME：镜像名
    DESCRIPTION：镜像描述
    STARS：关注人数，单位:k
    OFFICIAL：是否为docker官方的，[OK] 是
    AUTOMATED：是否自动构建，[OK] 是
    ```
    ![](../image/docker_hub1.png)

* 拉取镜像
    ```text
    Usage:  docker pull [OPTIONS] NAME[:TAG|@DIGEST]
    
    Pull an image or a repository from a registry  从镜像仓库拉取镜像到服务器本地
    默认是 latest TAG
  
  
    Options:
      -a, --all-tags                Download all tagged images in the repository
          --disable-content-trust   Skip image verification (default true)
          --platform string         Set platform if server is multi-platform capable
      -q, --quiet                   Suppress verbose output
    
    @DIGEST：摘要值指定镜像版本，如
    docker pull mysql@sha256:355617769102e9d2ebb7d5879263a12d230badb7271c91748b2c7b0ac6971083
    ```
    
* 查看本地已经拉取的镜像
    ```text
    Usage:  docker images [OPTIONS] [REPOSITORY[:TAG]]
    
    List images
    
    Options:
      -a, --all             Show all images (default hides intermediate images)
          --digests         Show digests
      -f, --filter filter   Filter output based on conditions provided
          --format string   Pretty-print images using a Go template
          --no-trunc        Don't truncate output
      -q, --quiet           Only show image IDs

    ```
    
    
* 删除本地镜像
    ```text
    Usage:  docker rmi [OPTIONS] IMAGE [IMAGE...]
    
    Remove one or more images  删除指定的一个或多个镜像指定镜像的ID
    
    Options:
      -f, --force      Force removal of the image
          --no-prune   Do not delete untagged parents
    ```

### 容器操作
* 搜索镜像
    >docker search tomcat
    
* 拉取镜像
    >docker pull tomcat

* 根据镜像启动容器，一般不使用，

    容器内部的端口没有映射出来，容器内的端口无法被访问到
    >docker run --name mytomcat -d tomcat:latest

* 根据镜像启动容器，并做端口映射，默认是TCP
    >docker run --name mytomcat -d -p 8888:8080 tomcat
    http://host-ip:8888 浏览
    
* 停止运行中的容器
    >docker stop [OPTIONS] CONTAINER [CONTAINER...]  
    docker stop CONTAINER_ID
    
* 查看所有的容器，包括停止运行的
    >docker ps -a  

* 启动容器
    >docker start [OPTIONS] CONTAINER [CONTAINER...]  
    docker start CONTAINER_ID
    
* 删除指定的容器
    >docker rm [OPTIONS] CONTAINER [CONTAINER...]  
    docker rm CONTAINER_ID

* 在运行的容器中执行命令
    >docker exec -it CONTAINER_ID bash  
    // This will create a new Bash session in the container CONTAINER_ID 新建一个bash会话，此时就能在此session中输入命令

* 查看容器的启动参数
>docker inspect container_id

* 查看容器日志
    ```text
    Usage:  docker logs [OPTIONS] CONTAINER
    
    Fetch the logs of a container
    
    Options:
          --details        Show extra details provided to logs
      -f, --follow         Follow log output
          --since string   Show logs since timestamp (e.g. 2013-01-02T13:23:37Z) or relative (e.g. 42m for 42 minutes)
      -n, --tail string    Number of lines to show from the end of the logs (default "all")
      -t, --timestamps     Show timestamps
          --until string   Show logs before a timestamp (e.g. 2013-01-02T13:23:37Z) or relative (e.g. 42m for 42 minutes)
    ```

* [端口映射](https://docs.docker.com/network/links/#connect-using-network-port-mapping)
    ```text
    docker run -d -p 127.0.0.1:80:8080/tcp ubuntu

    docker run -d -p 127.0.0.1:80:5000/udp training/webapp python app.py

    // 还可以指定 /sctp 协议s
    ```
* docker容器的配置文件目录
```text
// 容器配置目录
/var/lib/docker/containers/container_ids
.
├── 16da4944b317c12036b67e3bcee1ed6a89f78f097874c50c32f33a956bd9b730-json.log  // json格式的日志
├── config.v2.json  // 容器的配置，State,Config(主机名，cmd, 执行cmd的用户，Env环境变量，network、volume，mount point)
├── hostconfig.json  // 主机配置,CPU，内存等
├── hostname  // 配置主机名的文件，即/etc/hostname
├── hosts  // hosts绑定文件，即OS的/etc/hosts文件
├── resolv.conf // 配置DNS服务器，即/etc/resolv.conf，
└── shm  // 配置共享内存
```

* 容器volume卷目录
>/var/lib/docker/volumes/container

#### docker run
[docker run](https://docs.docker.com/engine/reference/commandline/run/)

在新容器中运行命令，

所做的操作：创新一个新容器，然后启动该容器

*  Usage
    ```text
    docker run [OPTIONS] IMAGE [COMMAND] [ARG...]
    ```

* Options
    [Options](https://docs.docker.com/engine/reference/commandline/run/#options)
    
    ```text
    --detach , -d           Run container in background and print container ID
    --name		            Assign a name to the container  为容器指定一个名称
    --interactive , -i		Keep STDIN open even if not attached  保持标准输入打开，即使未连接。可进行命令交互，进入容器的CLI
    --tty , -t		        Allocate a pseudo-TTY  分配一个伪TTY
    --publish , -p		    Publish a container's port(s) to the host  发布容器中的端口到主机上，即端口映射
    --publish-all , -P		Publish all exposed ports to random ports  容器中的所有端口发布的主机上，端口随机
    --device                Add a host device to the container
    --env , -e              Set environment variables  设置环境变量
    --env-file		        Read in a file of environment variables
    --cpu-quota             Limit CPU CFS (Completely Fair Scheduler) quota
    --cpus                  Number of CPUs
    --memory , -m		    Memory limit
    --volume , -v		    Bind mount a volume
    --volume-driver		    Optional volume driver for the container
    --workdir , -w		    Working directory inside the container
    --attach , -a		    Attach to STDIN, STDOUT or STDERR  连接标准输入、标准输出或标准错误输出
    ```

##### Set working directory (-w)设置工作目录
```bash
docker run -w /path/to/dir/ -i -t  ubuntu pwd
```
The `-w` lets the command being executed inside directory given, here `/path/to/dir/`.  允许在指定的目录中执行命令

If the path does not exist it is created inside the container.  如果指定的目录在dockerz主机不存在，则会在容器中创建该目录

##### Set storage driver options per container设置存储驱动选项
```bash
docker run -it --storage-opt size=120G fedora /bin/bash
```
This (size) will allow to set the container rootfs size to 120G at creation time. 

This option is only available for the `devicemapper`, `btrfs`, `overlay2`, `windowsfilter` and `zfs` graph drivers. 

##### Mount tmpfs (--tmpfs)临时文件系统
```bash
docker run -d --tmpfs /run:rw,noexec,nosuid,size=65536k my_image
```
The `--tmpfs` flag mounts an empty tmpfs into the container with the `rw`, `noexec`, `nosuid`, `size=65536k` options.


##### Mount volume (-v, --read-only)挂载卷
```bash
docker run -v `pwd`:`pwd` -w `pwd` -i -t  ubuntu pwd
```
The `-v` flag mounts the current working directory into the container.  主机上当前的工作目录挂载到容器中s

```bash
docker run -v /doesnt/exist:/foo -w /foo -i -t ubuntu bash
```
When the host directory of a bind-mounted volume doesn’t exist, Docker will automatically create this directory on the host for you.

指定要绑定挂载的目录存在时，主机将自动创建该目录，/doesnt/exist 主机上的目录 挂载到容器中的/foo


```bash
docker run --read-only -v /icanwrite busybox touch /icanwrite/here
```
The --read-only flag mounts the container’s root filesystem as read only 

prohibiting writes to locations other than the specified volumes for the container.

设置容器的root filesystem只读，只能往容器中 -v指定的目录中写入。


```bash
docker run -t -i -v /var/run/docker.sock:/var/run/docker.sock -v /path/to/static-docker-binary:/usr/bin/docker busybox sh
```
By bind-mounting the docker unix socket and statically linked docker binary (refer to get the linux binary),  
绑定挂载unix socket、静态链接的docker二进制文件，
you give the container the full access to create and manipulate the host’s Docker daemon.  
给容器完全访问的权限，创建和操纵host’s Docker daemon


##### Add bind mounts or volumes using the --mount flag
--volume(-v)能支持的参数，--mount都能支持，但语法不同。建议使用--mount

```bash
docker run --read-only --mount type=volume,target=/icanwrite busybox touch /icanwrite/here
```
设置容器的root filesystem只读，只能往容器中target=/icanwrite的目录中写入。


```bash
docker run -t -i --mount type=bind,src=/data,dst=/data busybox sh
```
绑定挂载，主机的/data挂载到容器的/data


##### Set environment variables (-e, --env, --env-file)设置环境变量
```bash
docker run -e MYVAR1 --env MYVAR2=foo --env-file ./env.list ubuntu bash
```
Use the `--env(-e)`, and `--env-file` flags to set simple (non-array) environment variables in the container you’re running, or overwrite variables that are defined in the Dockerfile of the image you’re running.


```bash
$ docker run --env VAR1=value1 --env VAR2=value2 ubuntu env | grep VAR
VAR1=value1
VAR2=value2
```

```bash
export VAR1=value1
export VAR2=value2

$ docker run --env VAR1 --env VAR2 ubuntu env | grep VAR
VAR1=value1
VAR2=value2
```

```bash
$ cat env.list

VAR1=value1
VAR2=value2
USER

$ docker run --env-file env.list ubuntu env | grep VAR
VAR1=value1
VAR2=value2
USER=denis
```

##### Mount volumes from container (--volumes-from)
```bash
docker run --volumes-from 777f7dc92da7 --volumes-from ba8c0c54f0f2:ro -i -t ubuntu pwd
```
The `--volumes-from` flag mounts all the defined volumes from the referenced containers. 

The container ID may be optionally suffixed with `:ro` or `:rw` to mount the volumes in read-only or read-write mode, respectively. 

By default, the volumes are mounted in the same mode (read write or read only) as the reference container.

To change the label in the container context, you can add either of two suffixes `:z` or `:Z` to the volume mount.

:z  The z option tells Docker that two containers share the volume content. Shared volume labels allow all containers to read/write content.

:Z  The Z option tells Docker to label the content with a private unshared label(私有非共享). Only the current container can use a private volume.（只有当前的容器能使用该卷）



* 问题Cannot connect to the Docker daemon
    ```text
    docker ps
    
    Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running?
    ```
    原因：  
    这是因为没有启动docker Engine服务，启动docker服务
    >systemctl start docker

