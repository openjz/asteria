# c++ STL使用技巧


## 参考

- 《C++ Primer 第5版》

## 1. 容器类型

- 顺序容器
    - 连续内存
        - vector
        - deque：双端队列
        - array：固定大小
        - string
    - 链表
        - list：双向链表
        - forward_list：单向链表
    - 顺序容器适配器
        - stack
        - queue
        - priority_queue：堆

## 2. 和容器大小有关的操作

- 大小
    - `empty`
    - `size`
    - `max_size`：返回该类型容器能容纳的最大元素数量
    - `resize`：改变容器大小
- 容量
    - `capacity`：返回容器的容量，即不重新分配内存的情况下，容器最多能保存的元素
    - `reserve`：不改变容器大小，改变容器的容量（只能扩大，不能缩小）
    - `shrink_to_fit`：将容量缩小到和大小一致

## 3. 内存操作

- assign：内存拷贝
- swap：内存交换

## 4. 添加和删除元素会导致容器迭代器失效

常见面试排错题

如果在遍历容器的过程中insert和earse，需要在操作完后更新迭代器，保证迭代器的有效性

## 5. vector对象是如何增长的

vector预先分配的容量（capacity）会比size大一些，当capacity不足时，会发生扩容

## 6. 函数适配器bind

在下面这个例子中，g是一个可调用对象，f是被适配的函数

_1和_2代表g只有两个参数，_1对应g的第一个参数，_2对应g的第二个参数

a,b,_2,c,_1分别对应函数f的第一、二、三、四、五个参数

即，调用 `g(_1,_2)` 会转换为 `f(a, b, _2, c, _1)`

```cpp
auto g = bind(f, a, b, _2, c, _1);
```

名字 `_n` 定义在 `std::placeholders` 中，例如 `std::placeholders::_1`

## 7. 获取数组的迭代器

可以通过`std::begin()`, `std::end()`,`std::rbegin()`, `std::rend()`等操作获取数组的迭代器，获取到的实际上就是指向数组元素的指针

容器的迭代器也能用这几个函数获取

## 8. 几种特殊迭代器

### 插入迭代器

一种迭代器适配器，绑定到容器，用来向容器插入元素
- `back_inserter`：使用`push_back`
- `front_inserter`：使用`push_front`
- `inserter`：使用`insert`

对于插入迭代器，`*it`,`it++`,`++it`这些操作虽然存在，但是什么都不会做，直接返回`it`

例子：
```cpp
std::vector<int> va = {5,6,7};
auto it = std::inserter(va,va.begin()+1);
*it = 2;
*it = 3;
//结果：5，2，3，6，7

std::vector<int> va;
auto it = std::back_inserter(va);
*it = 2;
*it = 3;
//结果：2，3

std::vector<int> va = {5,6,7};
std::vector<int> vb;
auto itb = std::back_inserter(vb);
std::copy(va.cbegin(), va.cend(), itb);
//结果：vb = 5,6,7
```

### 流迭代器

绑定到输入输出流上，用来遍历io流

- `istream_iterator<T>`：使用`T`的`>>`操作符读取流
- `ostream_iterator<T>`：使用`T`的`<<`操作符读取流  
    和插入迭代器类似，`*it`,`it++`,`++it`这些操作虽然存在，但是什么都不会做，直接返回`it`

`istream_iterators`使用例子

```cpp
//例一
std::istream_iterator<int> in_iter(std::cin);
std::istream_iterator<int> eof;
while (in_iter != eof)
{
    std::cout << *in_iter << std::endl;
    in_iter++;
}

//例二
std::istream_iterator<int> in_iter(std::cin);
std::istream_iterator<int> eof;
std::vector<int> va(in_iter, eof);
```

两种字符串split写法

```cpp
template<typename T>
int StringSplitBySpace2(const char* str, std::vector<T>& parts)
{
    parts.resize(0);
    std::stringstream ss(str);
    std::istream_iterator<T> in_iter(ss);
    std::istream_iterator<T> eof;
    while (in_iter != eof)
    {
        parts.push_back(*in_iter++);
    }
    return parts.size();
}

template<typename T>
std::vector<T> StringSplitBySpace2(const char* str)
{
    std::stringstream ss(str);
    std::istream_iterator<T> in_iter(ss);
    std::istream_iterator<T> eof;
    return std::move(std::vector<T>(in_iter, eof));
}
```

`ostream_iterators`使用例子

```cpp
//例一
//参数"\n"代表为每个输出的值后面拼接一个换行符
std::ostream_iterator<int> osIt(std::cout, "\n");
*osIt = 1;
*osIt = 2;

//例二
std::ostream_iterator<int> osIt(std::cout, "\n");
std::vector<int> va{ 1,2,3 };
std::copy(va.begin(), va.end(), osIt);
```
### 反向迭代器

用来倒序遍历

```cpp
std::vector<int>::reverse_iterator it = va.rbegin();
```

### 移动迭代器

移动，而不是拷贝元素

使用`make_move_iterator`讲一个普通迭代器转换为移动迭代器，例如

```cpp
std::vector<int> va{ 1,2,3 };
std::make_move_iterator(va.begin());
```

对移动迭代器解引用会得到他的右值引用

`std::uninitialized_copy`可以将一系列对象拷贝到未初始化的内存上去，如果把移动迭代器作用于`std::uninitialized_copy`，则通过移动操作构造对象

## 9. 五类迭代器

算法要求的迭代器分为5类，每个算法都会要求具体的迭代器类型。

* **输入迭代器**：只读，不写；单遍扫描，只能递增。  
例如，`istream_iterator`是一种输入迭代器。
* **输出迭代器**：只写，不读；单遍扫描，只能递增。  
例如：`ostream_iterator`和 插入迭代器都是输出迭代器。
* **前向迭代器**：可读写，多遍扫描，只能递增。  
`forward_list`上的迭代器是前向迭代器。
* **双向迭代器**：可读写，多遍扫描，可递增递减。  
除了`forward_list`外，其他标准库容器都提供双向迭代器。
* **随机访问迭代器**：可读写，多遍扫描，支持全部迭代器运算。  
`array`、`deque`、`string`、`vector`的迭代器都是随机访问迭代器。  
注意：只有顺序容器才有随机访问迭代器，只有顺序容器才能用下标访问元素。顺序容器本身和顺序容器的迭代器都有下标运算符`"[]"`。（见书中第310页和第367页）
