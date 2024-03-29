---
title: "关于IP地址的发展"
date: 2022-07-15T10:45:00+08:00
description : ""
# bookComments: false
# bookSearchExclude: false
tags :
- "网络"
categories : 
- "编程"
---

## IP地址的发展

最开始将IP地址分为ABCDE五类地址，后来为了不浪费IP地址资源提出了划分子网，发明了子网掩码，再后来又（在可变长子网掩码VLSM的基础上）提出了无分类域间路由CIDR（Classless Inter-Domain Routing），提出了变长网络前缀，进一步提高了IP地址利用率

在最初的五类IP编址方法中，IP地址是两级编址，由网络号+主机号构成。划分子网被提出后，IP地址变为了三级编址，即网络号+子网号+主机号。到了CIDR出现以后，就不再使用之前的IP地址分类和划分子网的概念了，而是使用长度可变的网络前缀代替了网络号和子网号，写的时候使用“斜线记法”，即在IP地址后面加一个斜线“/”，然后写上网络前缀所占的位数。

CIDR实际上已经没有子网的概念，但仍然使用掩码这一称呼，IP地址从三级（网络号+子网号+主机号）又变回了两级（网络号+主机号）

## 最初的五类IP地址

一个IPv4地址共四个字节，由网络号和主机号组成。IPv4地址分为A、B、C、D、E五类

**网络号全0**代表本网络，因此，A、B、C类地址分别有一个网络号不能使用（0.0.0.0/8，128.0.0.0/16，192.0.0.0/24）。但是随着后来子网和CIDR的出现，IP地址分类已经没有意义，128.0.0.0/16已经被分配出去了，192.0.0.0/24暂时还保留在IANA手中，以后或许会分配出去，只有0.0.0.0/8这个网络号被0.0.0.0占用，代表未指定地址

此处参考

- [知乎tckidd的回答](https://www.zhihu.com/question/37927675)
- [RFC790-Assigned numbers](https://datatracker.ietf.org/doc/html/rfc790)，RFC790中给出了具体的IP地址划分
- [RFC791-Internet Protocol](https://datatracker.ietf.org/doc/html/rfc791)，RFC791中规定了全0表示本网络
- [RFC3330-Special-Use IPv4 Addresses](https://datatracker.ietf.org/doc/html/rfc3330)，RFC3330声明了128.0.0.0/16和192.0.0.0/24不再保留


**主机号全1**表示本网络中的所有主机，因此主机号全1的IP地址是一个广播地址。主机号全0时这个IP地址就是网络号。

特殊地址：

- 环回地址（loopback），127.0.0.1，等价于localhost和本机ip。（实际上整个127.0.0.0/8网段都是环回地址）
- 地址0.0.0.0代表未指定地址，一般用于默认地址，相当于占位符
- 0.0.0.0/8中除0.0.0.0以外的其他地址用于表示本网络中的特定主机
- 主机号全0
- 主机号全1

- A类网络号占一个字节，由0开头。其中，全0的网络号被0.0.0.0/8占用，全1的网络号被环回地址占用，因此A类网络号范围是1~126。
- B类网络号占两个字节，由10开头（范围是128.0.0.0/16~191.255.0.0/16）
- C类网络号占三个字节，由110开头
- D类IP地址是多播地址，由1110开头
- E类IP地址保留，由11110开头

A、B、C三类地址都各自划分出一块区域作为私有地址

- A类私有地址，10.0.0.0~10.255.255.255
- B类私有地址，172.16.0.0~172.31.255.255
- C类私有地址，192.168.0.0~192.168.255.255

