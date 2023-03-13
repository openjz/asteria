# mysql入门笔记


参考《mysql必知必会》

## 一、基本概念

模式（schema）：这个概念比较模糊，一个比较常见的定义是，schema是指数据库对象的集合，其中包括表、视图、存储过程、索引等。schema通常是指数据库或表的布局和结构等信息。

主键（primary key）：主键定义在表的一列上，用来唯一地标识每一行，因此主键的值不能重复，每一行对应的主键值都是唯一的。

>主键有几个使用习惯，（1）不更新主键，（2）一般把主键定义在自增id列上

外键（foreign key）：外键是表中的一个字段，对应另一个表的主键。

>可伸缩性（scale），一个设计良好的数据库能够良好应对数据量的增加，我们把这种情况称为数据库的可伸缩性好，可伸缩性离不开外键的使用。

>检索性能可能会受多种因素影响：检索操作（子查询、联表查询...），数据量，是否有索引或键

子句（clause）：SQL由子句构成，例如`from`、`order by`等。

完全限定列名：`表名.列名`，`video.md5`

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
- is [not] null，检索字段值为null或不为null的数据
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

## 六、计算字段（临时生成的字段）

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
- 数值处理
    - cos, sin, tan, pi
    - abs, exp, sqrt,
    - mod, rand

## 八、汇总数据（数据聚合，aggregate）

上面的介绍的数据处理函数是对单条数据的处理。数据聚合是要对表中多条数据进行汇总，比如计算行数，求均值等。

聚集函数运行在整个表上，返回单个值，常用聚集函数有：

- avg: 计算均值。`select avg(price) as avg_price where id=1003`
- count: 计数。`count(*)`计算行数，无论行中是否有null值。`count(column)`对特定列有值的行计数，略过null值。
- max、min: 返回指定列中的最大值和最小值 
- sum: 返回指定列的和。也可以对计算字段求和，例如`select sum(price*quantity) as total_price`

**字段前面可以带参数**，`select avg(PARAM field) as tmp`，参数要放在PARAM的位置，默认参数是`all`，另外一种参数是`distinct`，它们的区别是，`all`对全部行进行聚集，`distinct`对该列的每个取值只统计一次。

可以在单条语句中执行多个聚集计算，`select avg(f1) as tmp1, min(f2) as tmp2...`

### 1.对数据分组（group by）

假设有表staff

```text
id  name    dept    salary  edlevel hiredate
1   张三     rd      2000    3       2009-10-11
2   李四     rd      2500    3       2009-10-01
3   王五     qa      2600    5       2010-10-02
4   王六     qa      2300    4       2010-10-03
5   马七     qa      2100    4       2010-10-06
6   赵八     pm      3000    5       2010-10-05
7   钱九     pm      3100    7       2010-10-07
8   孙十     pm      3500    7       2010-10-06
```

执行以下sql

```sql
SELECT dept, edlevel, MAX( salary ) AS maxsal
FROM staff
WHERE hiredate > '2010-01-01'
ORDER BY dept, edlevel;
```

结果

```
dept edlevel maxsal
qa 4 2300
qa 5 2600
pm 5 3000
pm 7 3500
```

`group by`用于对数据进行分组，如果检索字段中有聚集函数的话，`group by`按分组聚集，而不是按整个结果集聚集。规则如下：

- `group by`必须位于`where`和`order by`之间
- `group by`后面可以跟多个列或表达式（但不能是聚集函数），如果是表达式，`select`后面必须也有这个表达式
- 除了聚集函数以外，`select`后面跟着的每一列都得写到`group by`后面
- `group by`后面跟的每个列必须都写到`select`后面
- 如果`select`语句中同时有字段和聚集函数，则sql中必须使用`group by`

`group by`按分组列的笛卡尔积展示结果，也意味着能够利用`group by`对分组列去重，这也是为什么`select`中的列`group by`都要有，因为如果`select`中有一列`group by`中没有，比如`select a,b from xxx group by a;`，当a的同一个取值对应多个b的取值时，`group by`就没办法按笛卡尔积展示分组结果了（不可能在同一行同时展示b的多个取值）

### 2.过滤分组（having）

having类似where，where对行进行过滤，having对分组进行过滤，例如：

```sql
select cust_id, count(*) as orders
from products
group by cust_id
having count(*) >= 2;
```

having和where的区别是，where在分组前过滤，having在分组后过滤

## 九、select子句顺序

select - from - where - group by - having - order by - limit

## 十、子查询（select嵌套）

涉及到多个表时可能会用到子查询。子查询嵌套太多会导致性能问题。

例一：利用子查询进行过滤

```sql
select cust_id from orders 
where order_num in (
    select order_num from orderitems where prod_id = "TNT2"
);
```

应该保证where中的列和子查询中select的列保持一致

例二：将子查询作为字段

```sql
select cust_name ,
    (select count(*) from orders where orders.cust_id = customers.cust_id) as orders
from customers;
```

该子查询对从customers表中检索出的每行一次（即，先检索customers表，对检索出的每一行，执行子查询）。这种子查询被称为**相关子查询（correlated subquery）**

## 十一、联结表（联表，join）

>数据库设计中经常需要配合使用多张互相关联的业务表，目的是降低冗余和解耦
>
>联结是sql执行过程中建立的，表定义中并不存在联结

例一，使用where子句建立联结，如果没有联结条件，会返回笛卡尔积

```sql
select vend_name, prod_name, prod_price
from vendors, products
where vendors.vend_id = products.vend_id
order by vend_name, prod_name;
```

例一这种联结也被称为**内部联结**，也可以写为

```sql
select vend_name, prod_name, prod_price
from vendors INNER JOIN products
ON vendors.vend_id = products.vend_id;
```

例二，联结多个表

```sql
select vend_name, prod_name, prod_price, quantity
from orderitems, vendors, products
where vendors.vend_id = products.vend_id
    and orderitems.prod_id = products.prod_id
    and order_num = 20005;
```

### 1.内部联结（等值联结）

见上例

### 2.自联结

表别名：`as`关键字同样可以给表指定别名

例子：根据某产品id找出生产该产品的厂家生产的其他产品

```sql
select p1.prod_id, p1.prod_name
from products as p1, products as p2
where p1.vend_id = p2.vend_id
    and p2.prod_id = 'DTNTR';
```

### 3.自然联结

自然联结是指检索结果中没有重复的列(不是行)，可以使用通配符让系统自动去掉重复的列，一般是对某个表使用通配符，然后手动指定其他表中的列，例如：

```sql
select c.*, o.order_num, o.order_date
    oi.prod_id, oi.quantity, oi.item_price
from customers as c, orders as o, orderitems as oi
where c.cust_id = o.cust_id
    and oi.order_num = o.order_num
    and prod_id = 'FB';
```

### 4.外部联结

与内部联结不同，外部联结的执行结果中包含没有产生关联的行。例如，下面这个sql想按客户id（cust_id）建立关联，检索出客户和订单的关系，并要求结果中包含没有订单的客户。

```sql
select customers.cust_id, orders.order_num
from customers LEFT OUTER JOIN orders
ON customers.cust_id = orders.cust_id
```

关键字：
- `left outer join`：`left`要求结果中包含`outer join`左边表中的无关联行
- `right outer join`：结果中包含右边表中的无关联行

### 5.联结中带聚集函数

```sql
select customers.cust_name, customers.cust_id,
    count(orders.order_num) as num_ord
from customers left outer join orders
on customers.cust_id = orders.cust_id
group by customers.cust_id;
```

以上sql的作用是：获得所有客户的订单数，包括哪些没有订单的客户

## 十二、组合查询（union）

同时执行多个select，并将结果作为单个查询结果集返回。例如

```sql
select vend_id, prod_id, prod_price
from products
where prod_id <=5
union
select vend_id, prod_id, prod_price
from products
where vend_id in (1001,1002);
```

union的规则：

- union中的每个查询必须包含相同的列、表达式或聚集函数
- union会自动对返回的行去重，如果不想去重，要使用`union all`
- 只能有一个order by，必须放在最后一个select之后。

## 十三、全文本搜索

>mysql通过建立全文索引（倒排索引）来支持全文搜索。

建表时指定全文检索：

```sql
create table demo
{
    ...
    some_words text null,
    ...
    fulltext(some_words)
}   engine=MyISAM;
```

使用函数 match 和 against 进行全文搜索，match 指定要匹配的列，against 指定要使用的搜索表达式。例如

```sql
select node_text
from productnodes
where match(node_text) against('rabbit');
```

搜索不区分大小写。搜索结果默认以匹配接近程度进行排序。

match和against的计算结果实际上是一个匹配等级值，表示匹配的接近程度，例如

```sql
select node_text, match(node_text) against('rabbit') as matchrank
from productnodes;
```

**查询扩展**：放宽搜索范围，搜索结果中可能不包含指定的检索词，例如`select node_text, match(node_text) against('rabbit' with query expansion) as matchrank from productnodes;`

**布尔文本搜索**：`against('xxx' in boolean mode)`，性能较差，可以不需要fulltext索引。可以指定要匹配的词，要排斥的词，匹配优先级等。

## 十四、数据的插入、删除和更新（增删改）

### 1.插入

简单写法：`insert into customers values(null,'xxx','xxx',null);`，各个列必须以它们在表定义中的顺序填充

复杂写法：指定要插入的列

```sql
insert into customers(name, address, city) values('123','asd', null);
```

可以给多组value，例如，`values('xxx','xxx'),('222',NULL);`

插入检索出的数据，例如，`insert into table1(xx,xx,xx) select xx,xx,xx from table2 where...;`

### 2.更新

>更新操作一定要带上条件，否则就会更新全表

```sql
update tablename 
set cust_email='xxxx',
    cust_name = 'sss'
where cust_id = 2345;
```

可以在update语句中使用子查询

`ignore`关键字：update默认的逻辑是只要有一行数据更新失败就失败，`ignore`可以跳过更新失败的行，继续更新其他行

### 3.删除

>删除操作一定要带上条件，否则就会删除表中的所有数据

`delete from customers where cust_id = 1234;`

删除全表：`truncate table tablename`，实际上是直接把表删除后再新建一个表

## 十五、创建和操作表

### 1.创建表

查看数据库和表的创建语句：`show create database/table xxx;`

create语句：

```sql
CREATE TABLE if not exists `video` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `file` varchar(64) NOT NULL DEFAULT '' COMMENT '文件名',
  `maudit_status` tinyint(4) unsigned NOT NULL DEFAULT '0' COMMENT 'status of machine audit',
  `source_url` varchar(510) NOT NULL DEFAULT '' COMMENT '原始url',
  `create_time` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '创建时间',
  `maudit_result` varchar(4096) NOT NULL DEFAULT '' COMMENT 'result of machine audit',
  PRIMARY KEY (`id`),
  UNIQUE KEY `object_name` (`file`),
  KEY `idx_src_create_time` (`src_create_time`),
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COMMENT='视频表';
```

规则：

1. 主键可以是多个列，例如，`PRIMARY KEY (`id1`,`id2`)`
2. 每个表只允许一列`auto_increment`，并且该列必须能被索引（一般是把这列设置为主键）
3. 不允许使用函数作为默认值，只能用常量
4. **外键不允许跨引擎** 

### 2.修改表

```sql
alter table xxx
add phone_num char(20); --增加列

alter table xxx
drop column phone_num; --删除列

alter table xxx
add constraint xxx_fk foreign key (vend_id) references vendors (id); --添加一个外键约束（在vend_id这一列上，添加一个名为xxx_fk的外键约束）

ALTER TABLE students
DROP FOREIGN KEY fk_class_id; -- 删除外键约束

drop table xxx; --删除表

rename table xxx to xxx2; --重命名表
```

## 十六、视图

视图是虚拟的表，它只是把查询封装了一下，里面并不包含数据，因此使用视图时要注意性能问题。可以利用视图简化复杂的联结查询

视图操作：

- create view <视图名> AS <SELECT语句>，例如`create view as select * form students;`
- drop view, create or replace view
- show create view xxx, 查看创建视图的语句
- 在视图中查询数据和在表中查询数据一样都用select语句，只是把表名换成了视图名

## 十七、存储过程

存储过程把一系列操作封装在一起。**可以在存储过程中加入事务**。

```sql
create procedure xxx()
begin
    select xxx from xxx;
end;
```

**如果是在mysql命令行客户端使用该语句，要对命令结束符做临时修改**，例如:

```sql
delimiter //
create procedure xxx()
begin
    select xxx from xxx;
end//
delimiter ;
```

执行存储过程：`call xxx();`

删除存储过程：`drop procedure (if exists) xxx;`

查看存储过程创建语句：`show create procedure xxx;`

查看存储过程信息：`show procedure status (like 'procedure_name');`

### 1.参数和变量

所有mysql变量都必须以`@`开头

定义一个用户变量：`set @num=1;`或`set @num:=1;`

定义存储过程时带参数：

```sql
-- in/out/inout分别对应输入变量、输出变量和输入输出变量
create procedure xxx(
    in value1 int,
    out value2 decimal(8,2),
    inout value3 boolean
) comment 'This is a comment'
begin
    select xxx into value2 from ... ;
end;
```

执行存储过程：

```sql
call xxx(20, @v2, @v3);
```

获取存储过程的输出：

```sql
select @v2, @v3;
```

可以在存储过程中写逻辑：

```sql
declare xxx int default 6;
declare xxx2 boolean default false;

if xxx2 then
    ...
end if;
```

### 2.游标

mysql游标只能用于存储过程和函数。游标可以用来从select返回的结果集中一行一行地取数据。

### 3.触发器

触发器可以让mysql在某个表发生更改时自动执行某个动作。触发器可以响应delete、insert或update语句。

## 十八、事务

一些概念：
- 事务（transaction）：是指一组sql语句
- 回滚（rollback）：只能在事务内部使用
- 提交（commit）：做最终的写入操作
- 保留点（savepoint）：事务处理中设置的临时占位符，可以回滚到保留点，而不是整个事务

```sql
start transaction;
...
rollback;
...
savepoint xx;
...
rollback to xx;
...
commit;
```

## 十九、用户及权限管理

数据库mysql.user表中有所有的用户信息

```sql
create user xxx identified by 'password';
rename user xxx to xxx2;
drop user xxx;
show grants for xxx; --显示用户权限
grant select on db.* to xxx; --grant授予权限
revoke select on db.* to xxx; --revoke撤销权限 
set password for xxx = Password('123456'); --改密码
```

## 二十、数据库维护

1. 数据备份
    - 命令行工具：mysqldump、mysqlhotcopy
    - 命令：`backup table`、`select into outfile`、`restore table`、`flush tables`
2. 检查状态
    - `analyse table`、`check table`
3. 日志
    - 错误日志：data/hostname.err，命令行参数
    - 查询日志：data/hostname.log，记录所有mysql活动
    - 二进制日志：data/hostname-bin，记录数据更新语句
    - 慢查询日志：data/hostname-slow.log，记录执行缓慢的查询

## 二十一、改善性能

- 使用explain语句让mysql解释它如何执行某个select语句
- join、union和子查询的性能不一定谁高谁低，需要具体问题具体分析
- 不要用`select *`
- 使用多条select语句和union来代替or条件
- 索引提升查询性能，但是会降低插入、删除和更新的性能
- like很慢
- ...


