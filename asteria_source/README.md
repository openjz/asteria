# asteria

This is my personal web site.

## 目录结构介绍

```
│  CNAME : github生成的域名文件，这个不能删
│  其他文件 : hugo生成的网页文件
└─asteria_source : 源文件
    │  README.md
    │  
    ├─hugo_bin
    │      hugo.exe
    │      build.ps1 : windows下的hugo build脚本
    │      
    └─source : hugo源文件
        │  config.toml : hugo模板配置文件
        ├─content
        │  └─posts : 文章
        │
        └─themes : hugo主题模板目录  
            └─LoveIt : LoveIt主题模板
```

## hugo

在hugo_bin目录下预置了一个兼容当前主题的hugo.exe，版本v0.108.0

## hugo命令

查看版本：`hugo version`

生成网站：`hugo`

生成网站（无视draft=false）：`hugo -D`

本地调试：`hugo server`

新建文章：`hugo new posts/xxx.md`

## hugo module

hugo module可以用类似go module的方式引入theme，而不用把theme源文件拷贝到themes目录下，hugo module实际上就是用go module实现的

1. 将本项目初始化为hugo module
```bash
hugo mod init github.com/openjz/asteria/tree/main/asteria_source
```

2. 在config.toml中添加依赖module

需要在module的顶层设置中加上proxy参数，hugo module虽然用的是go module，但是必须给hugo单独配置proxy

```toml
[module]
proxy = 'https://goproxy.cn,direct'
[[module.imports]]
path = 'github.com/alex-shpak/hugo-book'
```

3. hugo mod get -u，更新所有依赖

## mkdocs

[https://github.com/squidfunk/mkdocs-material](https://github.com/squidfunk/mkdocs-material)

### 用法

- 安装mkdocs: 
    ```bash
    pip install mkdocs-material # theme，https://github.com/squidfunk/mkdocs-material
    pip install pymdown-extensions # math support
    ```
- 新建项目: `mkdocs new [目录名]`
- 启动服务: `mkdocs serve`
- 构建项目: `mkdocs build`
- 打印帮助信息: `mkdocs -h`