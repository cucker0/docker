ONBUILD实验测试
==
## 结论
```text
在实际工作中，利用 ONBUILD 指令,通常用于创建一个模板镜像，
后续可以根据该模板镜像创建特定的子镜像，
需要在子镜像构建过程中执行的一些通用操作
就可以在模板镜像对应的dockerfile文件中用ONBUILD指令指定。

从而减少dockerfile文件的重复内容编写
```

## Dockerfile准备
/mydocker目录下有3个Dockerfile文件
```text
/mydocker/
├── Dockerfile_onbuild_father  // 父镜像Dockerfile
├── Dockerfile_onbuild_grandson  // 子镜像Dockerfile
└── Dockerfile_onbuild_son  // 孙镜像Dockerfile
```

* Dockerfile_onbuild_father
    ```text
    FROM centos
    LABEL maintainer="father-image"
    ONBUILD -y RUN yum install tree
    ONBUILD RUN mkdir mydir
    ```
    centos镜像的`WORKDIR`为"/"，所有执行RUN的工作目录为"/"，即相当于`cd /`

* Dockerfile_onbuild_son
    ```text
    FROM father
    LABEL maintainer="son-image"
    ```
    
* Dockerfile_onbuild_grandson
    ```text
    FROM son
    LABEL maintainer="grandson-image"
    RUN mkdir /grandson
    ```

## 构建镜像
切换到`/mydocker`目录
>cd /mydocker

* father image
    ```bash
    docker build -f ./Dockerfile_onbuild_father -t father .
    ```
* son image
    ```bash
    docker build -f ./Dockerfile_onbuild_son -t son .
    ```
    可以看到执行了2个build触发器
    ```text
    Step 1/2 : FROM father
    # Executing 2 build triggers
    ```
* grandson image
    ```bash
    docker build -f ./Dockerfile_onbuild_grandson -t grandson .
    ```
    不会再执行祖先镜像的ONBUILD指令了

查看image
```bash
images 
```

操作日志
```bash
[root@bind-dns mydocker]# cd
[root@bind-dns ~]# cd /mydocker/
[root@bind-dns mydocker]# 
[root@bind-dns mydocker]# docker build -f ./Dockerfile_onbuild_father -t father .
Sending build context to Docker daemon  12.29kB
Step 1/4 : FROM centos
 ---> 300e315adb2f
Step 2/4 : LABEL maintainer="father-image"
 ---> Running in da7f62bac374
Removing intermediate container da7f62bac374
 ---> 76ff29ccf765
Step 3/4 : ONBUILD RUN yum install tree -y
 ---> Running in 8303fe8ba191
Removing intermediate container 8303fe8ba191
 ---> d39c5dd7896d
Step 4/4 : ONBUILD RUN mkdir mydir
 ---> Running in c30ede3afae2
Removing intermediate container c30ede3afae2
 ---> d4b73e9c5a25
Successfully built d4b73e9c5a25
Successfully tagged father:latest
[root@bind-dns mydocker]# 
```

```bash
[root@bind-dns mydocker]# docker build -f ./Dockerfile_onbuild_son -t son .
Sending build context to Docker daemon  12.29kB
Step 1/2 : FROM father
# Executing 2 build triggers
 ---> Running in 89bcd8cabfdf
CentOS Linux 8 - AppStream                      7.8 MB/s | 7.5 MB     00:00    
CentOS Linux 8 - BaseOS                         445 kB/s | 2.6 MB     00:05    
CentOS Linux 8 - Extras                          15 kB/s | 9.6 kB     00:00    
Dependencies resolved.
================================================================================
 Package        Architecture     Version                 Repository        Size
================================================================================
Installing:
 tree           x86_64           1.7.0-15.el8            baseos            59 k

Transaction Summary
================================================================================
Install  1 Package

Total download size: 59 k
Installed size: 109 k
Downloading Packages:
tree-1.7.0-15.el8.x86_64.rpm                    341 kB/s |  59 kB     00:00    
--------------------------------------------------------------------------------
Total                                            83 kB/s |  59 kB     00:00     
warning: /var/cache/dnf/baseos-f6a80ba95cf937f2/packages/tree-1.7.0-15.el8.x86_64.rpm: Header V3 RSA/SHA256 Signature, key ID 8483c65d: NOKEY
CentOS Linux 8 - BaseOS                         1.6 MB/s | 1.6 kB     00:00    
Importing GPG key 0x8483C65D:
 Userid     : "CentOS (CentOS Official Signing Key) <security@centos.org>"
 Fingerprint: 99DB 70FA E1D7 CE22 7FB6 4882 05B5 55B3 8483 C65D
 From       : /etc/pki/rpm-gpg/RPM-GPG-KEY-centosofficial
Key imported successfully
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                                        1/1 
  Installing       : tree-1.7.0-15.el8.x86_64                               1/1 
  Running scriptlet: tree-1.7.0-15.el8.x86_64                               1/1 
  Verifying        : tree-1.7.0-15.el8.x86_64                               1/1 

Installed:
  tree-1.7.0-15.el8.x86_64                                                      

Complete!
Removing intermediate container 89bcd8cabfdf
 ---> Running in 2b9325ef18a4
Removing intermediate container 2b9325ef18a4
 ---> 52ffd2369ded
Step 2/2 : LABEL maintainer="son-image"
 ---> Running in 98774a487e1b
Removing intermediate container 98774a487e1b
 ---> 77828a91cf1c
Successfully built 77828a91cf1c
Successfully tagged son:latest
[root@bind-dns mydocker]#
```
```bash
[root@bind-dns mydocker]# docker build -f ./Dockerfile_onbuild_grandson -t grandson .
Sending build context to Docker daemon  12.29kB
Step 1/3 : FROM son
 ---> 77828a91cf1c
Step 2/3 : LABEL maintainer="grandson-image"
 ---> Running in d81fcd64f7cf
Removing intermediate container d81fcd64f7cf
 ---> ef43fa3f6382
Step 3/3 : RUN mkdir /grandson
 ---> Running in a68b7a8b57c3
Removing intermediate container a68b7a8b57c3
 ---> c9b45f47334c
Successfully built c9b45f47334c
Successfully tagged grandson:latest
[root@bind-dns mydocker]#
```

```bash
[root@bind-dns mydocker]# docker images
REPOSITORY               TAG       IMAGE ID       CREATED              SIZE
grandson                 latest    c9b45f47334c   About a minute ago   244MB
son                      latest    77828a91cf1c   3 minutes ago        244MB
father                   latest    d4b73e9c5a25   3 minutes ago        209MB
```

## 测试镜像
* father image
    ```bash
    docker run -it father
    ```
    操作日志
    ```text
    [root@bind-dns mydocker]# docker run -it father
    [root@719d7ea387fe /]# ls
    bin  dev  etc  home  lib  lib64  lost+found  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var
    [root@719d7ea387fe /]# tree /opt
    bash: tree: command not found
    [root@719d7ea387fe /]# 
    [root@719d7ea387fe /]# ## 这里按 Ctrl + P + Q，让当前容器到后台运行
    ```
    没有tree命令，没有`/mydir`目录。即父Dockerfile中`ONBUILD`指令不对自己产生影响
    
* son image
    ```text
    docker run -it son
    ```
    
    操作日志
    ```bash
    [root@bind-dns mydocker]# 
    [root@bind-dns mydocker]# docker run -it son
    [root@ef49ec254fd6 /]# ls 
    bin  dev  etc  home  lib  lib64  lost+found  media  mnt  mydir	opt  proc  root  run  sbin  srv  sys  tmp  usr	var
    [root@ef49ec254fd6 /]# tree /opt
    /opt
    
    0 directories, 0 files
    [root@ef49ec254fd6 /]# 按 Ctrl + P + Q 
    ```
    有tree命令，有`/mydir`目录
    
* grandson image
    ```bash
    docker run -it grandson
    ```
    
    操作日志
    ```bash
    [root@bind-dns mydocker]# 
    [root@bind-dns mydocker]# 
    [root@bind-dns mydocker]# docker run -it grandson
    [root@f37c6f54906b /]# ls 
    bin  dev  etc  grandson  home  lib  lib64  lost+found  media  mnt  mydir  opt  proc  root  run	sbin  srv  sys	tmp  usr  var
    [root@f37c6f54906b /]# tree /opt
    /opt
    
    0 directories, 0 files
    [root@f37c6f54906b /]# 
    ```
    有tree命令，有`/mydir`、`/grandson`目录