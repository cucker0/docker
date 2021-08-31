Dockerfile多FROM指令存在的意义
==

[参考官网multistage-build](https://docs.docker.com/develop/develop-images/multistage-build/)
[参考 脉冲云--Dockerfile多阶段构建](https://maichong.io/help/docker/dockerfile-multi-stage.html)

## 多FROM什么时候出现的
[Docker 17.05](https://docs.docker.com/engine/release-notes/17.05/)版本及以后，新增了Dockerfile多阶段构建。

所谓多阶段构建，实际上是允许一个Dockerfile 中出现多个 FROM 指令。

这样做有什么意义呢？

## 老版本Docker为什么不支持多个FROM 指令

在17.05版本之前的Docker，只允许Dockerfile中出现一个FROM指令，这得从镜像的本质说起。

在[《Docker概念简介》](https://maichong.io/help/docker/induction.html) 中我们提到，
你可以简单理解Docker的镜像是一个压缩文件，其中包含了你需要的程序和一个文件系统。
其实这样说是不严谨的，Docker镜像并非只是一个文件，而是由一堆文件组成，最主要的文件是 层。

```text
Docker镜像的每一层只记录文件变更，在容器启动时，Docker会将镜像的各个层进行计算，
最后生成一个文件系统，这个被称为 联合挂载。对此感兴趣的话可以进入了解一下 AUFS。

Docker的各个层是有相关性的，在联合挂载的过程中，系统需要知道在什么样的基础上再增加新的文件。
那么这就要求一个Docker镜像只能有一个起始层，只能有一个根。所以，Dockerfile中，就只允许一个 FROM指令。
因为多个 FROM 指令会造成多根，则是无法实现的。
```

## 多个FROM 指令的意义
多个 FROM 指令并不是为了生成多根的层关系，最后生成的镜像，仍**以最后一条 FROM 为准，之前的 FROM 会被抛弃**。

* 之前的FROM 又有什么意义呢

    每一条 FROM 指令都是一个构建阶段，多条 FROM 就是多阶段构建， 
    虽然最后生成的镜像只能是最后一个阶段的结果，  
    但是，**能够将前置阶段中的文件拷贝到后边的阶段中**，这就是多阶段构建的最大意义。

* 最大的使用场景是将编译环境和运行环境分离

### 当个FROM与多个FROM的对比
需要构建一个Go语言程序，那么就需要用到go命令等编译环境，但运行环境中仅仅需要编译后的程序

* 不支持多FROM之前的做法
    
    1. 编译go源码
        
        则Dockerfile可能是这样的：
        ```bash
        # Go语言环境基础镜像
        FROM golang:1.10.3
        
        # 将源码拷贝到镜像中
        COPY server.go /build/
        
        # 指定工作目录
        WORKDIR /build
        
        # 编译镜像时，运行 go build 编译生成 server 程序
        RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 GOARM=6 go build -ldflags '-w -s' -o server
        
        # 指定容器运行时入口程序 server
        ENTRYPOINT ["/build/server"]
        ```
        基础镜像 golang:1.10.3 是非常庞大的，因为其中包含了所有的Go语言编译工具和库。  
        而运行时候我们仅仅需要编译后的 server 程序就行了，不需要编译时的编译工具，最后生成的大体积镜像就是一种浪费。
    
    2. 将可执行程序打包到镜像中
    
        最后将编译接口拷贝到镜像中，那么Dockerfile的基础镜像并不需要包含Go编译环境：
        ```bash
        # 不需要Go语言编译环境
        FROM scratch
        
        # 将编译结果拷贝到容器中
        COPY server /server
        
        # 指定容器运行时入口程序 server
        ENTRYPOINT ["/server"]
        ```
        
        * 提示
            ```text
            scratch 是内置关键词，并不是一个真实存在的镜像。
            FROM scratch 会使用一个完全干净的文件系统，不包含任何文件。 
  
            因为Go语言编译后不需要运行时，也就不需要安装任何的运行库。 
            FROM scratch 可以使得最后生成的镜像最小化，其中只包含了 server 程序。
            ```
* 多FROM解决方案
    
    只需要一个Dockerfile文件:
    ```bash
    # 编译阶段
    FROM golang:1.10.3
    
    COPY server.go /build/
    
    WORKDIR /build
    
    RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 GOARM=6 go build -ldflags '-w -s' -o server
    
    # 运行阶段
    FROM scratch
    
    # 从编译阶段中拷贝编译结果到当前镜像中
    COPY --from=0 /build/server /
    
    ENTRYPOINT ["/server"]
    ```
    这个 Dockerfile 的玄妙之处就在于 COPY 指令的 --from=0 参数，从前边的阶段中拷贝文件到当前阶段中。  
    多个FROM语句时，0代表第一个阶段。
    
### COPY --from的牛逼用法：从指定阶段名复制文件、从镜像中复制文件
* 从指定阶段名复制
    
    Dockerfile
    ```bash
    # 编译阶段
    FROM golang:1.10.3 AS builder
    
    COPY server.go /build/
    
    WORKDIR /build
    
    RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 GOARM=6 go build -ldflags '-w -s' -o server
    
    # 运行阶段
    FROM scratch
    
    # 从编译阶段的中拷贝编译结果到当前镜像中
    COPY --from=builder /build/server /
    
    ENTRYPOINT ["/server"]
    ```

* 从镜像中复制文件

    更为强大的是，COPY --from 不但可以从前置阶段中拷贝，还可以直接从一个已经存在的镜像中复制文件。
    Dockerfile
    ```bash
    FROM ubuntu:16.04
    
    COPY --from=quay.io/coreos/etcd:v3.3.9 /usr/local/bin/etcd /usr/local/bin/
    ```
    我们直接将etcd镜像中的程序拷贝到了我们的镜像中，  
    这样，在生成程序镜像时，就不需要源码编译etcd了，  
    直接将官方编译好的程序文件拿过来就行了。
