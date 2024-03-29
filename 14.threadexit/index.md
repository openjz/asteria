# 线程什么时候终止


之前一直有几个疑惑，比如，

- 一个线程终止后，它创建的其他线程如果没执行完，会跟着终止还是继续执行？
- main函数返回后，其他没执行完的线程会终止吗？
- 主线程终止后，子线程如果没执行完会跟着终止吗？

## 结论：进程退出才会导致线程立即终止

通常来说，线程没有“主线程”和“子线程”的概念，进程内的所有线程地位是平等的，没有父子、主从等依赖关系。

如果一个线程创建了其他线程，这个线程终止后，被其创建的线程可以继续执行，main线程也一样，它的终止也不会影响到其他线程的执行。

但是当进程退出的时候，进程内的所有线程都会被立即终止。

之所以会产生上面的疑惑，是因为混淆了线程退出和进程退出，在有些语言里main函数返回会导致进程退出，这会让人误以为其他线程的终止是由main线程终止导致的，实际上是由进程退出导致的。

至于进程什么时候退出，不同语言处理不太一样。

## c（pthread）

在c语言中，main函数通过return语句返回后会导致进程退出，进程中的所有线程会被立即终止。

如果在main函数中调用`pthread_exit()`，只会导致main线程被终止，其他线程则不受影响，因为进程并没有退出。（在其他线程中调用`pthread_cancel()`终止main线程也一样）

## java

java中的线程分为两类，普通线程和守护线程（daemon），所有线程运行在一个jvm进程中，只有当jvm进程中没有普通进程时，jvm进程才会退出，不管是不是存在守护线程。

main线程是一个普通线程，当jvm进程中没有其他普通线程时，jvm进程会在main函数执行完毕后退出，但是如果jvm进程中还有其他普通线程没执行完，即使main函数先返回，jvm进程也不会退出，会等所有普通线程都执行完才会退出。

## golang

go的协程调度和线程类似，协程之间没有主从的概念，创建协程终止不会影响被创建协程的执行。

main函数返回后进程退出，所有协程被终止


