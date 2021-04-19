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

* 根据镜像启动容器，并做端口映射
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

#### docker run
[docker run](https://docs.docker.com/engine/reference/commandline/run/)

在新容器中运行命令，创新一个新容器，然后启动该容器

#### Usage
```text
docker run [OPTIONS] IMAGE [COMMAND] [ARG...]
```

#### Options
[Options](https://docs.docker.com/engine/reference/commandline/run/#options)

```text
--detach , -d           Run container in background and print container ID
--name		            Assign a name to the container  为容器指定一个名称
--interactive , -i		Keep STDIN open even if not attached  保持标准输入打开，即使未连接。可进行命令交互，进入容器的CLI
--tty , -t		        Allocate a pseudo-TTY  分配一个伪TTY
--publish , -p		    Publish a container's port(s) to the host  发布容器中的端口到主机上，即端口映射
--publish-all , -P		Publish all exposed ports to random ports  容器中的所有端口发布的主机上，端口随机
--device                Add a host device to the container
--env , -e              Set environment variables
--env-file		        Read in a file of environment variables
--cpu-quota             Limit CPU CFS (Completely Fair Scheduler) quota
--cpus                  Number of CPUs
--memory , -m		    Memory limit
--volume , -v		    Bind mount a volume
--volume-driver		    Optional volume driver for the container
--workdir , -w		    Working directory inside the container
--attach , -a		    Attach to STDIN, STDOUT or STDERR  连接标准输入、标准输出或标准错误输出
```









* 问题Cannot connect to the Docker daemon
    ```text
    docker ps
    
    Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running?
    ```
    原因：  
    这是因为没有启动docker Engine服务，启动docker服务
    >systemctl start docker

