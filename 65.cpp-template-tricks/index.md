# c++模板使用技巧


## 参考

- 《C++ Primer 第5版》
- 《Effective Modern C++》

## 0. 模板类型推导规则

参考 [62.effective-modern-cpp](/62.effective-modern-cpp/)

## 1. 非类型参数

例如，利用模板推导数组长度

```cpp
template<typename T, std::size_t N>
constexpr std::size_t ArraySize(T(&)[N]) noexcept
{
    return N;
}
```

## 2. 编译错误在实例化期间报告

编译不出错可能是因为没有使用这个模板

模板成员也一样，用到成员的地方才会实例化这个成员

## 3. 模板类型别名

使用using可以为模板类型定义别名

```cpp
template<typename T>
using twin = std::pair<T,T>
```

而typedef只能做到

```cpp
typedef Blob<std::string> StrBlob
```

可以将模板参数的类型通过using声明在模板类内部，这样，如果把这个模板作为参数传递给另外一个模板A，就可以在模板A里获取到传入模板的参数类型，例如，标准库STL容器一般会在模板内部定义一个value_type，表示容器的值类型，然后我们可以在定义其他模板时获取到STL的值类型

```cpp
template <typename Container>
void PrintSTLType(const Container& container)
{
	printf("value_type: %s\n", typeid(Container::value_type).name());
    Container::value_type a;
}
```

## 4. 模板static成员

static成员是实例级别的，即每个模板的实例都有一个独有的static成员

## 5. 控制实例化

如果在多个文件实例化了相同的模板，编译器要在每个文件中都对模板实例化一次，编译开销很大

可以通过显示实例化避免这种开销

```cpp
extern template declaration //实例化声明
template declaration    //实例化定义
```

实例化定义和普通的模板实例化有所不同，实例化定义会把模板所有成员都实例化出来

## 6. 返回类型推导

写法1和2等价，都是按decltype的推导规则推导，写法3是按模板类型推导规则去推导

写法1：

```cpp
template<typename Container, typename Index> 
auto authAndAccess(Container& c, Index i ) -> decltype(c[i])
{
    authenticateUser(); 
    return c[i]; 
} 
```

写法2：使用`decltype(auto) `让auto的推导采用decltype的规则

```cpp
 template<typename Container, typename Index> 
decltype(auto) 
authAndAccess(Container& c, Index i)
{
    authenticateUser(); 
    return c[i]; 
}
```

写法3：

```cpp
 template<typename Container, typename Index> 
auto
authAndAccess(Container& c, Index i)
{
    authenticateUser(); 
    return c[i]; 
}
```

## 7. 类型转换模板

定义在头文件`type_traits`中，属于模板元编程的范畴

- `remove_reference`
- `add_const`
- `add_lvalue_reference`
- `add_rvalue_reference`
- `remove_pointer`
- `add_pointer`
- `make_signed`
- `make_unsigned`
- `remove_extent`: x[n] -> x
- `remove_all_extents`: x[n1][n2] -> x

## 8. 完美转发

例子

```cpp
template<typename T>
void f(F f, T && arg)
{
    f(std::forward<T>(arg));    //将参数arg完美转发给函数f
}
```

为啥需要完美转发？

我们知道，根据模板类型推导过程，当参数类型为`T&& arg`这样的右值引用时，如果传入参数是个左值，T会推导为`Type &`, 函数参数会推导为`Type & arg`，如果传入参数是个右值，T会推导为`Type`, 函数参数会推导为`Type && arg`，这样看起来似乎是够用的，传入参数是左值，参数类型就推导为左值，传入参数是右值，参数类型就推导为右值，但是，如果我们需要在函数内调用一个其他函数，将参数透传给它，就会有问题，因为即使函数参数类型是个右值引用，实际传入的参数在函数内部使用时，仍然会视为左值表达式，如果被调用函数的参数是个右值引用，就会编译失败。

因此，c++引入了`std::forward<T>`配合`T && arg`使用，来保持传入参数的类型，将参数透传给其他函数

## 9. 可变参数模板

```cpp
template<typename T, typename... Args>
void foo(const T& t, const Args&... rest)
```

使用`sizeof`获取可变参数的数量

```cpp
template<typename... T>
void afunc(const T&... args)
{
	std::cout << sizeof...(args) << std::endl;
}
```

可变参数模板用来编写递归函数很方便

```cpp
template<typename T>
std::ostream& Print(std::ostream& os, const T& t)
{
    return os << t;
}

template<typename T, typename... Args>
std::ostream& Print(std::ostream& os, const T& t, const Args&... args)
{
    os << t << ", ";
    return Print(os, args...);
}
```

对包扩展的每个参数调用函数

```cpp
template<typename T, typename... Args>
std::ostream& Print(std::ostream& os, const T& t, const Args&... args)
{
    os << t << ", ";
    return Print(os, debug_rep(args)...);   //对参数包args中的每个参数调用函数debug_rep
}
```

包扩展完美转发

```cpp
template<typename... Args>
void func(Args&&... args)
{
    f(std::forward<Args>(args)...);
}
```

## 10. 模板特化

函数模板特化

```cpp
template<>
void func(const char* s)
{
    ...
}
```

类模板特化

```cpp
template<>
class hash<Data>{
    ...
}
```

类模板部分特化

模板参数部分特化：

```cpp
template<typename T>
class Foo<T&>{  //只接受左值引用参数
    ...
}
```

成员函数部分特化：

```cpp
template<>
void Foo<int>::Bar(){
    ...
}
```
