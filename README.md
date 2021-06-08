# docker
docker的使用

## Table Of Contents
* [简介](md/docker.md#简介)
* [docker结构体系](md/docker.md#docker结构体系)
* [安装docker](md/docker.md#安装docker)
    * [CentOS安装Docker Engine](md/docker.md#CentOS安装Docker-Engine)
        * [Prerequisites必要条件](md/docker.md#Prerequisites必要条件)
        * [Installation methods](md/docker.md#Installation-methods)
        * [Uninstall Docker Engine](md/docker.md#Uninstall-Docker-Engine)
* [docker的常用操作](md/docker.md#docker的常用操作)
    * [镜像操作](md/docker.md#镜像操作)
    * [容器操作](md/docker.md#容器操作)
        * [docker run](md/docker.md#docker-run)
            * [Set working directory (-w)设置工作目录](md/docker.md#Set-working-directory--w设置工作目录)
            * [Set storage driver options per container设置存储驱动选项](md/docker.md#Set-storage-driver-options-per-container设置存储驱动选项)
            * [Mount tmpfs (--tmpfs)临时文件系统](md/docker.md#Mount-tmpfs---tmpfs临时文件系统)
            * [Mount volume (-v, --read-only)挂载卷](md/docker.md#Mount-volume--v---read-only挂载卷)
            * [Add bind mounts or volumes using the --mount flag](md/docker.md#Add-bind-mounts-or-volumes-using-the---mount-flag)
            * [Set environment variables (-e, --env, --env-file)设置环境变量](md/docker.md#Set-environment-variables--e---env---env-file设置环境变量)
            * [Mount volumes from container (--volumes-from)](md/docker.md#Mount-volumes-from-container---volumes-from)
            * [Add host device to container (--device)](md/docker.md#Add-host-device-to-container---device)
            * [Restart policies (--restart)](md/docker.md#Restart-policies---restart)
        * [Publish port(发布端口，端口映射)](md/docker.md#Publish-port发布端口端口映射)
        * [修改Docker容器启动配置参数](md/docker.md#修改Docker容器启动配置参数)
        * [修改docker容器的挂载路径](md/docker.md#修改docker容器的挂载路径)
        * [修改docker默认的存储位置](md/docker.md#修改docker默认的存储位置)
* [启动mysql容器示例](md/docker.md#启动mysql容器示例)
* [docker清理占用的硬盘空间](md/docker.md#docker清理占用的硬盘空间)
    * [清理磁盘，删除关闭的容器、无用的数据卷和网络、以及无tag的镜像](md/docker.md#清理磁盘删除关闭的容器无用的数据卷和网络以及无tag的镜像)
    * [手动清理Docker镜像、容器、数据卷](md/docker.md#手动清理Docker镜像容器数据卷)
    * [限制容器的日志大小](md/docker.md#限制容器的日志大小)
    * [使用truncate命令将容器的日志文件"清零"](md/docker.md#使用truncate命令将容器的日志文件清零)
* [迁移image、container、volume](md/docker.md#迁移imagecontainervolume)
    * [image迁移](md/docker.md#image迁移)
    * [container迁移](md/docker.md#container迁移)
        * [镜像的迁移参考上面Image的迁移，如image为alpine](md/docker.md#镜像的迁移参考上面Image的迁移如image为alpine)
        * [容器的迁移](md/docker.md#容器的迁移)
    * [volume迁移](md/docker.md#volume迁移)
        * [备份volume](md/docker.md#备份volume)
        * [恢复volume备份文件](md/docker.md#恢复volume备份文件)
    * [迁移image、container、volume总结](md/docker.md#迁移imagecontainervolume总结)
* [tomastomecek/sen--docker engine终端用户界面](md/docker.md#tomastomecek/sen--docker-engine终端用户界面)
* [wagoodman/dive--image,layer contents探索工具](md/docker.md#wagoodman/dive--imagelayer-contents探索工具)
* [注意](md/docker.md#注意)
    * [iptables服务重启后，导致docker的iptables规则丢失解决办法](md/docker.md#iptables服务重启后导致docker的iptables规则丢失解决办法)

***
**其他**

* [监控容器资源的使用情况](md/监控容器资源的使用情况.md)
* [Dockerfile多FROM指令存在的意义 和 用法](md/Dockerfile多FROM指令存在的意义.md)