+++
title = "数据库事务"
date = 2022-04-20T11:57:47+08:00

tags = ["数据库","面试","后端"]
categories = ["编程"]
draft = false
+++

事务（transaction）的目的是要保证一连串数据操作的原子性，并能够支持操作回滚

## 事务的并发问题

1. 脏读：当前事务可以读取到其他事务未提交的数据
2. 不可重复读：当前事务前后两次使用相同的查询语句查到了不同的数据，原因是在事务执行过程中，有其他事务对这批数据做了**增删改**操作。**如果当前事务的两次读操作分别发生在其他事务开始前和提交后，读到的数据不一致，这就不算脏读，属于不可重复读问题**。
3. 幻读：事务进行读操作发现数据不存在，试图插入数据，但是插入失败，或者事务发现数据存在，试图更新数据，但更新失败，原因是事务读数据后，有其他事务对数据做了**增删**操作。**即使数据库能够保证不发生脏读和不可重复读,仍有可能发生幻读，现象是每次读数据结果都是不存在，但就是不能插入数据，或者是每次读数据结果都是存在，但就是更新不了。**