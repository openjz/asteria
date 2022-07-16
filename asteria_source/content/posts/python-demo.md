---
title: "python demo"
date: 2022-07-08T12:23:09+08:00
# bookComments: false
# bookSearchExclude: false
tags : 
- "python"
categories : 
- "计算机"
---

## 创建数组

```python
# 1维数组
array1d = [0]*(len(s))
array1d_2 = [0 for i in range(len(s))]
# 2维数组
array2d = [[0]*(len(s)) for i in range(len(s))]
```

## 栈和队列

可以使用collections模块中的deque作为栈和队列，性能比基础的list要好，参考[python3官方文档 collections—Container datatypes](https://docs.python.org/3/library/collections.html#collections.deque)

```python
#栈
d = deque() #初始化
d.append(c) #入栈
len(d)  #获取栈中元素个数
d[len(d)-1] #检查栈顶
d.pop() #出栈
```
