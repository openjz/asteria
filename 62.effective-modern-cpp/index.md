# 《Effective Modern C++》阅读笔记


## 条款1：模板类型推导

c++模板类型推导经常用在模板函数类型推导，和auto类型推导

函数模板一般是以下形式

```cpp
template<typename T> 
void f(ParamType param); 
```

ParamType和T的区别是ParamType会包含一些饰词，例如const，引用符&等

T的推导结果要分三种情况讨论：

### 1.ParamType是指针或引用，但不是万能引用

这种情况下，T中只会包含ParamType中没有的饰词，ParamType中已经有的饰词会被忽略，例如

```cpp
template<typename T>
void f(const T& param);         //param现在是reference-to-const

int x=27;                       //x是int
const int cx=x;                 //cx是const int
const int& rx=x;                //rx是指向作为const int的x的引用

f(x);                           //T是int，param的类型是const int&
f(cx);                          //T是int，param的类型是const int&
f(rx);                          //T是int，param的类型是const int&
```

### 2.ParamType是万能引用

什么是万能引用？右值引用形参+模板类型推导就是万能引用（不在模板中使用右值引用就不能叫万能引用），例如：

```cpp
template<typename T> 
void f(T && param);
```

此时模板类型推导的规则如下所示

```cpp
template<typename T>
void f(T&& param);              //param现在是一个万能引用类型
        
int x=27;                       //如之前一样
const int cx=x;                 //如之前一样
const int & rx=cx;              //如之前一样

f(x);                           //x是左值，所以T是int&，
                                //param类型也是int&

f(cx);                          //cx是左值，所以T是const int&，
                                //param类型也是const int&

f(rx);                          //rx是左值，所以T是const int&，
                                //param类型也是const int&

f(27);                          //27是右值，所以T是int，
                                //param类型就是int&&
```

这也是为什么这种形式的声明叫做万能引用，当函数入参是右值时，param的类型是右值引用，当函数入参是左值时，param的类型就是左值引用

### 3.ParamType既非引用也非指针

这种情况也就是按值传递参数，类型推导时会忽略传入参数的引用符号&、const和volatile，如果传入参数是个指针，会忽略顶层const，但不会忽略底层const

```cpp
template<typename T>
void f(T param);                //以传值的方式处理param

int x=27;                       //如之前一样
const int cx=x;                 //如之前一样
const int & rx=cx;              //如之前一样

f(x);                           //T和param的类型都是int
f(cx);                          //T和param的类型都是int
f(rx);                          //T和param的类型都是int
```

为什么要忽略const，因为c++认为，既然是按值传递，传入参数不能修改不意味着副本不能修改

### 数组和函数实参推导

简单来说，ParamType中的类型饰词非引用时，数组和函数类型都会退化为指针

#### 数组实参推导

```cpp
const char name[] = "J. P. Briggs";     //name的类型是const char[13]

template<typename T>
void f(T param);                        //传值形参的模板

f(name);                                //T被推导为const char*
```

```cpp
const char name[] = "J. P. Briggs";     //name的类型是const char[13]

template<typename T>
void f(T &param);                        //传值形参的模板

f(name);                                //T被推导为const char (&)[13]
```

当模板函数的参数是按值传递时，数组入参会退化为指针，当模板函数的参数是按引用传递时，数组入参会按数组的引用传递

**这一特性可以用来实现一个利用模板获取数组大小的功能**

```cpp
template<typename T, std::size_t N>
constexpr std::size_t arraySize(T (&)[N]) noexcept
{                                                       
    return N;
}
```

#### 函数实参推导

```cpp
void someFunc(int, double);         //someFunc是一个函数，
                                    //类型是void(int, double)

template<typename T>
void f1(T param);                   //传值给f1

template<typename T>
void f2(T & param);                 //传引用给f2

f1(someFunc);                       //param被推导为指向函数的指针，
                                    //类型是void(*)(int, double)
f2(someFunc);                       //param被推导为指向函数的引用，
                                    //类型是void(&)(int, double)

```

和数组实参类型推导类似，函数实参的推导取决于模板形参的类型，模板形参为按值传递时，函数类型会退化为函数指针吗，模板形参为按引用传递时，函数入参会按照函数引用传递

## 条款2：auto类型推导

C++11 新增了auto类型声明

auto类型推导和模板类型推导类似，像`auto x = f(2);`这样一个变量定义，auto对应的是模板类型推导中的ParamType，即类型T+饰词。

也分三种情况：

1. 类型饰词是指针或引用，但不是万能引用。
2. 类型饰词是万能引用。
3. 类型饰词既非指针也非引用。

和模板类型推导结果是相同的。

类型饰词非引用的情况下，数组和函数类型也会退化成指针。

**auto推导和模板推导唯一不同之处，是对于大括号初始化表达式的处理方式**，如果一个auto变量以这种方式声明，`auto x={27};`，x会被推导为`std:: initializer_ list`类型，如果大括号里的值类型不一，则类型推导失败，代码通不过编译，例如`auto xs = { 1, 2, 3.0 };`，而**模板推导不了`{27}`这种形式的入参**。

C++14中，函数返回值可以声明为auto，lambda表达式中的函数形参也可以声明为auto，这两种auto推导实际上是模板推导

## 条款3：decltype

decltype可以在编辑器计算表达式的类型，可以这么用

```cpp
template<typename Container, typename Index> 
auto authAndAccess(Container& c, Index i ) -> decltype(c[i])
{
    authenticateUser(); 
    return c[i]; 
} 
```

这里使用了C++尾置返回值（trailing return type），尾置返回值的好处是可以使用形参列表中的变量

**decltype会返回给定名字或表达式的确切类型，不会忽略或转换任何东西，这一点和模板推导和auto推导不同**，这有个好处，如果auto返回值声明不符合预期，**可以使用`decltype(auto) `让auto的推导采用decltype的规则**，例如：

```cpp
 template<typename Container, typename Index> 
decltype(auto) 
authAndAccess(Container& c, Index i)
{
    authenticateUser(); 
    return c[i]; 
}
```

上面这段代码中，如果不使用decltype(auto)，只使用auto，按模板推导的规则，返回类型会将引用去掉，实际返回的是值类型

**decltype有一些比较复杂的情况**，例如，对于这种用法，`decltype(Expr)`（Expr是个左值表达式），如果Expr只是个名字，那这个名字对应的类型是啥，decltype返回的就是啥，如果Expr稍微复杂一点，decltype就会返回引用类型，例如：

```cpp
int x = 5;
decltype(x);    //返回int
decltype((x));  //返回int &
```

## 条款4：如何查看类型推导结果

构造一个空模板，利用编译错误输出模板推导结果

```cpp
//比方说，想知道x和y的推导结果
const int theAnswer; 42; 
auto x = theAnswer; 
auto y = &theAnswer;

//声明一个模板，不实现
template<typename T> 
class TD; 

//只要试图实例化该模板，就会诱发一个错误消息，编译器输出的错误信息就会把x和y的类型打印出来
TD<decltype(x)> xType; 
TD<decltype(y)> yType; 
```

还可以使用`typeid(x).name()`在运行时打印类型信息，但是这种方法打印出来的不一定准

IDE中显示的类型也不一定准。

boost库的`Boost.Typelndex`是准的。

## 条款8：nullptr

nullptr比起NULL，有利于模板类型推导，有利于消除重载函数调用的二义性，原因是NULL实际上是个int类型

## 条款9：using 和 typedef

尽量使用using，using可以模板化

```cpp
template<typename T>
using MyAllocList = std:: list<T, MyAlloc<T>>;

MyAllocList<Widget> lw; //用户代码
```

如果用typedef，必须新定义一个struct，然后写在struct内部

```cpp
template<typename T>                            //MyAllocList<T>是
struct MyAllocList {                            //std::list<T, MyAlloc<T>>
    typedef std::list<T, MyAlloc<T>> type;      //的同义词  
};

MyAllocList<Widget>::type lw;                   //用户代码
```

用户代码要加个`::type`

如果要在模板内部使用这个typedef定义

```cpp
template<typename T>
class Widget {                              //Widget<T>含有一个
private:                                    //MyAllocLIst<T>对象
    typename MyAllocList<T>::type list;     //作为数据成员
    …
}; 
```

前面要加`typename`，后面要加`::type`

## 条款10：优先使用 enum class 而不是 enum

## 条款11：优先使用 `= delete` 而不是 private声明

## 条款17：特殊成员函数的生成规则

1. 默认构造函数：用户没有定义任何构造函数的时候，编译器才会去生成默认构造函数
2. 拷贝构造函数和拷贝赋值运算符
    - 相互独立，如果用户只定义了其中一个，编译器会去生成另外一个
3. 移动构造函数和移动赋值运算符
    - 只要用户定义了其中一个，编译器就不去生成另外一个了，只有两个都没有定义的时候，编译器才会去生成
4. 拷贝，移动和析构的关系
    - 如果用户定义了拷贝操作，那么编译器不会去生成默认的移动操作
    - 反过来，如果用户定义了移动操作，那么编译器也不会去生成默认的拷贝操作
    - 如果定义了析构函数，编译器也不会去生成移动构造函数

## 条款18：unique_ptr

指针所有权只能转移，不能共享

默认情况下，销毁将通过`delete`进行，也可以自定义删除器

`unique_ptr`可以直接类型转换为`shared_ptr`

自定义删除器的写法

```cpp
auto delInvmt = [](Investment* pInvestment)         //自定义删除器
                {                                   //（lambda表达式）
                    makeLogEntry(pInvestment);
                    delete pInvestment; 
                };

std::unique_ptr<Investment, decltype(delInvmt)> //应返回的指针
        pInv(nullptr, delInvmt);
```

## 条款19：shared_ptr

`std::shared_ptr`使用引用计数（reference count）确定有多少个对原始指针的引用

引用计数的性能问题

1. 引用计数必须动态分配，`make_shared`比直接用shared_ptr构造开销要小一些，它将控制块的构造和对象的构造过程合并了
2. 引用计数的增减是原子的，因此，对shared_ptr进行移动构造比拷贝构造快，移动构造不需要增减引用计数

shared_ptr自定义删除器时，和unique_ptr不同，删除器不是类型的一部分

```cpp
auto loggingDel = [](Widget *pw)        //自定义删除器
                  {                     //（和条款18一样）
                      makeLogEntry(pw);
                      delete pw;
                  };

std::unique_ptr<                        //删除器类型是
    Widget, decltype(loggingDel)        //指针类型的一部分
    > upw(new Widget, loggingDel);

std::shared_ptr<Widget>                 //删除器类型不是
    spw(new Widget, loggingDel);        //指针类型的一部分
```

shared_ptr会为管理的对象建立一个控制块，控制块中包含引用计数，自定义删除器的拷贝等，多个shared_ptr会利用指针共享这个控制块

shared_ptr提供了`std::enable_shared_from_this`和`shared_from_this`这两个设施，对象可以用这两个东西获取到指向自身的shared_ptr，保证对象在处理一些异步操作时被错误释放掉，`shared_from_this`要求对象外必须已经有一个shared_ptr指向对象了，如果没有会抛出异常（很合理，如果`shared_from_this`是创建一个新的shared_ptr，这个shared_ptr一旦被释放，对象也跟着被释放了），用法如下

```cpp
class Widget: public std::enable_shared_from_this<Widget> {
public:
    ...
    void process();
    ...
};

void Widget::process()
{
    ...
    auto thisPtr = shared_from_this();
    ...
}
```

## 条款20：weak_ptr

weak_ptr不是独立的智能指针，是对shared_ptr的增强，它不能解引用，也不能判空（和nullptr比较）

std::weak_ptr通常从std::shared_ptr上创建，但它不会影响shared_ptr的引用计数

weak_ptr有两个用处，检查资源是否有效，解决shared_ptr循环引用问题

### 检查资源有效性

检查所指对象是否有效：

```cpp
if (wpw.expired()) …  
```

检查并访问对象：

```cpp
std::shared_ptr<Widget> spw1 = wpw.lock();  //如果wpw过期，spw1就为空
```

### 循环引用问题

有两个shared_ptr分别指向A和B，同时对象A和B各自持有对方的shared_ptr，这种情况下，释放智能指针实际上是释放不了A和B的

可以通过将A或B内部持有的shared_ptr换成weak_ptr来解决

### weak_ptr的使用原则

**weak_ptr和shared_ptr的最主要区别是weak_ptr不会获得资源的所有权，想要正确使用weak_ptr，要牢记这一点**

