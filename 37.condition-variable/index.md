# 条件变量


条件变量是一种线程同步手段，一般由三个部分组成：信号，条件和互斥量，他们的作用是这样的：

- 信号的作用是线程间同步，一般会提供两个基本操作，wait 和 notify，wait用于等待信号，notify用于发出信号
- 条件一般是用户自己定义的检查条件。
- **互斥量一是用于保护条件在多线程访问下的一致性，二是用于保护条件变更和信号变更之间的时序，防止漏掉信号或程序死锁**。

## 为什么需要互斥量？

条件变量的机制一般是要求必须在notify之前wait，如果在notify之后wait，会导致notify丢失，wait永远阻塞，这是前提。

使用条件变量时，一般有四种操作（假设条件名为ready）：

- 线程1：
    - 操作1：wait，等待信号
    - 操作2：check ready，检查条件
- 线程2：
    - 操作3：ready <- true，变更条件
    - 操作4: notify，发出信号

操作3、4的顺序一般是固定的，我们总是会在条件ready变更之后才notify，操作1、2的顺序则不一定，有时候先check ready再 wait，有时候先wait再check ready。

互斥量保护的是条件在多线程下的一致性和操作顺序的原子性，如果操作1、2的顺序永远是先wait再check ready，并且只执行一次，是不需要互斥量的，因为wait被触发时，ready <- true 和 notify 肯定已经执行完毕了，这时候直接check ready肯定是没问题的。

如果先check ready再wait，在没有互斥量的情况下，操作顺序可能会被调度为以下顺序：

- 线程1：check ready
- 线程2：ready <- true
- 线程2：notify
- 线程1：wait

在这种顺序下，check ready在ready <- true之前，因此线程1认为此时不满足条件，需要wait，而wait被调度到了最后，导致接收不到线程2发出的notify信号，陷入永远的阻塞当中。

因此，我们需要使用互斥量将check ready和wait操作绑定到一起，同时为ready <- true操作也上锁，这样，当check ready发生在ready <- true之前时，只有线程1执行完wait，线程2才能获取到锁，执行ready <- true，这样，wait一定发生在notify之前，条件ready也得到了多线程下的访问保护，check ready 和 ready <- true之间不会发生冲突，调度顺序如下：

- 线程1：获取锁
- 线程1：check ready
- 线程1：wait
- 线程1：释放锁并阻塞等待
- 线程2：获取锁
- 线程2：ready <- true
- 线程2：释放锁
- 线程2：notify

那什么情况下会先check ready再wait呢？在循环check ready和wait的时候，例如：

```cpp
while(!ready)
{
   wait(); 
}
//或
do
{
    wait();
}
while(!ready)
```

**条件变量中有三种原子操作**

1. 锁定 -> 检查条件 -> wait -> 解锁+阻塞等待
2. wait唤醒 -> 锁定
3. 锁定 -> 更改条件 -> （解锁 -> notify/notify -> 解锁）

以下内容参考[https://en.cppreference.com/w/cpp/thread/condition_variable/notify_one](https://en.cppreference.com/w/cpp/thread/condition_variable/notify_one)notes部分

>注意，在notify之前解锁是为了防止等待线程刚一唤醒就被阻塞，造成性能损失，在一些pthread实现中，会直接在notify的内部实现中把等待线程移到mutex队列中，节省掉notify线程解锁等待线程再加锁这一操作。
>
>有时候也需要notify之后再解锁，防止wait线程把信号给析构了导致在一个被析构的对象上notify

后面说的这种情况根据我的个人理解应该是这么一个调度顺序

- 线程2：获取锁
- 线程2：ready <- true
- 线程2：解锁
- 线程1：获取锁
- 线程1：check ready
- 线程1：满足条件后直接跳过wait，析构信号
- 线程1：解锁
- 线程2：notify后崩溃

这种情况下，需要互斥锁把条件变更和notify操作绑定到一起。

这么看来，文中所提到的一些pthread实现其实更好，既避免了性能损失问题，又避免了信号在notify之前被析构。

## C++11 中 的 condition_variable

参考[https://zh.cppreference.com/w/cpp/thread/condition_variable](https://zh.cppreference.com/w/cpp/thread/condition_variable)

C++11中的条件变量机制叫做condition_variable，头文件是`#include <condition_variable>`

condition_variable包含三部分，`std::mutex`、`std::condition_variable`和一个bool谓词（一个用作条件检查的函数）

condition_variable提供了几种操作：

- `wait`
- `wait_for`
- `wait_until`
- `notify_one`
- `notify_all`

其中wait系列操作分别包含两个版本，一个带条件的，一个不带条件的。

在上文提到的条件变量三种原子操作中：

1. 锁定 -> 检查条件 -> wait -> 解锁+阻塞等待
2. wait唤醒 -> 锁定
3. 锁定 -> 更改条件 -> （解锁 -> notify/notify -> 解锁）

wait操作内部整合了`检查条件 -> wait -> 解锁+阻塞等待`以及`wait唤醒 -> 锁定`，其他的锁定和解锁动作需要用户自己去完成。

一个例子

```cpp
std::mutex muCond;
std::condition_variable cond;

std::thread t([&mutex, &cond]()->void
    {
        std::unique_lock<std::mutex> ul(muCond);
        cond.wait(ul);
    });

std::unique_lock<std::mutex> ulCond(muCond);
cond.notify_all();
```

