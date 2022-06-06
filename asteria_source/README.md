# asteria

This is my web site.

## hugo命令

生成网站：`hugo`

生成网站（无视draft=false）：`hugo -D`

本地调试：`hugo server`

新建文章：`hugo new posts/xxx.md`

## hugo module

hugo module是对go module的封装

1. 将本项目初始化为hugo module
```bash
hugo mod init github.com/openjz/asteria/tree/main/asteria_source
```

2. 在config.toml中添加依赖module

```toml
[module]
[[module.imports]]
path = 'github.com/alex-shpak/hugo-book'
```

3. hugo mod get -u 

