# nginx安装和配置


## yum安装

参考：[nginx官方文档](http://nginx.org/en/linux_packages.html#RHEL-CentOS)

```bash
yum install -y nginx
systemctl start nginx

nginx -s reload #重新加载nginx配置文件（不会停止nginx服务）
```

- 配置文件：/etc/nginx/nginx.conf
- 日志目录：/var/log/nginx/

## Nginx编译安装

参考：

- [官方文档-编译nginx](http://nginx.org/en/docs/configure.html)

### 准备编译环境（centos）

```bash
# pcre：nginx的rewrite语法和http核心模块用到了pcre的正则表达式语法
# zlib：nginx中用到了zlib的压缩算法
yum install -y \
gcc gcc-c++ \
pcre pcre-devel \
zlib zlib-devel \
openssl openssl-devel
```

### 准备编译环境（debian）

```bash
sudo apt-get install -y \
libpcre3 libpcre3-dev \
openssl libssl-dev \
zlib1g zlib1g.dev
```

### 编译安装

```bash
wget http://nginx.org/download/nginx-1.18.0.tar.gz
tar -zxvf nginx-1.18.0.tar.gz -C web/
cd web/nginx-1.18.0/

(./configure --help # 查看nginx编译配置选项，带有=dynamic的是可以动态添加的模块)

./configure  --prefix=/home/swj/web/nginx \
--with-threads \
--with-file-aio \
--with-http_ssl_module \ #https
--with-http_v2_module \
--with-http_dav_module \ #管理web服务器上的文件
--with-http_gunzip_module \
--with-http_gzip_static_module \
--with-http_auth_request_module \ #访问认证
--with-http_secure_link_module \ #防盗链
--with-http_slice_module \ #报文分片
--with-http_stub_status_module \ # 监控nginx状态
--with-http_realip_module \ #nginx位于反向代理后端时获取真实客户端IP
--with-stream \
--with-stream_ssl_module \
--with-stream_realip_module
```

```bash
#configure之后的输出
Configuration summary
  + using threads
  + using system PCRE library
  + using system OpenSSL library
  + using system zlib library

  nginx path prefix: "/home/swj/web/nginx"
  nginx binary file: "/home/swj/web/nginx/sbin/nginx"
  nginx modules path: "/home/swj/web/nginx/modules"
  nginx configuration prefix: "/home/swj/web/nginx/conf"
  nginx configuration file: "/home/swj/web/nginx/conf/nginx.conf"
  nginx pid file: "/home/swj/web/nginx/logs/nginx.pid"
  nginx error log file: "/home/swj/web/nginx/logs/error.log"
  nginx http access log file: "/home/swj/web/nginx/logs/access.log"
  nginx http client request body temporary files: "client_body_temp"
  nginx http proxy temporary files: "proxy_temp"
  nginx http fastcgi temporary files: "fastcgi_temp"
  nginx http uwsgi temporary files: "uwsgi_temp"
  nginx http scgi temporary files: "scgi_temp"

```

```bash
make
make install
```

### 使用nginx

```bash
# 启动nginx
web/nginx/sbin/nginx
# 不停止服务重读配置文件
web/nginx/sbin/nginx -s reload  
# 停止服务
web/nginx/sbin/nginx -s stop
# 查看nginx版本和configure选项
nginx -V
```

## 配置

配置文件：nginx.conf

## nginx配置示例

- php-fpm路由配置

  ```nginx
  # php-fpm路由配置
  location ~ ^/(.*)(\.php)$ {
      root xxx;
      #Nginx通过本机的9000端口将PHP请求转发给PHP-FPM进行处理
      fastcgi_pass 127.0.0.1:9000;
      fastcgi_index index.php;
      fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
      include fastcgi_params;   #Nginx调用fastcgi接口处理PHP请求
  }
  ```

- wordpress的nginx配置模板：[https://www.nginx.com/resources/wiki/start/topics/recipes/wordpress/](https://www.nginx.com/resources/wiki/start/topics/recipes/wordpress/)

## 常见问题

### nginx启动以后，浏览器不能和服务器建立连接

- 服务器防火墙应该开放nginx的监听端口

### 访问nginx发生403错误

- nginx的执行用户和web目录的所属用户不一致，导致nginx没有资源的访问权限
- 在nginx.conf的第一行增加`user`配置，使nginx的执行用户和web目录所属用户一致。

  ```nginx
  user swj swj;
  ```

## 一些脚本

LNMP启动脚本

```bash
#!/bin/bash

# LNMP启动脚本

# mysql yum安装，开机自启
NginxPath=/home/swj/web/nginx/sbin
FpmPath=/home/swj/web/php-74/sbin

set -e

echo 'swj' | sudo -S $NginxPath/nginx
echo 'swj' | sudo -S $FpmPath/php-fpm
```

nginx重新编译脚本

```bash
#!/bin/bash

SourcePath=/home/swj/web/nginx-1.18.0
InstallPath=/home/swj/web/nginx

set -e

cd $SourcePath

./configure  --prefix=$InstallPath \
--with-threads \
--with-file-aio \
--with-http_ssl_module \
--with-http_v2_module \
--with-http_dav_module \
--with-http_gunzip_module \
--with-http_gzip_static_module \
--with-http_auth_request_module \
--with-http_secure_link_module \
--with-http_slice_module \
--with-http_stub_status_module \
--with-http_realip_module \
--with-stream \
--with-stream_ssl_module \
--with-stream_realip_module

make

mv $InstallPath/sbin/nginx $InstallPath/sbin/nginx_bak

cp $SourcePath/objs/nginx $InstallPath/sbin/nginx

$InstallPath/sbin/nginx -V

```
