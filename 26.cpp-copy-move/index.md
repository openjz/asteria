# c++中的拷贝和移动语义


## demo

```cpp
class A{
public:
    A(const A& b):e(new int(*(b.e))){}
    A & operator=(const A & b){
        if(this != *b){
            int * c = new int(*(b.e));
            delete e;
            e = c;
        }
        return *this;
    }
    A(A &&b) noexcept :e(b.e){
        b.e = nullptr;
    }
    A & operator=(A && b) noexcept{
        if(this!=*b){
            delete e;
            e = b.e;
            b.e = nullptr;
        }
        return *this;
    }
private:
    int *e;
};
```

## 拷贝语义

拷贝语义分为拷贝构造和拷贝赋值

```cpp

class ClassA{
public:
    // 拷贝构造
    ClassA(const ClassA & b):e(new int(*(b.e))){}
    // 拷贝赋值
    ClassA & operator=(const ClassA & b) {
        //检测自赋值
        if(this != &b){
            int newe = new int(*(b.e));
            delete e;
            e = newe;
        }
        return *this;
    }
private:
    int *e;
}

```

## 移动（move）语义

C++11 中提出了移动（move）语义，移动语义是相对于拷贝语义的，目的是想减少对临时值的拷贝，改为直接接管临时值的资源。

移动语义只是一个语义，具体的移动操作需要用户自己配合右值引用来实现。

为了说明移动语义的作用，首先介绍一下 C++中的值类型。

### C++中的值类型

参考

- [C++ lvalue，prvalue，xvalue，glvalue 和 rvalue 详解（from cppreference）](https://www.cnblogs.com/Philip-Tell-Truth/p/6370019.html)
- [什么是 lvalue, rvalue, xvalue](https://cloud.tencent.com/developer/article/1493839)
- [cppreference.com-Value categories](https://en.cppreference.com/w/cpp/language/value_category)

现代 C++中的值分为 5 类，这里对这五类值做一个简单介绍。

lvalue：**左值**，就是传统意义上的左值。  
prvalue：纯右值，是传统右值的一部分，纯右值是表达式产生的中间值。  
xvalue：消亡值，只能通过右值引用产生。  
glvalue：泛左值。glvalue = lvalue + xvalue  
rvalue：**右值**，就是传统意义上的右值。ravlue= prvalue + xvalue

一个最简单的理解是，左值是持久的可以取地址并修改的变量，右值是一个临时的不可以修改的值。比如:

```c++
int i = 0;  //左值
i * 45; //右值
```

**通常属于右值的有，常量、字面量、临时变量/对象、匿名对象**

### 右值引用

右值引用只能绑定到右值上（通常是一个临时对象），因此右值引用可以保证

1. 所引用的对象即将被销毁。
2. 该对象没有其他用户。

这两个特性意味着：使用右值引用的代码可以自由地接管所引用对象的资源。

我们通过`“&&”`来获得右值引用，例如，

```C++
int i = 42;
int && r = i*42;    //r是一个右值引用
```

通过一个例子看左值引用和右值引用的区别

```cpp
int main()
{
    int i = 3;
    int &&j = i++;  //正确
    int &&k = ++i;  //错误，++i返回的是一个左值
    int &m = i++;   //错误，i++返回的是一个右值
    int &l = ++i;   //正确
    return 0;
}
```

报错：

```
algo.cpp: 在函数‘int main()’中:
algo.cpp:20:17: 错误：无法将左值‘int’绑定到‘int&&’
     int &&k = ++i;
                 ^
algo.cpp:21:15: 错误：用类型为‘int’的右值初始化类型为‘int&’的非常量引用无效
     int &m = i++;
```

### 如何实现移动语义

移动语义包括两部分，移动构造函数和移动赋值运算符

移动构造函数和移动赋值运算符正是利用了上面所提到的右值引用的特性。

移动构造函数和移动赋值运算符需要一个右值引用作为参数。这就意味值，如果参数类型有析构方法，这个参数随后就会被析构。

很多资料会告诉我们，移动构造函数或移动赋值运算符会接管资源而不是拷贝资源。这种表述非常令人迷惑，实际上，接管资源并不是这两个函数本身的功能————它们本身什么功能都没有，只是给接口定义了移动语义。接管资源这一功能是通过程序员自己在移动构造函数中写代码来实现的。

实现一个移动操作要保证以下几点：

- 参数必须是右值引用（这样才能定义移动语义）
- 不分配新内存，不进行内存拷贝，而是通过修改指针来接管资源
- 确保源对象的析构操作不会影响目标对象
- 不抛出异常，并显式声明（使用 noexcept 关键字），防止编译器认为移动操作不安全从而不使用移动构造

下面是移动操作的例子

```cpp

class ClassA{
public:
    // 移动构造
    ClassA(ClassA && b) noexcept //参数是右值引用
    : e(b.e) {  //接管资源
        b.e = nullptr;  //确保b析构是安全的
    }
    // 移动赋值
    &ClassA operator=(ClassA && b) noexcept { //参数是右值引用
        //检测自赋值
        if(this != &b){
            delete e;     //释放已有元素
            e = b.e;    //接管资源
            b.e = nullptr;
        }
        return *this;
    }
private:
    int *e;
}
```

### std::move

标准库函数`std::move()`可以获取一个左值的右值引用。对一个源对象调用这个函数后必须保证后续对源对象只做赋值或销毁操作，但是不去使用它。

## 其他

### 成员函数限定符 &和 &&

和给类的成员函数加上 const 限定符类似，也可以把`&`和`&&`作为成员函数限定符，表示只有左值或右值才能调用这个函数。

&、&&可以和const一起使用，const必须写在前面。

### Copy Elision

Copy Elison 是 C++的一项编译器优化，意思是在某些情形下，构造对象时会忽略该对象的拷贝/移动构造函数，直接将对象构造出来。有一种情形是这样的，用一个临时对象去构造一个相同类型的对象

```C++
T obj(T(arg));
```

在这种情况下，对象`obj`不会去调用他的移动构造函数，而是直接被构造出来。

如果程序是用 gcc 的 C++14 或 C++11 标准编译的，我们可以通过加上`-fno-elide-constructors`这一编译选项来阻止编译器进行此项优化。

一个会触发 Copy Elision 的典型场景是这样的（如下面的代码所示） ，假如一个类同时定义了一个隐式的类类型转换和一个拷贝构造/移动构造函数时，如果构造对象时同时用到了这两个函数，就会触发 Copy Elison，即只会进行直接构造（隐式的类类型转换），而不会进行之后的拷贝构造。

```C++
//类代码
class String{
...
public:
    String();
    String(const char*);  //c风格字符串,隐式的类类型转换规则
    //拷贝控制
    String(const String &); //拷贝构造

...
};
//测试代码
String str = "Hello world!"; //这里会触发copy elision
```

然而在 C++17 中，情况有所改变，上述情形不再属于 Copy Elision。C++17 规定，用 prvalue（即纯右值）构造相同类型的对象时，不调用其移动/拷贝构造函数。`T(arg)`是一个 prvalue，因此构造`obj`时是不会去调用它的移动/拷贝构造函数的。也就是说 C++17 把对上述情形的优化直接放到了 C++语言标准里，不再属于编译器优化。这就意味着在 C++17 标准下，即使加上编译器选项`-fno-elide-constructors`也不能阻止上述情形被优化。

当然 C++17 中仍然有 Copy Elision，只是上述情况不再属于 Copy Elision。

参考

[在 C++11 中，使用匿名类构造一个对象时会发生什么？](https://segmentfault.com/q/1010000020484320/a-1020000020488364)  
[C++ lvalue，prvalue，xvalue，glvalue 和 rvalue 详解（from cppreference）](https://www.cnblogs.com/Philip-Tell-Truth/p/6370019.html)

[cppreference.com-Copy elision](https://en.cppreference.com/w/cpp/language/copy_elision)  
[cppreference.com-Value categories](https://en.cppreference.com/w/cpp/language/value_category)

### swap

swap 用来交换两个对象的数据，swap 的实现分为用户自定义 swap 和 std::swap()

以下是用户自定义 swap 的例子

```cpp
class ClassA{
    friend void swap(ClassA &,Class &);
private:
    int *e;
};
inline
void swap(ClassA &a,Class &b){
    using std::swap;    //这个声明并不是为了让下面调用std::swap，而是当下面被交换的值没有自定义swap函数时，给它们调用std::swap的机会
    swap(a.e, b.e); //这里优先匹配参数类型自己定义的swap，如果匹配不到才调用std::swap
}
```

