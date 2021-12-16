+++
title = "mysql入门笔记"
date = 2021-11-14T10:09:46+08:00
lastmod = 2021-11-14T10:09:46+08:00
tags = ["mysql"]
categories = ["笔记"]
draft = false
+++

# mysql入门笔记

参考《mysql必知必会》

## 一、基本概念

模式（schema）：这个概念比较模糊，一个比较常见的定义是，schema是指数据库对象的集合，其中包括表、视图、存储过程、索引等。schema通常是指数据库或表的布局和结构等信息。

主键（primary key）：主键定义在表的一列上，用来唯一地标识每一行，因此主键的值不能重复，每一行对应的主键值都是唯一的。

>主键有几个使用习惯，（1）不更新主键，（2）一般把主键定义在自增id列上

## 二、mysql工具

mysql安装包中自带一个命令行工具`mysql`，这是一个运行在命令行的mysql客户端。

- 命令用`;`或`\g`结束，`\G`可以使横向表格纵向输出
- 输入`help`或`\h`查看帮助
- 输入quit或exit退出

mysql默认端口是3306

## 三、使用mysql

一些关于数据库和表的命令：

- 查看所有数据库：`show databases;`
- 选择数据库：`use xxx;`
- 查看所有表：`show tables;`
- 查看表的列：`show columns from xxx;`
- 查看服务器状态：`show status;`
- 查看权限：`show grants;`
- 查看数据库和表的创建语句：`show create database/table xxx;`
- 查看服务器错误和告警：`show errors/warnings;`
- `help show`