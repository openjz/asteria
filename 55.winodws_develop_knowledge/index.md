# 一些和windows开发相关的小知识


## WinMain函数的参数

WinMain函数的参数hPrevInstance原本是为了获取程序的进程示例，可以用来判断程序是否有其他进程已经启动，后来这个参数弃用了
那么现在如何让一个windows程序全局只运行一个实例呢？
可以使用CreateMutex创建一个互斥体，[https://learn.microsoft.com/zh-cn/windows/win32/api/winbase/nf-winbase-winmain](https://learn.microsoft.com/zh-cn/windows/win32/api/winbase/nf-winbase-winmain)

## long类型和int类型的区别
long类型和int类型原本是为了区分长短指针的，后来在32位和64位的操作系统上已经没有长短指针的区分了，因此long和int在windows上是没有区别的。

不同操作系统对整型长度的定义不同，操作系统对整型长度的定义叫做“抽象数据模型”或“数据模型”，[https://learn.microsoft.com/zh-cn/windows/win32/winprog64/abstract-data-models](https://learn.microsoft.com/zh-cn/windows/win32/winprog64/abstract-data-models)

数据模型有很多分类，如LP64，ILP64，LLP64，ILP32，LP32等，unix/类unix系统普遍使用LP64模型，32位windows系统使用ILP32模型，64位windows系统使用LLP64模型，不管是32位还是64位的windows，long和int都是四个字节

## 参数命名

szXXX这种参数命名代表参数是c风格的字符串（以0结尾）

这属于匈牙利命名法，然而微软内部已经废弃了这套命名方法，参考[https://learn.microsoft.com/zh-cn/windows/win32/learnwin32/windows-coding-conventions](https://learn.microsoft.com/zh-cn/windows/win32/learnwin32/windows-coding-conventions)

>C++ 核心准则禁止使用前缀表示法 (例如匈牙利表示法) 。 请参阅 NL.5：避免在名称中编码类型信息。 在内部，Windows 团队不再使用它。 但它的用法仍保留在示例和文档中。

## _T宏

_T宏是为了兼容多字节和宽字节字符串发明的，如果项目定义了UNICODE宏，_T("xxx")对应的是L"xxx"，否则，_T("xxx")对应的是"xxx"

