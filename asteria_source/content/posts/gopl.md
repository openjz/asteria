+++
title = "golang入门笔记"
date = 2022-04-26T11:18:48+08:00
lastmod = 2022-04-26T11:18:48+08:00
tags = []
categories = []
imgs = []
cover = ""  # image show on top
readingTime = true  # show reading time after article date
toc = true
comments = false
justify = false  # text-align: justify;
single = false  # display as a single page, hide navigation on bottom, like as about page.
license = ""  # CC License
draft = false
+++

# golang入门笔记

参考《Go程序设计语言》

## 一、程序结构

1. go程序使用驼峰式命名风格
2. 零值，变量的初始值，数字是0，字符串是""，布尔值是false，接口（interface）和引用类型（slice、指针、map、通道、函数）是nil，数组和结构体的零值是其所有元素或成员的零值
3. 短变量声明，`a,b := f()`，a和b中至少有一个得是新变量，不能全是已经声明的变量
4. 指针，函数返回局部变量的地址是安全的（见 6.变量的生命周期）
5. new函数，new函数创建一个新值并返回其地址
6. 变量的生命周期通过其是否可达确定（变量可以在其初次声明的作用域之外存活），编译器根据变量生命周期确定变量在栈上还是堆上分配，而不是根据声明变量的时候使用的是var还是new
7. 多重赋值，例如`a,b := 1,"xxx`或`x,y = y,x`，后者用来交换变量的值
8. 类型转换，`var a T = T(b)`，每个类型都会提供`T(x)`将x的值转换为T（前提是允许这种转换）
9. 导出的标识符才能在包外被访问到，导出的标识符以大写字母开头
10. 包初始化，从初始化变量开始，优先按照依赖顺序初始化变量，然后按照声明顺序初始化变量
11. init函数，可以有任意个，在程序启动时按照声明顺序自动执行