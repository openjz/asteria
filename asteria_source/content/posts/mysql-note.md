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

## 六、计算字段（字段计算）

计算字段在select语句中创建（计算字段是指经过计算后得到的临时字段）

### 1. 拼接字段 concat()

很多dbms使用+或||拼接字段，mysql必须使用concat()函数

例如，`select concat(name, '(', status, ')') from table_user order by name limit 3;` 将字段name和status拼接成name(status)的形式，会产生以下输出：

```
+--------------------------------+
| concat(name, '(', status, ')') |
+--------------------------------+
| 000007e(2)    |
| 00000b0(4)    |
| 0000253(2)    |
+--------------------------------+
```

可以使用`ltrim()`、`rtrim()`、`trim()`删除数据左侧、右侧和两侧的空白符

**可以使用`as`关键字为新字段赋予别名**，例如`select concat(name, '(', status, ')') as new_name ...`

### 2. 算术计算

包括加减乘除和圆括号

`select field1*field2 as new_name from ...`

## 七、数据处理

使用函数进行数据处理

- 文本处理函数：
    - 去除空白符：trim、ltrim、rtrim
    - 大小写转换：upper、lower
    - 字符串长度：length
    - 定位子串起始下标：locate
    - 查找子串：substring
    - 从左边或右边起获取子字符串：left、right
    - 获取字符串的发音：soundex
- 日期和时间处理函数：
    - 时间和日期计算（加减天数，或加减时分秒）：
        - adddate, date_add, subdate, date_sub
        - addtime, subtime
        - datediff
    - 格式化：date_format(date,format)，参数date是合法的日期时间，format是日期/时间的输出格式, 例如：
        ```sql
        mysql> SELECT DATE_FORMAT('1997-10-04 22:23:00', '%H %k %I %r %T %S %w');
        '22 22 10 10:23:00 PM 22:23:00 00 6'
        ```
    - 获得当前日期/时间：now, curdate, curtime
    - 返回一个日期时间的特定部分：date, day, dayofweek, hour, minute, month, second, time, year 





