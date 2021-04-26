mysql容器实例
==

1. 拉取镜像
    >docker pull mysql
    
    其他版本看hub mysql的Tags

2. 启动一个mysql容器
    ```bash
    docker run --name mysql01 -d -p 13306:3306 -e MYSQL_ROOT_PASSWORD=my-secret-pw mysql
    ```

### docker容器配置目录
```bash
docker run --name mysql01 -d -p 13306:3306 -e MYSQL_ROOT_PASSWORD=my-secret-pw mysql

docker ps -f name=mysql01
#
CONTAINER ID   IMAGE     COMMAND                  CREATED        STATUS        PORTS                                                    NAMES
cff524e16f5c   mysql     "docker-entrypoint.s…"   18 hours ago   Up 18 hours   33060/tcp, 0.0.0.0:13306->3306/tcp, :::13306->3306/tcp   mysql01


[root@bind-dns cff524e16f5cc4512c5aea22436668fe73364341e88ec8bcba8283523092c955]# pwd
/var/lib/docker/containers/cff524e16f5cc4512c5aea22436668fe73364341e88ec8bcba8283523092c955

[root@bind-dns cff524e16f5cc4512c5aea22436668fe73364341e88ec8bcba8283523092c955]# tree -L 1
.
├── cff524e16f5cc4512c5aea22436668fe73364341e88ec8bcba8283523092c955-json.log  // 日志文件
├── checkpoints
├── config.v2.json  // 容器配置文件，json格式
├── hostconfig.json  // 容器主机配置
├── hostname  // 容器的主机名
├── hosts  // 即linux的 /etc/hosts
├── mounts
├── resolv.conf  // 即linux的 /etc/resolv.conf
└── resolv.conf.hash
```

* 查看默认的docker存储路径
    ```bash
    docker info |grep 'Docker Root Dir'
    
    # 
    WARNING: No swap limit support
    Docker Root Dir: /var/lib/docker
    ```

* config.v2.json
    <details>
    <summary>config.v2.json</summary>
    
    ```json
    {
        "StreamConfig": {
            
        },
        "State": {
            "Running": true,
            "Paused": false,
            "Restarting": false,
            "OOMKilled": false,
            "RemovalInProgress": false,
            "Dead": false,
            "Pid": 54102,
            "ExitCode": 0,
            "Error": "",
            "StartedAt": "2021-04-25T09:52:13.887439402Z",
            "FinishedAt": "0001-01-01T00:00:00Z",
            "Health": null
        },
        "ID": "cff524e16f5cc4512c5aea22436668fe73364341e88ec8bcba8283523092c955",
        "Created": "2021-04-25T09:52:13.612852757Z",
        "Managed": false,
        "Path": "docker-entrypoint.sh",
        "Args": [
            "mysqld"
        ],
        "Config": {
            "Hostname": "cff524e16f5c",  // 容器主机名，即短ID
            "Domainname": "",
            "User": "",
            "AttachStdin": false,
            "AttachStdout": false,
            "AttachStderr": false,
            "ExposedPorts": {
                "3306/tcp": {
                    
                },
                "33060/tcp": {
                    
                }
            },
            "Tty": false,
            "OpenStdin": false,
            "StdinOnce": false,
            "Env": [  // 环境变量
                "MYSQL_ROOT_PASSWORD=my-secret-pw",  // mysql root用户的密码
                "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
                "GOSU_VERSION=1.12",
                "MYSQL_MAJOR=8.0",
                "MYSQL_VERSION=8.0.24-1debian10"
            ],
            // 容器启动后，运行的命令
            "Cmd": [
                "mysqld"
            ],
            "Image": "mysql",
            "Volumes": {  // 挂载的volume卷
                "/var/lib/mysql": {
                    
                }
            },
            "WorkingDir": "",
            "Entrypoint": [
                "docker-entrypoint.sh"
            ],
            "OnBuild": null,
            "Labels": {
                
            }
        },
        "Image": "sha256:0627ec6901db4b2aed6ca7ab35e43e19838ba079fffe8fe1be66b6feaad694de",
        "NetworkSettings": {
            "Bridge": "",
            "SandboxID": "4abb8ea28a5c23dc6f8b0b93e6db08d00fb2fa1d0fdc2cc4028942cbb8fb71b0",
            "HairpinMode": false,
            "LinkLocalIPv6Address": "",
            "LinkLocalIPv6PrefixLen": 0,
            "Networks": {
                "bridge": {
                    "IPAMConfig": null,
                    "Links": null,
                    "Aliases": null,
                    "NetworkID": "628eea485b125d6b2f1a64e8bde739e4cc118d57cbaec2ccf2ba35e918bb51e3",
                    "EndpointID": "41d065851ad020a07436a57959d1023ff0d5b431a295da9a84d6679a5815aebf",
                    "Gateway": "172.17.0.1",
                    "IPAddress": "172.17.0.3",
                    "IPPrefixLen": 16,
                    "IPv6Gateway": "",
                    "GlobalIPv6Address": "",
                    "GlobalIPv6PrefixLen": 0,
                    "MacAddress": "02:42:ac:11:00:03",
                    "DriverOpts": null,
                    "IPAMOperational": false
                }
            },
            "Service": null,
            "Ports": {
                "3306/tcp": [  // 端口映射
                    {
                        "HostIp": "0.0.0.0",
                        "HostPort": "13306"
                    },
                    {
                        "HostIp": "::",
                        "HostPort": "13306"
                    }
                ],
                "33060/tcp": null
            },
            "SandboxKey": "/var/run/docker/netns/4abb8ea28a5c",
            "SecondaryIPAddresses": null,
            "SecondaryIPv6Addresses": null,
            "IsAnonymousEndpoint": false,
            "HasSwarmEndpoint": false
        },
        "LogPath": "/var/lib/docker/containers/cff524e16f5cc4512c5aea22436668fe73364341e88ec8bcba8283523092c955/cff524e16f5cc4512c5aea22436668fe73364341e88ec8bcba8283523092c955-json.log",  // 日志文件
        "Name": "/mysql01",
        "Driver": "overlay2",
        "OS": "linux",
        "MountLabel": "",
        "ProcessLabel": "",
        "RestartCount": 0,
        "HasBeenStartedBefore": true,
        "HasBeenManuallyStopped": false,
        "MountPoints": {  // 挂载点
            "/var/lib/mysql": {
                "Source": "",
                "Destination": "/var/lib/mysql",
                "RW": true,
                /* volume挂载点对应的目录名，默认位于 /var/lib/docker/volumes/<Name>
                   这里对应的是 /var/lib/docker/volumes/c69b2a1b7f8ff84bf90f52306c7ca86a944633d11e61ea7c29b75e8aeda4da34
                   mysql数据库数据保存到此目录下的 _data 目录下
                */
                "Name": "c69b2a1b7f8ff84bf90f52306c7ca86a944633d11e61ea7c29b75e8aeda4da34",  
                "Driver": "local",
                "Type": "volume",
                "ID": "9a748e87b3e3fbc08d2f0ce89d41c2fa84224ab4f0947c5a2f62d9f9b4f5c18d",
                "Spec": {
                    
                },
                "SkipMountpointCreation": false
            }
        },
        "SecretReferences": null,
        "ConfigReferences": null,
        "AppArmorProfile": "",
        "HostnamePath": "/var/lib/docker/containers/cff524e16f5cc4512c5aea22436668fe73364341e88ec8bcba8283523092c955/hostname",
        "HostsPath": "/var/lib/docker/containers/cff524e16f5cc4512c5aea22436668fe73364341e88ec8bcba8283523092c955/hosts",
        "ShmPath": "",
        "ResolvConfPath": "/var/lib/docker/containers/cff524e16f5cc4512c5aea22436668fe73364341e88ec8bcba8283523092c955/resolv.conf",
        "SeccompProfile": "",
        "NoNewPrivileges": false,
        "LocalLogCacheMeta": {
            "HaveNotifyEnabled": false
        }
    }
    ```
</details>

* hostconfig.json
    <details>
    <summary>hostconfig.json</summary>

    ```json
    {
        "Binds": null,
        "ContainerIDFile": "",
        "LogConfig": {
            "Type": "json-file",
            "Config": {
                
            }
        },
        "NetworkMode": "default",
        "PortBindings": {
            "3306/tcp": [
                {
                    "HostIp": "",
                    "HostPort": "13306"
                }
            ]
        },
        "RestartPolicy": {
            "Name": "no",
            "MaximumRetryCount": 0
        },
        "AutoRemove": false,
        "VolumeDriver": "",
        "VolumesFrom": null,
        "CapAdd": null,
        "CapDrop": null,
        "CgroupnsMode": "host",
        "Dns": [
            
        ],
        "DnsOptions": [
            
        ],
        "DnsSearch": [
            
        ],
        "ExtraHosts": null,
        "GroupAdd": null,
        "IpcMode": "private",
        "Cgroup": "",
        "Links": null,
        "OomScoreAdj": 0,
        "PidMode": "",
        "Privileged": false,
        "PublishAllPorts": false,
        "ReadonlyRootfs": false,
        "SecurityOpt": null,
        "UTSMode": "",
        "UsernsMode": "",
        "ShmSize": 67108864,
        "Runtime": "runc",
        "ConsoleSize": [
            0,
            0
        ],
        "Isolation": "",
        "CpuShares": 0,
        "Memory": 0,
        "NanoCpus": 0,
        "CgroupParent": "",
        "BlkioWeight": 0,
        "BlkioWeightDevice": [
            
        ],
        "BlkioDeviceReadBps": null,
        "BlkioDeviceWriteBps": null,
        "BlkioDeviceReadIOps": null,
        "BlkioDeviceWriteIOps": null,
        "CpuPeriod": 0,
        "CpuQuota": 0,
        "CpuRealtimePeriod": 0,
        "CpuRealtimeRuntime": 0,
        "CpusetCpus": "",
        "CpusetMems": "",
        "Devices": [
            
        ],
        "DeviceCgroupRules": null,
        "DeviceRequests": null,
        "KernelMemory": 0,
        "KernelMemoryTCP": 0,
        "MemoryReservation": 0,
        "MemorySwap": 0,
        "MemorySwappiness": null,
        "OomKillDisable": false,
        "PidsLimit": null,
        "Ulimits": null,
        "CpuCount": 0,
        "CpuPercent": 0,
        "IOMaximumIOps": 0,
        "IOMaximumBandwidth": 0,
        "MaskedPaths": [
            "/proc/asound",
            "/proc/acpi",
            "/proc/kcore",
            "/proc/keys",
            "/proc/latency_stats",
            "/proc/timer_list",
            "/proc/timer_stats",
            "/proc/sched_debug",
            "/proc/scsi",
            "/sys/firmware"
        ],
        "ReadonlyPaths": [
            "/proc/bus",
            "/proc/fs",
            "/proc/irq",
            "/proc/sys",
            "/proc/sysrq-trigger"
        ]
    }
    ```
</details>

* hostname
    ```text
    cff524e16f5
    ```
* hosts
    ```text
    127.0.0.1	localhost
    ::1	localhost ip6-localhost ip6-loopback
    fe00::0	ip6-localnet
    ff00::0	ip6-mcastprefix
    ff02::1	ip6-allnodes
    ff02::2	ip6-allrouters
    172.17.0.3	cff524e16f5c
    ```

* resolv.conf
    ```text
    # Generated by NetworkManager
    nameserver 202.96.128.86
    ```