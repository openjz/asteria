# 《设计模式》阅读笔记


参考《设计模式——可复用面向对象软件的基础》

## 前述

设计模式整体看下来，主要讲的是该如何组织代码，如何将代码组织成可复用、可维护、可扩展的代码。

基本的思想是灵活运用组合将调用者和被调用者解耦，避免直接的继承关系，尽量使用接口和抽象类来定义通用的功能接口。

书中共提到23种设计模式，很多模式在工程实践中已经自然而然地被大量使用了，例如桥接模式、适配器模式、状态模式、策略模式等等，这些模式几乎是无可争议的最佳实践，不需要特别说明，就可以自然而然地应用在代码中。

需要特别注意的模式有如下12种：

### 创建型模式
  1. 工厂方法模式和抽象工厂模式：侧重于隐藏对象创建的细节。
  2. 原型模式：这个比较有意思，主要是为了避免重复创建对象，直接克隆一个已有的对象。
  3. 单例模式：确保一个类只有一个实例，并提供全局访问点。

### 结构型模式
  4. 外观模式：同时提供使用较为简单的上层接口和较为复杂的底层接口，供不同层次的用户使用。（基本所有大型基础库的导出接口都遵循这个模式，例如openssl、ffmpeg、各系统api）
  5. 享元模式：共享可复用的对象，减少内存占用和提高性能。（排版系统的设计模式）

### 行为型模式
  6. 责任链模式：请求链式传递，链上的每个对象都有机会处理请求。（golang的gin框架的中间件机制就是一个典型的责任链模式）
  7. 命令模式：将请求封装为一个命令对象，将请求发起方和请求接收方解耦。（ui层的设计模式）
  8. 解释器模式：编译器语法分析专用模式
  9. 备忘录：为对象不同时刻的状态记录检查点，以便实现撤销操作（适合用于编辑器的设计）。
  10. 观察者：发布-订阅模式。（C#的委托就是一种观察者模式）
  11. 模板方法模式：其实没什么特别的，它最大的特点是它是设计模式里面唯一的一个纯面向对象模式。
  12. 访问者模式：一种将数据和操作分离的模式，例如树状结构的遍历处理，挺有意思。


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

## 适配器模式（Adapter）

别名：Wrapper

第一个结构型设计模式，简单来说，就是将一个类的接口适配到另一个类的接口上，比如，如果我们想将一个已有的模块替换为另一个，新的模块接口和原来完全不一样，我们就可以加一层，使用适配器模式，将新模块的接口适配到原有接口上。

适配器模式的继承写法:

![adapter-inherit.png](/posts/70.design-patterns/adapter-inherit.png)

适配器模式的组合写法:

![adapter-composition.png](/posts/70.design-patterns/adapter-composition.png)

## 桥接模式（Bridge）

很简单，接口和实现分离

![bridge.png](/posts/70.design-patterns/bridge.png)

这个图感觉画的有点稍复杂

## 组合模式（Composite）

并不是简单的组合，而是把所有对象抽象为统一的component，并将其组合为层层父子关系

![composite.png](/posts/70.design-patterns/composite.png)

## 装饰器模式（Decorator）

装饰器模式也是一种组合模式，装饰器模式关注的是在不改变接口的前提下，动态扩展父类的功能

![decorator.png](/posts/70.design-patterns/decorator.png)

## 外观模式（Facade）

对于一个比较复杂的系统，它可能由很多子系统构成，它对外暴露接口时，尽可能提供一些较为简单的接口供用户使用，同时它不会完全隐藏底层的复杂细节，也会暴露一些相对底层的接口供用户使用，对于大多数用户来说，简单的默认接口已足够使用，而对于那些了解底层细节的用户，他们可以使用那些相对底层的接口，这就是外观模式

![facade.png](/posts/70.design-patterns/facade.png)

## 享元模式（Flyweight）

享元模式的理念是共享可复用的对象，主要目的是减少创建对象的数量，以减少内存占用和提高性能。

享元模式将使用享元工厂和享元池来管理和存储共享对象

![flyweight.png](/posts/70.design-patterns/flyweight.png)

## 代理模式（Proxy）

为其他对象提供代理，代理的目的包括访问控制、按需创建、引用计数等等

![proxy.png](/posts/70.design-patterns/proxy.png)

## 责任链模式（Chain of Responsibility）

请求链式传递，链上的每个对象都有机会处理请求，请求者并不知道请求最终会被哪个对象处理

![chain-of-responsibility.png](/posts/70.design-patterns/chain-of-responsibility.png)

## 命令模式（Command）

命令模式将请求封装为一个command对象，将请求发起方和请求接收方解耦。

以下是一个命令模式使用的场景：UI层会将每个菜单项的点击事件封装为一个command对象，传递给业务层，业务层根据不同的command对象，执行不同的业务逻辑。

![command-sample.png](/posts/70.design-patterns/command-sample.png)

命令模式的结构如下图所示，参与者分为client、invoker 和 receiver, client负责创建command并为其指定receiver，invoker负责调用command的execute方法，receiver负责具体的业务逻辑，注意receiver并不是接收命令的执行结果，而是接收命令本身，命令的执行要由receiver负责。

![command.png](/posts/70.design-patterns/command.png)

## 解释器模式（Interpreter）

解释器模式是一种专门针对语法解析的设计模式

以下是一个正则表达式解析的例子，图中将正则表达式拆分为多个表达式类，构成了一个抽象语法树。

![interpreter.png](/posts/70.design-patterns/interpreter.png)

## 迭代器模式（Iterator）

迭代器模式提供一种遍历聚合对象的方法，而无需暴露聚合对象的内部表示。

![iterator.png](/posts/70.design-patterns/iterator.png)

## 中介者模式（Mediator）

中介者模式用于封装一组对象之间的交互关系。中介者模式将对象之间的网状关系转化为星型关系，从而简化了对象之间的交互，并且可以将交互行为独立出来，使得对象之间可以松耦合地交互。

以下是一个中介者模式的交互示例，

![mediator.png](/posts/70.design-patterns/mediator.png)

## 备忘录模式（Memento）

备忘录模式用来实现检查点和撤销机制，它可以将对象的当前状态保存为一个“备忘录”，作为一个检查点，之后就可以将对象恢复到之前状态。

![memento.png](/posts/70.design-patterns/memento.png)

备忘录模式的参与者包括：

- Originator：发起者，它负责创建一个备忘录，用于记录当前状态，以及使用备忘录来恢复之前的状态。
- Memento：备忘录。
- Caretaker：管理者，负责保存备忘录，但不能对备忘录的内容进行操作或检查。

## 观察者模式（Observer）

观察者模式是一种发布-订阅（Publish-Subscribe）模式，它定义了一种一对多的依赖关系，当一个对象的状态发生改变时，所有依赖于它的对象都会得到通知并自动更新。

![observer.png](/posts/70.design-patterns/observer.png)

## 状态模式（State）

对象内部状态发生改变时，对象的行为也会随之改变，就好像修改了它的类一样，这种模式称为状态模式。

状态模式的侧重点在于，当保持对象的接口不变时，如何根据对象的状态改变对象的行为。

状态模式通常与状态机相结合，例如，下面是一个TCPConnection类的状态模式示例：

![state.png](/posts/70.design-patterns/state.png)

TCPConnection对象处于不同的状态时，它的接口会执行不同的动作，返回不同的结果。

## 策略模式（Strategy）

将不同的算法封装成不同的策略类，并通过上下文（Context）来选择具体的策略。

![strategy.png](/posts/70.design-patterns/strategy.png)

## 模版方法模式（Template Method）

典型的面向对象模式，定义一套通用的算法接口，把具体实现留给子类去实现，各子类具有共性的处理方法可以直接在基类中实现，避免代码重复。

![template-method.png](/posts/70.design-patterns/template-method.png)

## 访问者模式（Visitor）

访问者模式是一种将数据和对数据的操作分离的模式，例如，我们有一个树状结构，树中有各个类型的节点，我们要对不同类型的节点做各种不同的处理，如果把这些处理逻辑都放在节点类中，会导致节点类的代码变得非常复杂，这时可以使用访问者模式，将处理逻辑封装到访问者类中，当遍历树状结构时，根据节点类型，采用不同的访问者来处理节点。

![visitor.png](/posts/70.design-patterns/visitor.png)

