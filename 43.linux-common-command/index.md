# linux常用命令


## 创建用户和用户组

- `$groupadd 用户组名`
- `$useradd -s /bin/bash -g 用户组 -m 用户名`，`-m`选项是自动创建用户home目录
- `$passwd 用户名`
- `$visudo`，visudo默认使用nano编辑，非常难用，不如直接编辑/etc/sudoers
- `$userdel -r 用户名`，`-r`选项是把用户的所有相关数据全部删除

## 远程登陆和远程文件传输

- `ssh`，远程登陆命令。
    >用法：`$ssh [-p port] [user@]hostname`  
    >例如：`$ssh -p 9038 swj@222.30.51.68`
- `scp`，远程文件传输命令，基于ssh协议。
    >用法：`$scp [-r] [-P port] [[user@]host1:]file1 [[user@]host2:]file2`  
    >例如：`$scp -r -P 9038 /mnt/e/dir1 swj@222.30.51.68:/home/swj/dir2`  

    参数说明：  
  - `-r`：递归复制整个目录
  - `-P`：指定host2的端口号

- `sftp`文件传输命令。
    >用法和ssh类似，要先登录：`$sftp [-P port] [user@]hostname`
    >例如：`$sftp -P 9038 swj@222.30.51.68`

    登陆后shell提示符变成了`sftp>`

    >sftp常用命令:  
    >`ls`，`cd`，`pwd`；`lls`，`lcd`，`lpwd`；`put`，`get`；  
    >其中，前面不带`l`的命令是在服务器上进行操作，带`l`的命令是在本地上进行操作，`put`是上传文件，`get`是下载文件；  
    >`$ get filename` 或 `$ get filename`

## 移动文件和目录

- `mv`，移动目录命令。
    >用法：`$mv file1 file2`  
    >移动目录：`$mv dir1 dir2`，如果dir2存在，移动后的结果是dir2/dir1；如果dir2不存在，dir1改名为dir2。
