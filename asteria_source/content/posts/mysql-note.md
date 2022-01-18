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

子句（clause）：SQL由子句构成，例如`from`、`order by`等。

## 二、mysql工具

mysql安装包中自带一个命令行工具`mysql`，这是一个运行在命令行的mysql客户端。

- 命令用`;`或`\g`结束，`\G`可以使横向表格纵向输出
- 输入`help`或`\h`查看帮助
- 输入quit或exit退出

mysql默认端口是3306

## 三、使用mysql

一些关于数据库和表的命令：

- 选择数据库：`use xxx;`
- 查看（`show`）
    - 所有数据库：`show databases;`
    - 所有表：`show tables;`
    - 表的列：`show columns from xxx;`
        - 和`desc xxx;`作用相同
    - 服务器状态：`show status;`
    - 权限：`show grants;`
    - 数据库和表的创建语句：`show create database/table xxx;`
    - 服务器错误和告警：`show errors/warnings;`
    - `help show`

## 四、检索（select）

### 简单select

```sql
select field1 from table_hello; 
select field1,field2,field3 from table_hello; 
select * from table_hello; 
```

字段前面可以加上表名，例如

```sql
select table_hello.field1 from table_hello;
```

### distinct

```sql
select distinct field from table_hello;
select distinct field1,field2 from table_hello;
```
功能：

- 只检索单个字段时，列出字段所有可能的取值
- 检索多个字段时，列出两个字段取值的笛卡尔积

### limit

返回前n行
```sql
select field from table_hello limit n;
```

返回m行，从第n行开始（行号从0开始）
```sql
select field from table_hello limit n,m;
-- 或
select field from table_hello limit m offset n;
```

### 排序（order by子句）

按单个列或多个列排序

```sql
select field1 from table_hello order by field2;
select field1 from table_hello order by field2 limit 5;
select field1 from table_hello order by field1,field2;
```

- `limit`要放在`order by`后面（先排序、再选行）
- 按多个列排序时，先按前面的列排，值相同时，再按后面的列排
- 同时使用`order by`和`limit`时，`order by`在前，`limit`在后

排序方向（升序/降序）

- 升序（`asc`）：默认是升序
- 降序（`desc`）：`order by field2 desc`

`desc`只对一个列有效，对多个列排序时，必须在想降序排的列后面都加上`desc`，例如：

```sql
select field1 from table_hello order by field1 desc,field2;
```

## 五、过滤条件（where）

操作符：

- `=`、`!=`(也可以用`<>`表示不等于)
- <、<=、>、>=
- between，检索字段值位于一个范围内的数据
- is null，检查字段值为null的数据
- and、or，and优先级高于or，可以用括号调整优先级
- in，后面跟着一个值列表，例如(1,3,5)
- not，对后面的所有条件取反
- like，利用通配符匹配
- regexp，利用正则表达式，匹配

between例子：

```sql
-- 查找值为2~4的数据
select * from table_video where maudit_status between 2 and 4;
-- 或
select * from table_video where maudit_time between "2022-01-02 00:00:00" and "2022-01-03 00:00:00";
```

not例子：

```sql
select * from table_video where maudit_status not in (2,3);
-- 或
select * from table_video where maudit_time between "2022-01-02 00:00:00" and "2022-01-03 00:00:00";
```

### 通配符

通过`like`关键字使用通配符匹配

`%`，匹配任意字符出现任意次数（包括0次）

`_`，下划线，匹配一个任意字符（出现一次，不多不少）

### 正则表达式

mysql仅支持正则表达式的一个很小的子集

正则表达式是本身是字符串，因此使用转义字符时要先转义一次`\`，所以最终使用转义字符的时候，总是要写`\\`

mysql使用`[[:<:]]`和``[[:>:]]``匹配单词的开头和结尾，类似`\b`
