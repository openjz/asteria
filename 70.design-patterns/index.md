# 《设计模式》阅读笔记


参考《设计模式——可复用面向对象软件的基础》

## 设计模式空间

![design-patterns-space.png](/posts/70.design-patterns/design-patterns-space.png)

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
