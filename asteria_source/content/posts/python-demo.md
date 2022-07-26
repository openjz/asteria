---
title: "Python Demo"
date: 2022-07-08T12:23:09+08:00
# bookComments: false
# bookSearchExclude: false
tags : 
- "python"
categories : 
- "编程"
---

## for循环

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

## 创建数组

```python
# 1维数组
array1d = [0]*(len(s))
array1d_2 = [0 for i in range(len(s))]
# 2维数组
array2d = [[0]*(len(s)) for i in range(len(s))]
```

## 栈和队列-deque

可以使用标准库collections模块中的deque作为栈和队列，性能比基础的list要好，参考[python3官方文档 collections—Container datatypes](https://docs.python.org/3/library/collections.html#collections.deque)

```python
#栈
d = deque() #初始化
d.append(c) #入栈
len(d)  #获取栈中元素个数
d[len(d)-1] #检查栈顶
d.pop() #出栈
```

## 堆-heapq

python标准库heapq模块实现了一个堆，用法如下：

```python
data = [2,1,5]  #准备数据集
heapq.heapify(data) # 建堆
heapq.heappush(data,2) # push
heapq.heappop(data) # pop
len(data) # 获取堆大小
data[0] #检查堆顶元素
            
# 以下两个函数是基于堆的通用功能函数，数据集不必是已排序的
heapq.nlargest(n, iterable, key=None)和heapq.nsmallest(n, iterable, key=None)

# 归并有序序列，返回一个迭代器
heapq.merge(*iterables, key=None, reverse=False)
```

注意：

1. heapq只实现了最小堆，如果想使用最大堆，可以通过在push和pop时对元素取反来实现
2. 如果数据集中是自定义对象，可以通过给类定义比较方法来使用heapq，例如

```python
@total_ordering #用了这个注解以后，只需要定义两个运算符
class HeapEle:
    def __init__(self, val=0, next=None):
        self.val = val
        self.next = next
    def __eq__(self,other):
        return self.val == other.val
    def __lt__(self,other):
        return self.val < other.val
```

heapq.merge函数例子：

```python
import heapq

# 1.简单例子
l0 = heapq.merge([1,3,5,7],[2,4,6,8])
# 遍历迭代器-方法1，使用常规for语句进行遍历
for v in l0:
    print(v)
# 遍历迭代器-方法2，使用next()函数
while True:
    try:
        print (next(l0))
    except StopIteration:
        break
# 将迭代器转为list
list(l0)

# 2. 对自定义类进行归并
class ListNode:
    def __init__(self, val=0, next=None):
        self.val = val
        self.next = next

l1 = [ListNode(0,None),ListNode(2,None),ListNode(4,None)]
l2 = [ListNode(1,None),ListNode(3,None),ListNode(5,None)]

l3 = heapq.merge(l1,l2,key=lambda a:a.val)
for v in l3:
    print(v.val)
```

## list操作

### 翻转

```python
n = [1,2,3]
n.reverse() # 原地翻转
reversed(n) # 返回一个翻转后的迭代器，原序列不变
```

## 二分查找-bisect

只能在正序序列上二分查找

```python
bisect.bisect_left(a, x, lo=0, hi=len(a), *, key=None)

bisect.bisect_right(a, x, lo=0, hi=len(a), *, key=None)
bisect.bisect(a, x, lo=0, hi=len(a), *, key=None)
```

上面这三个函数都返回一个插入位置

bisect_left 返回的是已存在元素x左侧位置，插入点 i 将 a 分为两半，a[lo:i] 全部小于 x，a[i:hi] 全部大于等于 x。

bisect_right 和 bisect返回已存在元素 x 右侧位置，a[lo:i] 全部小于等于 x, a[i:hi] 全部大于 x。