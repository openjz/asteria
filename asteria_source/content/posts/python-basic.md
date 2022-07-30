---
title: "Python 基础"
date: 2022-07-08T12:23:09+08:00
tags:
  - "python"
categories:
  - "编程"
---

## 格式化输入输出

参考[https://docs.python.org/zh-cn/3/tutorial/inputoutput.html#formatted-string-literals](https://docs.python.org/zh-cn/3/tutorial/inputoutput.html#formatted-string-literals)

```python
print("demo1: {0} {1} {2}".format("hello", 2, 3))
print("demo2: %s %d %d" % ("hello", 2, 3))
```

## for 循环

```python
n = [1,2,3,4]

# 正序
for v in n:
    ...
for i in range(10):
    ...
# 倒序
for v in reversed(n):
    ...
for i in range(10,-1,-1): #从10到0，步长为-1，第三个参数为步长
    ...
```

## 列表推导式

```python
# 创建一个长度为10的数组，每个元素的值为下标的平方
squares = [x**2 for x in range(10)]
```

## 创建数组

```python
# 1维数组
array1d = [0]*(len(s))
array1d_2 = [0 for i in range(len(s))]
# 2维数组
array2d = [[0]*(len(s)) for i in range(len(s))]
array2d = [[0 for i in range(4)] for i in range(len(s))]
# 唯独不能这么写：array2d = [[0]*4]*5，因为*操作对于引用类型来说是传递引用操作，这等于把一维数组的引用复制了5份
```

## list

### 翻转

```python
n = [1,2,3]
n.reverse() # 原地翻转
reversed(n) # 返回一个翻转后的迭代器，原序列不变
```

## 迭代器和生成器

迭代器

```python
n = [1,2,3,4]

# 获取迭代器
it = iter(n)
# 通过迭代器访问数据
while True:
  try:
    print(next(it))
  except StopIteration:
    break
# 遍历迭代器
it = iter(n)
for i in it:
    print(i)
```

生成器是一种特殊的迭代器，作用是一边迭代一边生成数据

```python
# 1. 创建生成器
# （1）生成器表达式（类似列表推导式）
b = (i for i in range(5))
# （2）生成器函数
def gen1():
  yield 1
  yield "hello"
  yield 3
def gen2(n):
  for i in range(n):
    yield i
b = gen1()
c = gen2(4)

# 2. 遍历生成器
while True:
    try:
        print(next(b)) # 0
    except StopIteration:
        break
```

## 拷贝

### 可变类型和不可变类型

python 里的类型分为可变类型和不可变类型两类

常见的基本类型，例如整型、字符串类型、浮点型，这些类型都是不可变类型。不可变类型类似于其他语言中的值类型，如果对象 a 赋值给对象 b，并且要修改 b，python 就会先把内存复制一份再修改，也就是说，修改 a 不会影响 b，是一种 copy-on-write 机制。

可变类型一般是容器类型，例如 list、dict、tuple 等。可变类型类似于其它语言中的引用类型，对象 a 给对象 b 赋值时传递的是引用，修改 b 中的数据会导致同时修改 a 和 b

### 深拷贝和浅拷贝

深拷贝和浅拷贝特指标准库 copy 模块中的 copy 和 deepcopy。

copy 被称为浅拷贝，只拷贝第一层数据，如果第一层某个数据是一个 list，那只会把这个 list 的引用拷贝过来

deepcopy 被称为深拷贝，是一种递归拷贝

### 不同语言中的拷贝和引用

像 python、golang、java 等上层语言对拷贝和引用的处理和 C++不同。

在这些上层语言中，一般都会区分引用类型和值类型，对于值类型，`=`操作符往往执行的是拷贝操作，对于引用类型，`=`操作符往往会执行传递引用操作，引用类型的拷贝往往需要一个专门的操作，例如 python 中是`copy`，java 中是`clone`。

而在 C++中，`=`操作符无论对什么对象都是赋值/拷贝操作，如果想传引用，必须在引用变量初始化的时候对其传递引用，并且要指定被传值的变量是引用类型（利用`&`）。这就导致了，在 C++中，引用变量一旦创建就不能修改引用指向，后续做的所有`=`操作都是对引用对象的拷贝/赋值操作

## lambda 表达式

```python
lambda x: x**2
```
