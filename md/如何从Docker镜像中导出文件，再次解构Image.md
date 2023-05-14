# 如何从Docker镜像中导出文件，再次解构Image
参考 https://blog.csdn.net/chinaherolts2008/article/details/118500470



## 方法1：从运行的容器中复制
先把镜像跑起来，然后从运行起来 java基础教程的容器中复制文件出来，复制命令如下：
```bash
# 从容器复制文件或目录到宿主机器
docker cp 6619ff360cce:/opt/h2-data/pkslow ./
docker cp 6619ff360cce:/opt/h2-data/pkslow/pkslow.txt ./
```

## 方法2：解压Image的tar文件
首先，第一种方法并不是万能的，因为有些镜像python基础教程过于简单，少了许多基础命令，以至于无法复制文件，也无法进入shell环境。

其次，要运行起来再操作，也有点占用资源，比较麻烦。


以ghcr.io/kedacore/keda:2.2.0为例演示如下从该镜像中提取文件：
1. 将镜像保存为tar文件
```bash
$ docker save -o keda.tar ghcr.io/kedacore/keda:2.2.0
```

2. 解压tar文件
```bash
$ tar xvf keda.tar 
x 42b88f0429143256463a478dda36b5e6d63f6dc43e033c3415414149c8c3257b.json
x 82a2e23fb9f1f5ac86b6c60196bff58e163601e5f37f1bc2bb1bd1781e8f6906/
x 82a2e23fb9f1f5ac86b6c60196bff58e163601e5f37f1bc2bb1bd1781e8f6906/VERSION
x 82a2e23fb9f1f5ac86b6c60196bff58e163601e5f37f1bc2bb1bd1781e8f6906/json
x 82a2e23fb9f1f5ac86b6c60196bff58e163601e5f37f1bc2bb1bd1781e8f6906/layer.tar
x ec12616cdd736751f41ba8d32cb9e9553ec33fc9d0bd1df92d4d8995b3dbc8ea/
x ec12616cdd736751f41ba8d32cb9e9553ec33fc9d0bd1df92d4d8995b3dbc8ea/VERSION
x ec12616cdd736751f41ba8d32cb9e9553ec33fc9d0bd1df92d4d8995b3dbc8ea/json
x ec12616cdd736751f41ba8d32cb9e9553ec33fc9d0bd1df92d4d8995b3dbc8ea/layer.tar
x manifest.json
x repositories
```
可以看到每个分层的信息，我们查看manifest.json可以看到具c#教程体哪个layer是最新的。

3. 找其中一个layer再解压
```bash
$ tar xvf ec12616cdd736751f41ba8d32cb9e9553ec33fc9d0bd1df92d4d8995b3dbc8ea/layer.tar
x keda
```
这样，我们就获取到了keda这个可执行文件。每层的打包vb.net教程内容不一样，需要看所需的文件在哪个Layer。