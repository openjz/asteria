# 《设计模式》阅读笔记


参考《设计模式——可复用面向对象软件的基础》

## 设计模式空间

![design-patterns-space.png](/posts/70.design-patterns/design-patterns-space.png)

按目的分类：

1. 创建型（Creational）：与对象创建有关
2. 结构型（Structural）：处理类或对象的组合
3. 行为型（Behavioral）：类和对象的交互以及怎样分配职责

按作用范围分类：

1. 类：类模式处理类和子类之间的关系，这些关系通过继承建立，是静态的，在编译阶段已经确定。
2. 对象：对象模式处理对象间的关系，这些关系在运行时动态变化。

## 设计模式的UML图表示法

### 类

![uml-class](/posts/70.design-patterns/uml-class.png)

### 实例化

一个类的对象实例化另一个类的对象，箭头指向被实例化的类

![uml-instantlator.png](/posts/70.design-patterns/uml-instantlator.png)

### 继承

箭头指向父类

![uml-inherit.png](/posts/70.design-patterns/uml-inherit.png)

### 抽象类和子类的实现

![uml-implementation.png](/posts/70.design-patterns/uml-implementation.png)

### 委托（delegation）

委托是一种组合方法

委托用箭头表示一个类的实例对另一个类实例的引用关系，如下图所示，Window类把矩形相关的操作委托给了Rectangle类，具体实现上可以是Window类包含一个Rectangle对象作为成员

![uml-delagate.png](/posts/70.design-patterns/uml-delagate.png)

### 聚合（aggregation）

聚合（aggregation）是指一个类包含另一个类的对象，是一种组合关系，聚合和相识（acquaintance）的区别是，相识是一种弱引用，而聚合体现的是一种所有权。

![uml-aggregation.png](/posts/70.design-patterns/uml-aggregation.png)

## 抽象工厂模式（Abstract Factory）

![abstract-factory.png](/posts/70.design-patterns/abstract-factory.png)

如果我们有多个产品线（或多套产品配置），每个产品线内含的功能模块和对外接口都是相同的，只是功能模块的内部实现不同，这时可以使用抽象工厂模式对产品线进行隔离。

抽象工厂模式由以下两个部分组成：
1. 一个抽象工厂类， 多个具体工厂类
2. 多个抽象产品类， 每个抽象产品类又根据产品线的数量对应多个具体产品类

每个具体工厂负责创建对应产品线的所有产品

如此便可以为不同产品线定义统一的功能接口，并通过工厂隔离不同的产品线，实现了接口和业务的解耦

## 生成器模式（Builder）

![builder.png](/posts/70.design-patterns/builder.png)

如果一个子任务有多种不同的处理方式，可以将不同类型的子任务用统一的抽象接口定义，这样可以将子任务的具体实现对外隐藏，在主任务创建时根据子任务类型配置到主任务当中，这就是生成器模式。

生成器模式侧重于逐步构造一个复杂对象。

生成器模式主要包含两个参与者：
1. 导向器（director），用来调用生成器
2. 生成器（builder），包含抽象生成器和具体生成器，抽象生成器定义了统一的生成器接口，将具体生成器和导向器解耦

以下是一个生成器模式在富文本解析器中应用的示例，示例中使用了多钟不同的解析器对富文本做转换，根据生成器的类型，可将富文本转换为纯文本、tex和可交互的ui组件

![builder-sample.png](/posts/70.design-patterns/builder-sample.png)

## 工厂方法模式（Factory Method）

![factory-method.png](/posts/70.design-patterns/factory-method.png)

简单来说，就是把创建对象的接口抽象出来，放到抽象类中去

这个模式比较简单，**抽象工厂模式经常会用工厂方法模式实现**，可以说，工厂方法模式是抽象工厂模式的基础

## 原型模式（Prototype）

![prototype.png](/posts/70.design-patterns/prototype.png)

事先创建出来一个对象的示例，用户想要获得一个对象时，直接从预创建的对象上克隆一个新对象出来，而不是调用工厂方法去new一个对象出来

## 单例模式（Singleton）

![singleton.png](/posts/70.design-patterns/singleton.png)
