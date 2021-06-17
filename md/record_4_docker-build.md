记录docker build镜像过程
==
* /mydocker/Dockerfile_nginx_4
    ```text
    FROM centos
    LABEL maintainer="NGINX Docker Maintainers <docker-maint@nginx.com>"
    RUN yum install -y nginx
    RUN echo "Nginx Web: CMD defining default arguments for an ENTRYPOINT" > /usr/share/nginx/html/index.html
    EXPOSE 80
    CMD ["-g", "daemon off;"]
    ENTRYPOINT ["/usr/sbin/nginx"]
    ```

* docker build日志
    ```bash
    [root@bind-dns mydocker]# docker build -f /mydocker/Dockerfile_nginx_4 -t hanxiao/mynginx:4.1 /mydocker
    Sending build context to Docker daemon  6.144kB
    Step 1/7 : FROM centos
     ---> 300e315adb2f
    Step 2/7 : LABEL maintainer="NGINX Docker Maintainers <docker-maint@nginx.com>"
     ---> Running in 7cdd3908e00a
    Removing intermediate container 7cdd3908e00a
     ---> 8bbd34571cf3
    Step 3/7 : RUN yum install -y nginx
     ---> Running in d754a80bf324
    CentOS Linux 8 - AppStream                      6.9 MB/s | 7.4 MB     00:01    
    CentOS Linux 8 - BaseOS                         3.1 MB/s | 2.6 MB     00:00    
    CentOS Linux 8 - Extras                         8.8 kB/s | 9.6 kB     00:01    
    Dependencies resolved.
    ==============================================================================================
     Package                       Arch    Version                                Repo        Size
    ==============================================================================================
    Installing:
     nginx                         x86_64  1:1.14.1-9.module_el8.0.0+184+e34fea82 appstream  570 k
    Upgrading:
     openssl-libs                  x86_64  1:1.1.1g-15.el8_3                      baseos     1.5 M
    Installing dependencies:
     dejavu-fonts-common           noarch  2.35-7.el8                             baseos      74 k
     dejavu-sans-fonts             noarch  2.35-7.el8                             baseos     1.6 M
     fontconfig                    x86_64  2.13.1-3.el8                           baseos     275 k
     fontpackages-filesystem       noarch  1.44-22.el8                            baseos      16 k
     freetype                      x86_64  2.9.1-4.el8_3.1                        baseos     394 k
     gd                            x86_64  2.2.5-7.el8                            appstream  144 k
     groff-base                    x86_64  1.22.3-18.el8                          baseos     1.0 M
     jbigkit-libs                  x86_64  2.1-14.el8                             appstream   55 k
     libX11                        x86_64  1.6.8-4.el8                            appstream  611 k
     libX11-common                 noarch  1.6.8-4.el8                            appstream  158 k
     libXau                        x86_64  1.0.9-3.el8                            appstream   37 k
     libXpm                        x86_64  3.5.12-8.el8                           appstream   58 k
     libjpeg-turbo                 x86_64  1.5.3-10.el8                           appstream  156 k
     libpng                        x86_64  2:1.6.34-5.el8                         baseos     126 k
     libtiff                       x86_64  4.0.9-18.el8                           appstream  188 k
     libwebp                       x86_64  1.0.0-1.el8                            appstream  273 k
     libxcb                        x86_64  1.13.1-1.el8                           appstream  229 k
     libxslt                       x86_64  1.1.32-6.el8                           baseos     250 k
     ncurses                       x86_64  6.1-7.20180224.el8                     baseos     387 k
     nginx-all-modules             noarch  1:1.14.1-9.module_el8.0.0+184+e34fea82 appstream   23 k
     nginx-filesystem              noarch  1:1.14.1-9.module_el8.0.0+184+e34fea82 appstream   24 k
     nginx-mod-http-image-filter   x86_64  1:1.14.1-9.module_el8.0.0+184+e34fea82 appstream   35 k
     nginx-mod-http-perl           x86_64  1:1.14.1-9.module_el8.0.0+184+e34fea82 appstream   45 k
     nginx-mod-http-xslt-filter    x86_64  1:1.14.1-9.module_el8.0.0+184+e34fea82 appstream   33 k
     nginx-mod-mail                x86_64  1:1.14.1-9.module_el8.0.0+184+e34fea82 appstream   64 k
     nginx-mod-stream              x86_64  1:1.14.1-9.module_el8.0.0+184+e34fea82 appstream   85 k
     openssl                       x86_64  1:1.1.1g-15.el8_3                      baseos     707 k
     perl-Carp                     noarch  1.42-396.el8                           baseos      30 k
     perl-Data-Dumper              x86_64  2.167-399.el8                          baseos      58 k
     perl-Digest                   noarch  1.17-395.el8                           appstream   27 k
     perl-Digest-MD5               x86_64  2.55-396.el8                           appstream   37 k
     perl-Encode                   x86_64  4:2.97-3.el8                           baseos     1.5 M
     perl-Errno                    x86_64  1.28-419.el8                           baseos      76 k
     perl-Exporter                 noarch  5.72-396.el8                           baseos      34 k
     perl-File-Path                noarch  2.15-2.el8                             baseos      38 k
     perl-File-Temp                noarch  0.230.600-1.el8                        baseos      63 k
     perl-Getopt-Long              noarch  1:2.50-4.el8                           baseos      63 k
     perl-HTTP-Tiny                noarch  0.074-1.el8                            baseos      58 k
     perl-IO                       x86_64  1.38-419.el8                           baseos     142 k
     perl-MIME-Base64              x86_64  3.15-396.el8                           baseos      31 k
     perl-Net-SSLeay               x86_64  1.88-1.module_el8.3.0+410+ff426aa3     appstream  379 k
     perl-PathTools                x86_64  3.74-1.el8                             baseos      90 k
     perl-Pod-Escapes              noarch  1:1.07-395.el8                         baseos      20 k
     perl-Pod-Perldoc              noarch  3.28-396.el8                           baseos      86 k
     perl-Pod-Simple               noarch  1:3.35-395.el8                         baseos     213 k
     perl-Pod-Usage                noarch  4:1.69-395.el8                         baseos      34 k
     perl-Scalar-List-Utils        x86_64  3:1.49-2.el8                           baseos      68 k
     perl-Socket                   x86_64  4:2.027-3.el8                          baseos      59 k
     perl-Storable                 x86_64  1:3.11-3.el8                           baseos      98 k
     perl-Term-ANSIColor           noarch  4.06-396.el8                           baseos      46 k
     perl-Term-Cap                 noarch  1.17-395.el8                           baseos      23 k
     perl-Text-ParseWords          noarch  3.30-395.el8                           baseos      18 k
     perl-Text-Tabs+Wrap           noarch  2013.0523-395.el8                      baseos      24 k
     perl-Time-Local               noarch  1:1.280-1.el8                          baseos      34 k
     perl-URI                      noarch  1.73-3.el8                             appstream  116 k
     perl-Unicode-Normalize        x86_64  1.25-396.el8                           baseos      82 k
     perl-constant                 noarch  1.33-396.el8                           baseos      25 k
     perl-interpreter              x86_64  4:5.26.3-419.el8                       baseos     6.3 M
     perl-libnet                   noarch  3.11-3.el8                             appstream  121 k
     perl-libs                     x86_64  4:5.26.3-419.el8                       baseos     1.6 M
     perl-macros                   x86_64  4:5.26.3-419.el8                       baseos      72 k
     perl-parent                   noarch  1:0.237-1.el8                          baseos      20 k
     perl-podlators                noarch  4.11-1.el8                             baseos     118 k
     perl-threads                  x86_64  1:2.21-2.el8                           baseos      61 k
     perl-threads-shared           x86_64  1.58-2.el8                             baseos      48 k
    Installing weak dependencies:
     openssl-pkcs11                x86_64  0.4.10-2.el8                           baseos      66 k
     perl-IO-Socket-IP             noarch  0.39-5.el8                             appstream   47 k
     perl-IO-Socket-SSL            noarch  2.066-4.module_el8.3.0+410+ff426aa3    appstream  298 k
     perl-Mozilla-CA               noarch  20160104-7.module_el8.3.0+416+dee7bcef appstream   15 k
    Enabling module streams:
     nginx                                 1.14                                                   
     perl                                  5.26                                                   
     perl-IO-Socket-SSL                    2.066                                                  
     perl-libwww-perl                      6.34                                                   
    
    Transaction Summary
    ==============================================================================================
    Install  70 Packages
    Upgrade   1 Package
    
    Total download size: 21 M
    Downloading Packages:
    (1/71): jbigkit-libs-2.1-14.el8.x86_64.rpm      449 kB/s |  55 kB     00:00    
    (2/71): libX11-1.6.8-4.el8.x86_64.rpm           3.5 MB/s | 611 kB     00:00    
    (3/71): libX11-common-1.6.8-4.el8.noarch.rpm    2.4 MB/s | 158 kB     00:00    
    (4/71): gd-2.2.5-7.el8.x86_64.rpm               765 kB/s | 144 kB     00:00    
    (5/71): libXau-1.0.9-3.el8.x86_64.rpm           1.6 MB/s |  37 kB     00:00    
    (6/71): libXpm-3.5.12-8.el8.x86_64.rpm          1.6 MB/s |  58 kB     00:00    
    (7/71): libtiff-4.0.9-18.el8.x86_64.rpm         2.3 MB/s | 188 kB     00:00    
    (8/71): libjpeg-turbo-1.5.3-10.el8.x86_64.rpm   1.8 MB/s | 156 kB     00:00    
    (9/71): libwebp-1.0.0-1.el8.x86_64.rpm          2.6 MB/s | 273 kB     00:00    
    (10/71): libxcb-1.13.1-1.el8.x86_64.rpm         4.1 MB/s | 229 kB     00:00    
    (11/71): nginx-all-modules-1.14.1-9.module_el8. 549 kB/s |  23 kB     00:00    
    (12/71): nginx-filesystem-1.14.1-9.module_el8.0 371 kB/s |  24 kB     00:00    
    (13/71): nginx-1.14.1-9.module_el8.0.0+184+e34f 4.6 MB/s | 570 kB     00:00    
    (14/71): nginx-mod-http-image-filter-1.14.1-9.m 653 kB/s |  35 kB     00:00    
    (15/71): nginx-mod-http-perl-1.14.1-9.module_el 881 kB/s |  45 kB     00:00    
    (16/71): nginx-mod-http-xslt-filter-1.14.1-9.mo 455 kB/s |  33 kB     00:00    
    (17/71): nginx-mod-mail-1.14.1-9.module_el8.0.0 887 kB/s |  64 kB     00:00    
    (18/71): nginx-mod-stream-1.14.1-9.module_el8.0 1.1 MB/s |  85 kB     00:00    
    (19/71): perl-Digest-1.17-395.el8.noarch.rpm    364 kB/s |  27 kB     00:00    
    (20/71): perl-Digest-MD5-2.55-396.el8.x86_64.rp 504 kB/s |  37 kB     00:00    
    (21/71): perl-IO-Socket-IP-0.39-5.el8.noarch.rp 632 kB/s |  47 kB     00:00    
    (22/71): perl-IO-Socket-SSL-2.066-4.module_el8. 3.6 MB/s | 298 kB     00:00    
    (23/71): perl-Mozilla-CA-20160104-7.module_el8. 208 kB/s |  15 kB     00:00    
    (24/71): perl-Net-SSLeay-1.88-1.module_el8.3.0+ 4.3 MB/s | 379 kB     00:00    
    (25/71): perl-URI-1.73-3.el8.noarch.rpm         1.6 MB/s | 116 kB     00:00    
    (26/71): perl-libnet-3.11-3.el8.noarch.rpm      1.5 MB/s | 121 kB     00:00    
    (27/71): dejavu-fonts-common-2.35-7.el8.noarch. 538 kB/s |  74 kB     00:00    
    (28/71): fontpackages-filesystem-1.44-22.el8.no 560 kB/s |  16 kB     00:00    
    (29/71): fontconfig-2.13.1-3.el8.x86_64.rpm     1.4 MB/s | 275 kB     00:00    
    (30/71): freetype-2.9.1-4.el8_3.1.x86_64.rpm    4.1 MB/s | 394 kB     00:00    
    (31/71): dejavu-sans-fonts-2.35-7.el8.noarch.rp 5.7 MB/s | 1.6 MB     00:00    
    (32/71): libpng-1.6.34-5.el8.x86_64.rpm         2.2 MB/s | 126 kB     00:00    
    (33/71): groff-base-1.22.3-18.el8.x86_64.rpm    9.0 MB/s | 1.0 MB     00:00    
    (34/71): libxslt-1.1.32-6.el8.x86_64.rpm        4.3 MB/s | 250 kB     00:00    
    (35/71): openssl-pkcs11-0.4.10-2.el8.x86_64.rpm 1.5 MB/s |  66 kB     00:00    
    (36/71): ncurses-6.1-7.20180224.el8.x86_64.rpm  4.0 MB/s | 387 kB     00:00    
    (37/71): openssl-1.1.1g-15.el8_3.x86_64.rpm     9.2 MB/s | 707 kB     00:00    
    (38/71): perl-Carp-1.42-396.el8.noarch.rpm      740 kB/s |  30 kB     00:00    
    (39/71): perl-Data-Dumper-2.167-399.el8.x86_64. 1.3 MB/s |  58 kB     00:00    
    (40/71): perl-Errno-1.28-419.el8.x86_64.rpm     1.8 MB/s |  76 kB     00:00    
    (41/71): perl-Exporter-5.72-396.el8.noarch.rpm  916 kB/s |  34 kB     00:00    
    (42/71): perl-File-Path-2.15-2.el8.noarch.rpm   915 kB/s |  38 kB     00:00    
    (43/71): perl-Encode-2.97-3.el8.x86_64.rpm       13 MB/s | 1.5 MB     00:00    
    (44/71): perl-File-Temp-0.230.600-1.el8.noarch. 1.5 MB/s |  63 kB     00:00    
    (45/71): perl-Getopt-Long-2.50-4.el8.noarch.rpm 1.2 MB/s |  63 kB     00:00    
    (46/71): perl-HTTP-Tiny-0.074-1.el8.noarch.rpm  1.5 MB/s |  58 kB     00:00    
    (47/71): perl-IO-1.38-419.el8.x86_64.rpm        2.6 MB/s | 142 kB     00:00    
    (48/71): perl-MIME-Base64-3.15-396.el8.x86_64.r 820 kB/s |  31 kB     00:00    
    (49/71): perl-PathTools-3.74-1.el8.x86_64.rpm   2.4 MB/s |  90 kB     00:00    
    (50/71): perl-Pod-Escapes-1.07-395.el8.noarch.r 671 kB/s |  20 kB     00:00    
    (51/71): perl-Pod-Simple-3.35-395.el8.noarch.rp 5.7 MB/s | 213 kB     00:00    
    (52/71): perl-Pod-Perldoc-3.28-396.el8.noarch.r 2.2 MB/s |  86 kB     00:00    
    (53/71): perl-Pod-Usage-1.69-395.el8.noarch.rpm 1.1 MB/s |  34 kB     00:00    
    (54/71): perl-Socket-2.027-3.el8.x86_64.rpm     1.7 MB/s |  59 kB     00:00    
    (55/71): perl-Storable-3.11-3.el8.x86_64.rpm    2.3 MB/s |  98 kB     00:00    
    (56/71): perl-Scalar-List-Utils-1.49-2.el8.x86_ 1.4 MB/s |  68 kB     00:00    
    (57/71): perl-Term-ANSIColor-4.06-396.el8.noarc 1.5 MB/s |  46 kB     00:00    
    (58/71): perl-Term-Cap-1.17-395.el8.noarch.rpm  772 kB/s |  23 kB     00:00    
    (59/71): perl-Text-ParseWords-3.30-395.el8.noar 555 kB/s |  18 kB     00:00    
    (60/71): perl-Text-Tabs+Wrap-2013.0523-395.el8. 785 kB/s |  24 kB     00:00    
    (61/71): perl-Time-Local-1.280-1.el8.noarch.rpm 1.1 MB/s |  34 kB     00:00    
    (62/71): perl-Unicode-Normalize-1.25-396.el8.x8 2.0 MB/s |  82 kB     00:00    
    (63/71): perl-constant-1.33-396.el8.noarch.rpm  790 kB/s |  25 kB     00:00    
    (64/71): perl-macros-5.26.3-419.el8.x86_64.rpm  2.0 MB/s |  72 kB     00:00    
    (65/71): perl-parent-0.237-1.el8.noarch.rpm     591 kB/s |  20 kB     00:00    
    (66/71): perl-podlators-4.11-1.el8.noarch.rpm   3.1 MB/s | 118 kB     00:00    
    (67/71): perl-threads-2.21-2.el8.x86_64.rpm     1.5 MB/s |  61 kB     00:00    
    (68/71): perl-libs-5.26.3-419.el8.x86_64.rpm    8.7 MB/s | 1.6 MB     00:00    
    (69/71): perl-threads-shared-1.58-2.el8.x86_64. 1.2 MB/s |  48 kB     00:00    
    (70/71): openssl-libs-1.1.1g-15.el8_3.x86_64.rp 9.4 MB/s | 1.5 MB     00:00    
    (71/71): perl-interpreter-5.26.3-419.el8.x86_64  12 MB/s | 6.3 MB     00:00    
    --------------------------------------------------------------------------------
    Total                                           7.8 MB/s |  21 MB     00:02     
    warning: /var/cache/dnf/appstream-02e86d1c976ab532/packages/gd-2.2.5-7.el8.x86_64.rpm: Header V3 RSA/SHA256 Signature, key ID 8483c65d: NOKEY
    CentOS Linux 8 - AppStream                      1.6 MB/s | 1.6 kB     00:00    
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
      Upgrading        : openssl-libs-1:1.1.1g-15.el8_3.x86_64                 1/72 
      Running scriptlet: openssl-libs-1:1.1.1g-15.el8_3.x86_64                 1/72 
      Installing       : openssl-1:1.1.1g-15.el8_3.x86_64                      2/72 
      Installing       : openssl-pkcs11-0.4.10-2.el8.x86_64                    3/72 
      Installing       : libpng-2:1.6.34-5.el8.x86_64                          4/72 
      Installing       : freetype-2.9.1-4.el8_3.1.x86_64                       5/72 
      Installing       : fontpackages-filesystem-1.44-22.el8.noarch            6/72 
      Installing       : libjpeg-turbo-1.5.3-10.el8.x86_64                     7/72 
      Installing       : dejavu-fonts-common-2.35-7.el8.noarch                 8/72 
      Installing       : dejavu-sans-fonts-2.35-7.el8.noarch                   9/72 
      Installing       : fontconfig-2.13.1-3.el8.x86_64                       10/72 
      Running scriptlet: fontconfig-2.13.1-3.el8.x86_64                       10/72 
      Installing       : ncurses-6.1-7.20180224.el8.x86_64                    11/72 
      Installing       : libxslt-1.1.32-6.el8.x86_64                          12/72 
      Installing       : groff-base-1.22.3-18.el8.x86_64                      13/72 
      Installing       : perl-Digest-1.17-395.el8.noarch                      14/72 
      Installing       : perl-Digest-MD5-2.55-396.el8.x86_64                  15/72 
      Installing       : perl-Data-Dumper-2.167-399.el8.x86_64                16/72 
      Installing       : perl-libnet-3.11-3.el8.noarch                        17/72 
      Installing       : perl-Net-SSLeay-1.88-1.module_el8.3.0+410+ff426aa3   18/72 
      Installing       : perl-URI-1.73-3.el8.noarch                           19/72 
      Installing       : perl-Pod-Escapes-1:1.07-395.el8.noarch               20/72 
      Installing       : perl-Mozilla-CA-20160104-7.module_el8.3.0+416+dee7   21/72 
      Installing       : perl-IO-Socket-IP-0.39-5.el8.noarch                  22/72 
      Installing       : perl-Time-Local-1:1.280-1.el8.noarch                 23/72 
      Installing       : perl-IO-Socket-SSL-2.066-4.module_el8.3.0+410+ff42   24/72 
      Installing       : perl-Term-ANSIColor-4.06-396.el8.noarch              25/72 
      Installing       : perl-Term-Cap-1.17-395.el8.noarch                    26/72 
      Installing       : perl-File-Temp-0.230.600-1.el8.noarch                27/72 
      Installing       : perl-Pod-Simple-1:3.35-395.el8.noarch                28/72 
      Installing       : perl-HTTP-Tiny-0.074-1.el8.noarch                    29/72 
      Installing       : perl-podlators-4.11-1.el8.noarch                     30/72 
      Installing       : perl-Pod-Perldoc-3.28-396.el8.noarch                 31/72 
      Installing       : perl-Text-ParseWords-3.30-395.el8.noarch             32/72 
      Installing       : perl-Pod-Usage-4:1.69-395.el8.noarch                 33/72 
      Installing       : perl-MIME-Base64-3.15-396.el8.x86_64                 34/72 
      Installing       : perl-Storable-1:3.11-3.el8.x86_64                    35/72 
      Installing       : perl-Getopt-Long-1:2.50-4.el8.noarch                 36/72 
      Installing       : perl-Errno-1.28-419.el8.x86_64                       37/72 
      Installing       : perl-Socket-4:2.027-3.el8.x86_64                     38/72 
      Installing       : perl-Encode-4:2.97-3.el8.x86_64                      39/72 
      Installing       : perl-Carp-1.42-396.el8.noarch                        40/72 
      Installing       : perl-Exporter-5.72-396.el8.noarch                    41/72 
      Installing       : perl-libs-4:5.26.3-419.el8.x86_64                    42/72 
      Installing       : perl-Scalar-List-Utils-3:1.49-2.el8.x86_64           43/72 
      Installing       : perl-parent-1:0.237-1.el8.noarch                     44/72 
      Installing       : perl-macros-4:5.26.3-419.el8.x86_64                  45/72 
      Installing       : perl-Text-Tabs+Wrap-2013.0523-395.el8.noarch         46/72 
      Installing       : perl-Unicode-Normalize-1.25-396.el8.x86_64           47/72 
      Installing       : perl-File-Path-2.15-2.el8.noarch                     48/72 
      Installing       : perl-IO-1.38-419.el8.x86_64                          49/72 
      Installing       : perl-PathTools-3.74-1.el8.x86_64                     50/72 
      Installing       : perl-constant-1.33-396.el8.noarch                    51/72 
      Installing       : perl-threads-1:2.21-2.el8.x86_64                     52/72 
      Installing       : perl-threads-shared-1.58-2.el8.x86_64                53/72 
      Installing       : perl-interpreter-4:5.26.3-419.el8.x86_64             54/72 
      Running scriptlet: nginx-filesystem-1:1.14.1-9.module_el8.0.0+184+e34   55/72 
      Installing       : nginx-filesystem-1:1.14.1-9.module_el8.0.0+184+e34   55/72 
      Installing       : libwebp-1.0.0-1.el8.x86_64                           56/72 
      Installing       : libXau-1.0.9-3.el8.x86_64                            57/72 
      Installing       : libxcb-1.13.1-1.el8.x86_64                           58/72 
      Installing       : libX11-common-1.6.8-4.el8.noarch                     59/72 
      Installing       : libX11-1.6.8-4.el8.x86_64                            60/72 
      Installing       : libXpm-3.5.12-8.el8.x86_64                           61/72 
      Installing       : jbigkit-libs-2.1-14.el8.x86_64                       62/72 
      Running scriptlet: jbigkit-libs-2.1-14.el8.x86_64                       62/72 
      Installing       : libtiff-4.0.9-18.el8.x86_64                          63/72 
      Installing       : gd-2.2.5-7.el8.x86_64                                64/72 
      Running scriptlet: gd-2.2.5-7.el8.x86_64                                64/72 
      Installing       : nginx-mod-http-perl-1:1.14.1-9.module_el8.0.0+184+   65/72 
      Running scriptlet: nginx-mod-http-perl-1:1.14.1-9.module_el8.0.0+184+   65/72 
      Installing       : nginx-mod-http-xslt-filter-1:1.14.1-9.module_el8.0   66/72 
      Running scriptlet: nginx-mod-http-xslt-filter-1:1.14.1-9.module_el8.0   66/72 
      Installing       : nginx-mod-mail-1:1.14.1-9.module_el8.0.0+184+e34fe   67/72 
      Running scriptlet: nginx-mod-mail-1:1.14.1-9.module_el8.0.0+184+e34fe   67/72 
      Installing       : nginx-mod-stream-1:1.14.1-9.module_el8.0.0+184+e34   68/72 
      Running scriptlet: nginx-mod-stream-1:1.14.1-9.module_el8.0.0+184+e34   68/72 
      Installing       : nginx-1:1.14.1-9.module_el8.0.0+184+e34fea82.x86_6   69/72 
      Running scriptlet: nginx-1:1.14.1-9.module_el8.0.0+184+e34fea82.x86_6   69/72 
      Installing       : nginx-mod-http-image-filter-1:1.14.1-9.module_el8.   70/72 
      Running scriptlet: nginx-mod-http-image-filter-1:1.14.1-9.module_el8.   70/72 
      Installing       : nginx-all-modules-1:1.14.1-9.module_el8.0.0+184+e3   71/72 
      Cleanup          : openssl-libs-1:1.1.1g-11.el8.x86_64                  72/72 
      Running scriptlet: openssl-libs-1:1.1.1g-11.el8.x86_64                  72/72 
      Running scriptlet: fontconfig-2.13.1-3.el8.x86_64                       72/72 
      Verifying        : gd-2.2.5-7.el8.x86_64                                 1/72 
      Verifying        : jbigkit-libs-2.1-14.el8.x86_64                        2/72 
      Verifying        : libX11-1.6.8-4.el8.x86_64                             3/72 
      Verifying        : libX11-common-1.6.8-4.el8.noarch                      4/72 
      Verifying        : libXau-1.0.9-3.el8.x86_64                             5/72 
      Verifying        : libXpm-3.5.12-8.el8.x86_64                            6/72 
      Verifying        : libjpeg-turbo-1.5.3-10.el8.x86_64                     7/72 
      Verifying        : libtiff-4.0.9-18.el8.x86_64                           8/72 
      Verifying        : libwebp-1.0.0-1.el8.x86_64                            9/72 
      Verifying        : libxcb-1.13.1-1.el8.x86_64                           10/72 
      Verifying        : nginx-1:1.14.1-9.module_el8.0.0+184+e34fea82.x86_6   11/72 
      Verifying        : nginx-all-modules-1:1.14.1-9.module_el8.0.0+184+e3   12/72 
      Verifying        : nginx-filesystem-1:1.14.1-9.module_el8.0.0+184+e34   13/72 
      Verifying        : nginx-mod-http-image-filter-1:1.14.1-9.module_el8.   14/72 
      Verifying        : nginx-mod-http-perl-1:1.14.1-9.module_el8.0.0+184+   15/72 
      Verifying        : nginx-mod-http-xslt-filter-1:1.14.1-9.module_el8.0   16/72 
      Verifying        : nginx-mod-mail-1:1.14.1-9.module_el8.0.0+184+e34fe   17/72 
      Verifying        : nginx-mod-stream-1:1.14.1-9.module_el8.0.0+184+e34   18/72 
      Verifying        : perl-Digest-1.17-395.el8.noarch                      19/72 
      Verifying        : perl-Digest-MD5-2.55-396.el8.x86_64                  20/72 
      Verifying        : perl-IO-Socket-IP-0.39-5.el8.noarch                  21/72 
      Verifying        : perl-IO-Socket-SSL-2.066-4.module_el8.3.0+410+ff42   22/72 
      Verifying        : perl-Mozilla-CA-20160104-7.module_el8.3.0+416+dee7   23/72 
      Verifying        : perl-Net-SSLeay-1.88-1.module_el8.3.0+410+ff426aa3   24/72 
      Verifying        : perl-URI-1.73-3.el8.noarch                           25/72 
      Verifying        : perl-libnet-3.11-3.el8.noarch                        26/72 
      Verifying        : dejavu-fonts-common-2.35-7.el8.noarch                27/72 
      Verifying        : dejavu-sans-fonts-2.35-7.el8.noarch                  28/72 
      Verifying        : fontconfig-2.13.1-3.el8.x86_64                       29/72 
      Verifying        : fontpackages-filesystem-1.44-22.el8.noarch           30/72 
      Verifying        : freetype-2.9.1-4.el8_3.1.x86_64                      31/72 
      Verifying        : groff-base-1.22.3-18.el8.x86_64                      32/72 
      Verifying        : libpng-2:1.6.34-5.el8.x86_64                         33/72 
      Verifying        : libxslt-1.1.32-6.el8.x86_64                          34/72 
      Verifying        : ncurses-6.1-7.20180224.el8.x86_64                    35/72 
      Verifying        : openssl-1:1.1.1g-15.el8_3.x86_64                     36/72 
      Verifying        : openssl-pkcs11-0.4.10-2.el8.x86_64                   37/72 
      Verifying        : perl-Carp-1.42-396.el8.noarch                        38/72 
      Verifying        : perl-Data-Dumper-2.167-399.el8.x86_64                39/72 
      Verifying        : perl-Encode-4:2.97-3.el8.x86_64                      40/72 
      Verifying        : perl-Errno-1.28-419.el8.x86_64                       41/72 
      Verifying        : perl-Exporter-5.72-396.el8.noarch                    42/72 
      Verifying        : perl-File-Path-2.15-2.el8.noarch                     43/72 
      Verifying        : perl-File-Temp-0.230.600-1.el8.noarch                44/72 
      Verifying        : perl-Getopt-Long-1:2.50-4.el8.noarch                 45/72 
      Verifying        : perl-HTTP-Tiny-0.074-1.el8.noarch                    46/72 
      Verifying        : perl-IO-1.38-419.el8.x86_64                          47/72 
      Verifying        : perl-MIME-Base64-3.15-396.el8.x86_64                 48/72 
      Verifying        : perl-PathTools-3.74-1.el8.x86_64                     49/72 
      Verifying        : perl-Pod-Escapes-1:1.07-395.el8.noarch               50/72 
      Verifying        : perl-Pod-Perldoc-3.28-396.el8.noarch                 51/72 
      Verifying        : perl-Pod-Simple-1:3.35-395.el8.noarch                52/72 
      Verifying        : perl-Pod-Usage-4:1.69-395.el8.noarch                 53/72 
      Verifying        : perl-Scalar-List-Utils-3:1.49-2.el8.x86_64           54/72 
      Verifying        : perl-Socket-4:2.027-3.el8.x86_64                     55/72 
      Verifying        : perl-Storable-1:3.11-3.el8.x86_64                    56/72 
      Verifying        : perl-Term-ANSIColor-4.06-396.el8.noarch              57/72 
      Verifying        : perl-Term-Cap-1.17-395.el8.noarch                    58/72 
      Verifying        : perl-Text-ParseWords-3.30-395.el8.noarch             59/72 
      Verifying        : perl-Text-Tabs+Wrap-2013.0523-395.el8.noarch         60/72 
      Verifying        : perl-Time-Local-1:1.280-1.el8.noarch                 61/72 
      Verifying        : perl-Unicode-Normalize-1.25-396.el8.x86_64           62/72 
      Verifying        : perl-constant-1.33-396.el8.noarch                    63/72 
      Verifying        : perl-interpreter-4:5.26.3-419.el8.x86_64             64/72 
      Verifying        : perl-libs-4:5.26.3-419.el8.x86_64                    65/72 
      Verifying        : perl-macros-4:5.26.3-419.el8.x86_64                  66/72 
      Verifying        : perl-parent-1:0.237-1.el8.noarch                     67/72 
      Verifying        : perl-podlators-4.11-1.el8.noarch                     68/72 
      Verifying        : perl-threads-1:2.21-2.el8.x86_64                     69/72 
      Verifying        : perl-threads-shared-1.58-2.el8.x86_64                70/72 
      Verifying        : openssl-libs-1:1.1.1g-15.el8_3.x86_64                71/72 
      Verifying        : openssl-libs-1:1.1.1g-11.el8.x86_64                  72/72 
    
    Upgraded:
      openssl-libs-1:1.1.1g-15.el8_3.x86_64                                         
    
    Installed:
      dejavu-fonts-common-2.35-7.el8.noarch                                         
      dejavu-sans-fonts-2.35-7.el8.noarch                                           
      fontconfig-2.13.1-3.el8.x86_64                                                
      fontpackages-filesystem-1.44-22.el8.noarch                                    
      freetype-2.9.1-4.el8_3.1.x86_64                                               
      gd-2.2.5-7.el8.x86_64                                                         
      groff-base-1.22.3-18.el8.x86_64                                               
      jbigkit-libs-2.1-14.el8.x86_64                                                
      libX11-1.6.8-4.el8.x86_64                                                     
      libX11-common-1.6.8-4.el8.noarch                                              
      libXau-1.0.9-3.el8.x86_64                                                     
      libXpm-3.5.12-8.el8.x86_64                                                    
      libjpeg-turbo-1.5.3-10.el8.x86_64                                             
      libpng-2:1.6.34-5.el8.x86_64                                                  
      libtiff-4.0.9-18.el8.x86_64                                                   
      libwebp-1.0.0-1.el8.x86_64                                                    
      libxcb-1.13.1-1.el8.x86_64                                                    
      libxslt-1.1.32-6.el8.x86_64                                                   
      ncurses-6.1-7.20180224.el8.x86_64                                             
      nginx-1:1.14.1-9.module_el8.0.0+184+e34fea82.x86_64                           
      nginx-all-modules-1:1.14.1-9.module_el8.0.0+184+e34fea82.noarch               
      nginx-filesystem-1:1.14.1-9.module_el8.0.0+184+e34fea82.noarch                
      nginx-mod-http-image-filter-1:1.14.1-9.module_el8.0.0+184+e34fea82.x86_64     
      nginx-mod-http-perl-1:1.14.1-9.module_el8.0.0+184+e34fea82.x86_64             
      nginx-mod-http-xslt-filter-1:1.14.1-9.module_el8.0.0+184+e34fea82.x86_64      
      nginx-mod-mail-1:1.14.1-9.module_el8.0.0+184+e34fea82.x86_64                  
      nginx-mod-stream-1:1.14.1-9.module_el8.0.0+184+e34fea82.x86_64                
      openssl-1:1.1.1g-15.el8_3.x86_64                                              
      openssl-pkcs11-0.4.10-2.el8.x86_64                                            
      perl-Carp-1.42-396.el8.noarch                                                 
      perl-Data-Dumper-2.167-399.el8.x86_64                                         
      perl-Digest-1.17-395.el8.noarch                                               
      perl-Digest-MD5-2.55-396.el8.x86_64                                           
      perl-Encode-4:2.97-3.el8.x86_64                                               
      perl-Errno-1.28-419.el8.x86_64                                                
      perl-Exporter-5.72-396.el8.noarch                                             
      perl-File-Path-2.15-2.el8.noarch                                              
      perl-File-Temp-0.230.600-1.el8.noarch                                         
      perl-Getopt-Long-1:2.50-4.el8.noarch                                          
      perl-HTTP-Tiny-0.074-1.el8.noarch                                             
      perl-IO-1.38-419.el8.x86_64                                                   
      perl-IO-Socket-IP-0.39-5.el8.noarch                                           
      perl-IO-Socket-SSL-2.066-4.module_el8.3.0+410+ff426aa3.noarch                 
      perl-MIME-Base64-3.15-396.el8.x86_64                                          
      perl-Mozilla-CA-20160104-7.module_el8.3.0+416+dee7bcef.noarch                 
      perl-Net-SSLeay-1.88-1.module_el8.3.0+410+ff426aa3.x86_64                     
      perl-PathTools-3.74-1.el8.x86_64                                              
      perl-Pod-Escapes-1:1.07-395.el8.noarch                                        
      perl-Pod-Perldoc-3.28-396.el8.noarch                                          
      perl-Pod-Simple-1:3.35-395.el8.noarch                                         
      perl-Pod-Usage-4:1.69-395.el8.noarch                                          
      perl-Scalar-List-Utils-3:1.49-2.el8.x86_64                                    
      perl-Socket-4:2.027-3.el8.x86_64                                              
      perl-Storable-1:3.11-3.el8.x86_64                                             
      perl-Term-ANSIColor-4.06-396.el8.noarch                                       
      perl-Term-Cap-1.17-395.el8.noarch                                             
      perl-Text-ParseWords-3.30-395.el8.noarch                                      
      perl-Text-Tabs+Wrap-2013.0523-395.el8.noarch                                  
      perl-Time-Local-1:1.280-1.el8.noarch                                          
      perl-URI-1.73-3.el8.noarch                                                    
      perl-Unicode-Normalize-1.25-396.el8.x86_64                                    
      perl-constant-1.33-396.el8.noarch                                             
      perl-interpreter-4:5.26.3-419.el8.x86_64                                      
      perl-libnet-3.11-3.el8.noarch                                                 
      perl-libs-4:5.26.3-419.el8.x86_64                                             
      perl-macros-4:5.26.3-419.el8.x86_64                                           
      perl-parent-1:0.237-1.el8.noarch                                              
      perl-podlators-4.11-1.el8.noarch                                              
      perl-threads-1:2.21-2.el8.x86_64                                              
      perl-threads-shared-1.58-2.el8.x86_64                                         
    
    Complete!
    Removing intermediate container d754a80bf324
     ---> 868708ae954c
    Step 4/7 : RUN echo "Nginx Web: CMD defining default arguments for an ENTRYPOINT" > /usr/share/nginx/html/index.html
     ---> Running in 488abfad04bf
    Removing intermediate container 488abfad04bf
     ---> df66d73420f5
    Step 5/7 : EXPOSE 80
     ---> Running in e34cf19ef382
    Removing intermediate container e34cf19ef382
     ---> 759878630589
    Step 6/7 : CMD ["-g", "daemon off;"]
     ---> Running in 62eaf8755c68
    Removing intermediate container 62eaf8755c68
     ---> e7ab9548a070
    Step 7/7 : ENTRYPOINT ["/usr/sbin/nginx"]
     ---> Running in e1c089556ca2
    Removing intermediate container e1c089556ca2
     ---> 7ff1fe56a3b6
    Successfully built 7ff1fe56a3b6
    Successfully tagged hanxiao/mynginx:4.1
    [root@bind-dns mydocker]# 
    ```