# Dockerfile中VOLUME的作用

参考 https://blog.csdn.net/qq32933432/article/details/120944205

## 背景
`docker run -v`这个参数都比较熟悉，无非就是把宿主机目录和容器目录做映射，以便于容器中的某些文件可以直接保存在宿主机上，实现容器被删除之后数据还在，比如我们把mysql装在容器中，肯定不能说容器被删mysql所有的数据也都不在了。第二个作用是也可以用来实现多容器共享同一份文件。

Dockerfile中VOLUME指令：
```Dockerfile
FROM centos:latest
RUN groupadd -r redis && useradd  -r -g redis rediså
RUN yum -y update &&  yum -y install epel-release && yum -y install redis && yum -y install net-tools
RUN mkdir -p /config && chown -R redis:redis /config
#声明容器中/share/data为匿名卷
VOLUME ["/share/data"]
EXPOSE 6379
```

## VOLUME和`docker run -v`的区别

容器运行时应该尽量保持容器存储层不发生写操作，对于数据库类需要保存动态数据的应用，其数据库文件应该保存于卷(VOLUME)中。为了防止运行时用户忘记将动态文件所保存目录挂载为卷，在Dockerfile 中，我们可以事先指定某些目录挂载为匿名卷，这样在运行时如果用户不指定挂载，其应用也可以正常运行，不会向容器存储层写入大量数据。

那么Dockerfile中的`VOLUME`指令实是否跟`docker run -v`参数一样：将宿主机的一个目录绑定到容器中的目录以达到共享目录呢？

并不然，其实`VOLUME`指令只是起到了声明了容器中的目录作为`匿名卷`，但是并没有将匿名卷绑定到宿主机指定目录的功能。
当我们生成镜像的Dockerfile中以`VOLUME`声明了匿名卷，并且我们以这个镜像`docker run`一个容器的时候，docker会在安装目录下的指定目录下面生成一个目录来绑定容器的匿名卷（这个指定目录不同版本的docker会有所不同），我当前的目录为：`/var/lib/docker/VOLUMEs/{容器ID}`。

并且会把镜像中在`VOLUME`指定路径下的数据复制到 主机的 匿名卷上，然后再映射。

## 小结
`VOLUME`只是申明了一个目录，用以在用户忘记启动时指定`-v`参数也可以保证容器的正常运行。
比如mysql，你不能说用户启动时没有指定-v，然后删了容器，就把mysql的数据文件都删了，那样生产上是会出大事故的，所以mysql的Dockerfile里面就需要配置VOLUME 指令，这样即使用户没有指定-v，容器被删后也不会导致数据文件都不在了。还是可以恢复的。


## VOLUME指定的位置在容器被删除以后数据文件会被删除吗
`VOLUME`与`-v`指令一样，容器被删除以后映射在主机上的文件不会被删除。
即 `docker rm <CONTAINER>`，注意不带 `-fv` 参数，如果带了 `-fv` 参数都是会删除的。

## 如果`docker run -v`和`VOLUME`指定了不同的位置，会发生什么事呢
会以`docker run -v`设定的目录为准，其实`VOLUME`指令的设定的目的就是为了避免用户忘记指定 `-v`的时候导致的数据丢失，那么如果用户指定了`-v`，自然而然就不需要`VOLUME`指定的位置了。

## 总结
其实一般的Dockfile如果不是数据库类的这种需要持久化数据到磁盘上的应用，都是无需指定VOLUME的。指定VOLUME只是为了避免用户忘记指定-v时导致的数据全部在容器中，这样的话容器一旦被删除所有的数据都丢失了。
那么为什么Dockerfile中不提供一个能够映射为 主机目录:容器目录 这样的指令呢？其实这样的设计是有道理的，如果在Dockerfile中指定了主机目录，这样Dockerfile就不具备了可移植性了，毕竟每个人所需要映射的目录可能是不同的，那么最好的办法就是把这个权利交给每个运行这个Dockerfile的人，所以才会有`docker run -v 主机目录:容器目录` 这样的指令。
