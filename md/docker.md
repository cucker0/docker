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
    >仓库  
    A Docker registry stores Docker images.  
    Docker Hub is a public registry

* docker objects
    * images
         >用于创建container的镜像，  
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










