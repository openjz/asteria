# asteria

This is my web site.

## hugo命令

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
  # uncomment line below for temporary local development of module
  # replacements = "github.com/google/docsy -> ../../docsy"
  proxy = 'https://goproxy.cn,direct'
  [module.hugoVersion]
    extended = true
    min = "0.75.0"
  [[module.imports]]
    path = "github.com/google/docsy"
    disable = false
  [[module.imports]]
    path = "github.com/google/docsy/dependencies"
    disable = false  
```  

3. hugo mod get -u，下载并更新所有依赖

