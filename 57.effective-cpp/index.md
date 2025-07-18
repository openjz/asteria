# 《Effective C++ 第三版》阅读笔记


## 第二条：少用#define，用const, enum, inline代替#define

#define定义的名字会被预处理器替换为它的值，这回导致定位问题困难，因为不管是编译报错还是dump文件调用栈里面的名字都是#define的值，而不是#define的名字，跟代码完全对不上

尤其是#define定义的函数宏，难以阅读，难以维护

## 第三条：多用const 及 const的正确用法

### const是什么

const是一个语义约束，告诉编译器某个对象不该被修改。

const用在指针上时，分为顶层const和底层const

### 将函数返回值定义为const有什么用

将函数返回定义为const，可以避免用户写出这样的东西：`a * b = 6`，（a和b是两个自定义类型的对象，如果a和b是内置类型，这么做当然是不合法的），以下代码就是个例子：

```c++
class CNum
{
public:
    //1. 构造函数定义了一个从内置类型int到CNum的隐式类型转换
	CNum(int n) :_n(n) {}
    //2. 重载了拷贝复制运算符
	CNum& operator=(const CNum& num)
	{
		_n = num._n;
	}
private:
	int _n;
};

//3. 重载了乘法运算符
CNum operator*(const CNum& a, const CNum& b)
{
	return a * b;
}

int main(int argc, char**argv)
{
	CNum a(1);
	CNum b(2);
    //4. 然后就能写出下面这样的东西
	a * b = 6;
	return 0;
}
```

如果我们在上面这段代码中让重载乘法运算符返回一个const值，就能避免`a * b = 6`这样的写法

### const成员函数怎么用

const对象只能调用const成员函数

**const有两种，一种是bitwise constness（physical constness），字面翻译是物理const，第二种是logical constness，即逻辑const**，这两种const有什么区别呢，下面给出两个例子，

**例一**：一个对象有一个指针成员，如果我们在一个const成员函数里改了指针指向的内容，而没有改指针本身，这种const属于bitwise constness，即我们没有修改对象的任何一个成员，哪怕一个bit，但不属于logical constness，因为从逻辑上讲实际上我们改东西了，只不过改的不是成员本身的值，改的是它指向地址里的内容。这种情况编译器不会报错，编译器只认bitwise constness。

**例二**：和例一相反，我们有一个const成员函数length，是获取对象的长度，但是获取的时候呢，我们希望更新一下内部的一个长度变量的值，从逻辑上讲，调用length函数的用户肯定对更新变量是无所谓的（它只是对长度的一个缓存而已），但编译器不同意，它不允许你去修改任何一个成员。

像例二这种情况，我们的解决办法是将长度变量定义为`mutable`

我们在编写const函数时，最好是基于logical constness的原则，因为这更符合人类的思维

当同一个成员函数要同时定义const和非const两个版本时，为了避免代码重复，最好让非const版去调用const版，而不要反过来，因为那会打破const函数不修改任何东西的承诺（而且还需要引入类似`const_cast`这样的特性，这不是个好兆头）

## 第四条：永远都要初始化变量或对象

原因很简单，使用一个未初始化的对象在c++中是未定义行为（Undefined Behavior），一旦触发这种场景，程序很有可能出错。

问题在于，哪种场景比较容易触发这个问题呢？

在C++中，对象的初始化顺序是有严格规定的，但**没有规定跨编译单元的non local static对象的初始化次序**，这就意味着，如果你有两个这样的对象A和B, A在初始化时使用了B，但由于A和B的初始化次序不一定，很有能在B未初始化的情况下被A引用了，这时程序就会出错。

这里解释下什么叫“没有规定跨编译单元的non local static对象”， **编译单元**是指产出单一目标文件（obj文件）的源码，基本上就是单个源码文件加上其所包含的头文件，**non local static对象**是指定义在函数外的static对象，包括全局对象，类的static成员，文件内的static对象等。

结论是，**尽量使用local static对象**（即定义在函数内部的static对象），因为local static对象定义在函数内部，当函数第一次被调用的时候才会触发对象的初始化，这也是C++经典的单例模式写法（在C++11中，多线程初始化local static对象是线程安全的）

## 第七条：虚析构函数

**不要去继承一个没有多态性质的基类**，比如一个类，它没有定义虚析构函数，这说明编写者没有想把这个类作为多态基类，如果我们去继承了这个类，有存在很大的内存泄露风险。

比如，类A是基类，没有定义虚析构函数，类B继承自类A，如果定义了一个指向B的指针pb，然后不小心把它转换为指向A的指针pa，当我们试图delete pa时，会发生内存泄露，因为A没有虚析构函数

**抽象类的纯虚析构函数要给一个定义**，不然派生类调不到会引发链接错误。

结论：**基类没有定义虚析构函数的时候，从基类指针析构派生类，只会调用基类的析构函数，不会去调用派生类的析构函数**

## 第九条：不要在构造和析构函数中调用虚函数

当类之间存在多态的继承关系时，如果基类在构造和析构时调用虚函数，此时会调用基类自身的虚函数，即，当派生类构造时，基类构造和析构函数调用的是基类的虚函数，而不是派生类的虚函数。

原因也很好理解，构造时，基类成员先于派生类成员构造，如果基类去调用派生类的虚函数，那就有可能出问题，反过来，析构时也是同样的道理。

## 第九、十条：拷贝赋值operator=的正确写法

写法一：

```c++
class Widget
{
...
private:
	Bitmap* pb;
}

//1. 返回Widget引用是标准写法，方便链式调用
Widget & Widget::operator=(const Widget& rhs)
{
	//2. 自赋值判断
	if(this == &rhs)
	{
		return *this;
	}

	//3. 先把原来的内存保存下载，等新内存分配成功了，再释放原来的内存
	// 如果先释放原来的内存，一旦新内存分配失败，原来的对象也没有了
	// 这样可以保护原对象，并且天然具有自赋值判断的功能
	Bitmap* pOrig = pb;
	pb = new Bitmap(*rhs.pb);
	delete pOrig;
	return *this;
}
```

为什么要做自赋值判断，一是因为赋值操作可能要把原来的内存释放掉，重新申请内存后再赋值，如果先去释放内存，自赋值时就会将自身破坏掉，为了防止这种情况，需要进行自赋值判断，二是出于执行效率考虑，也应该进行自赋值判断

写法二：

```c++
class Widget
{
...
private:
	Bitmap* pb;
}

Widget & Widget::operator=(const Widget& rhs)
{
	Widget temp(rhs);
	swap(temp);
	return *this;
}
```

这种写法和上面的效果是一样的，都会产生一次对象构造，而且具备自赋值检查功能

## 第十三条：RAII

RAII(Resource Acquisition Is Initialization)

1. 获取到资源后立即放入对象管理
2. 靠对象析构释放资源

常见的标准库RAII类：`std::shared_ptr`，`std::lock_guard`

## 第二十条：参数类型尽量用const T& 代替 T

这么做有以下好处：

1. 传引用比传值高效，可以避免不必要的对象拷贝
2. 支持多态
3. 语义比较明确，调用者会明白这是个不可修改的入参

## 第二十五条：定义一个swap函数

书里罗列了好几条复杂的原则，略过

## 第二十七条：尽量少做类型转换

类型转换比较危险，容易引起错误

现代C++中的四种类型转换：

1. `const_cast<T> (expression) `：做const消除
2. `dynamic_cast<T>(expression)`：从基类指针或引用转为派生类指针或引用
3. `reinterpret_cast<T>(expression)`：强行转换
4. `static_cast<T>(expression)`：强迫隐式类型转换，大部分老式类型转换都可以用`static_cast`代替

现代c++把老式的强制类型转换拆成了两个，`static_cast`和`reinterpret_cast`，`static_cast`会在编译器检查转换的合法性，而`reinterpret_cast`不会去检查，就是强转。

## 第二十九条：异常安全的代码

这一条讲的是一个代码设计问题，并不是语法问题

异常安全的代码，要能做到以下几点之一：

1. 如果异常被抛出，程序内的任何事物仍能保持有效状态
2. 如果异常被抛出，程序状态不变，仍能恢复到原有状态，即，要么完全成功，要么失败回滚
3. 绝不抛出异常

copy and swap：修改对象内数据时，先修改它的副本，这样即使异常发生，也不会影响原始数据 

## 第三十二条：继承是一种“is-a”关系

另外两种关系是“has-a” 和 “is-implemented-in-terms-of”

## 第三十三条：不要遮掩继承来的名字

派生类中的名字会把基类中相同的名字覆盖掉，有点类似于局部作用域把全局作用域的名字覆盖掉

有问题的写法：

```cpp
class Base
{
public:
	virtual void mf1() = 0;
	virtual void mf1(int) {}
	virtual void mf2() {}
	void mf3() {}
	void mf3(double) {}

private:
	int x = 0;
};

class Derived:public Base
{
public:
	virtual void mf1() {}
	void mf3() {}
	void mf4() {}
private:
};

int main()
{
	Derived d;
	d.mf1();	//调用 Derived::mf1
	d.mf1(2);	//错误：编译器提示找不到这个函数
	d.mf2();	//调用 Base::mf2
	d.mf3();	//调用 Derived::mf3
	d.mf3(2);	//错误：编译器提示找不到这个函数
	return 0;
}
```

正确写法：

```cpp
class Base
{
public:
	virtual void mf1() = 0;
	virtual void mf1(int) {}
	virtual void mf2() {}
	void mf3() {}
	void mf3(double) {}

private:
	int x = 0;
};

class Derived:public Base
{
public:
	using Base::mf1;	//使基类的所有mf1可见
	using Base::mf3;	//使基类的所有mf3可见

	virtual void mf1() {}
	void mf3() {}
	void mf4() {}
private:
};

int main()
{
	Derived d;
	d.mf1();
	d.mf1(2);
	d.mf2();
	d.mf3();
	d.mf3(2);
	return 0;
}
```

或者

```cpp
//...
class Derived:public Base
{
public:
	//...
	virtual void mf1() {
		Base::mf1();	//显示调用基类函数
	}
};
```

## 第三十四条：接口继承和实现继承

pure-virtual函数属于接口继承

impure-virtaul函数属于是提供了默认实现的接口继承

non-virtual函数属于实现继承

## 第三十六条：不要override基类的non-virtual函数

这会让人困惑，既然你要override，为什么不把这个函数定义为virtual函数

当然这么做在语法上是行得通的

## 第三十七条：虚函数是动态绑定的，而虚函数的默认参数却不是

也就是说，如果基类的虚函数声明了默认参数，即使子类的虚函数声明了不同的默认参数，从基类的指针调用虚函数时，使用的还是基类声明的默认参数

## 第三十八条：组合（composition）是一种“has-a”关系

参考第三十二条


## 第四十条：多重继承的问题

尽量不要使用多重继承

使用多重继承时，你的类继承关系可能会形成一个菱形结构，例如，类B,C都继承了类A，类D多重继承自类B,C，这会导致两个问题：

1. 从类D调用类A中的函数时会产生歧义，编译器不知道该调用从哪个分支继承过来的函数，解决办法是明确指定函数的类名
2. 类A的实例会存在两份，解决办法是使用虚继承，而虚继承的性能较差，并且虚基类的初始化规则也很复杂

所以尽量不要使用多重继承

## 第四十九条：new-handler

正常情况下，C++中的new操作失败时会抛出bad_alloc异常

而new-handler是new操作失败时的处理函数，用户可以调用`std::set_new_handler`将一个函数指定为new-handler，在new操作失败抛出异常之前，它会先调用new-handle，用户可以在这个函数里为内存分配失败“善后”。

可以给类定义一个static的new-handler成员，作为专属类的new-handler，如果将该类作为基类，让派生类也都能继承new-handler，这会产生一个问题，**不同的派生类会共享同一个static成员**，为了解决这个问题，文中用了一个技巧，即将这个基类模板化，即可解决问题
