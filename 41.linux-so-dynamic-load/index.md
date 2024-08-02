# linux 动态库so文件 动态加载


## 概念

首先要明确几个概念：

- 静态链接：链接.a库
- 动态链接：编译后立即链接.so，主程序启动时即加载.so
- 动态加载：编译后不立即链接.so，主程序调用dlopen时链接并加载.so

## demo

- （main.cpp）主程序

  ```cpp
    #include <iostream>
    #include <dlfcn.h>

    int main()
    {
        void * handle;
        char * error;
        //链接并加载
        handle = dlopen ("./libshared.so", RTLD_LAZY);  
        if (!handle) {  
            std::cerr<<dlerror()<<std::endl;
            exit(1);  
        }
        //获取符号
        void(*print)() =(void(*)())dlsym(handle, "print");
        //执行函数
        print();
        if ((error = dlerror()) != NULL)  {  
            std::cerr<<error<<std::endl;
            exit(1);  
        }
        //关闭动态库
        dlclose(handle); 
        return 0;
    }
  ```

- （shared.h）.so

    ```cpp
    #pragma once

    int global =5;
    //这里好像一定要加上extern "C"，否则主程序调用动态库里的函数时总是找不到符号
    extern "C"
    {
    void print();
    }
    ```

- makefile  
  注意，（1）主程序**链接**参数要加上`-ldl`，不要链接动态库，否则就不是动态加载了（2）主程序的**编译**参数通常要加上`-rdynamic`（不知道为什么）。

    ```makefile
    # 动态库
    $(Shared_Name): $(Shared_Cpp_Object)
        $(CXX) -shared $^ -o $@
    $(Shared_Cpp_Object):%.o:%.cpp
        $(CXX) -fPIC $(Cpp_Compile_Flags) -c $< -o $@
    #可执行文件
    $(App_Name): $(App_Cpp_Object)
        $(CXX) -ldl $^ -o $@
    $(App_Cpp_Object):%.o:%.cpp
        $(CXX) $(Cpp_Compile_Flags) -rdynamic -c $< -o $@
    ```

