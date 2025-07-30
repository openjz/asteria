# 《汇编语言第4版——王爽》阅读笔记


## 一、基础知识

汇编指令是机器指令便于记忆的书写格式

汇编语言有三类符号：

1. 汇编指令
2. 伪指令，没有对应的机器码，由编译器识别，在编译期计算
3. 符号

CPU和内存之间存在三类总线：地址线，数据线和控制线

**字（word）和字节（byte）**

一个字由两个字节组成，共16位，一个字分为高位字节和低位字节

## 二、寄存器

8086CPU有14个寄存器，这些寄存器是：AX、BX、CX、DX、SI、DI、SP、BP、IP、CS、SS、DS、ES、PSW，这些寄存器分为：

1. 4个通用寄存器：AX、BX、CX、DX
2. 4个段寄存器：CS、DS、SS、ES
3. 指针寄存器：SP、BP、SI、DI

### 通用寄存器

8086 cpu的通用寄存器有4个，每个寄存器16位

一个通用寄存器可以分为两个8位寄存器来使用，高位部分用`H`后缀表示，低位部分用`L`后缀表示。例如，AX可以分为AH和AL

### 几条基本汇编指令

```asm
MOV AX, 18 ; 将18存入AX寄存器
ADD AX, 2  ; 将2加到AX寄存器

MOV BX, AX ; 将AX寄存器的值复制到BX寄存器
MOV AL, BL ; 将BX寄存器的低位字节复制到AX寄存器的低位字节
```

### 段的概念

段地址 + 偏移地址 = 物理地址

为什么需要两级地址？这跟8086 cpu的处理能力有关，8086 CPU的地址线有20根，但寄存器只有16位，不得不采用两级地址拼接的方式来访问内存。

### 段寄存器

段寄存器用于存储内存的段地址，8086 CPU有4个段寄存器：CS、DS、SS、ES

### CS和IP

CS（代码段寄存器）和**IP（指令指针寄存器）**合起来就是CPU当前执行的指令地址。

### 修改CS、IP的jmp指令

`jmp 段地址:偏移地址`

指令中给出的段地址修改CS寄存器的值，偏移地址修改IP寄存器的值

`jmp 某一寄存器`

仅修改IP寄存器的值

## 三、内存访问

数据的访问也遵循段地址+偏移地址的方式

DS寄存器存储数据的段地址

以下代码将内存地址10000H(1000:0)中的数据读取到寄存器al中

```asm
mov bx, 1000H
mov ds, bx
mov al, [0]
```

数据的段地址存放在ds寄存器中，往al中存放数据时只需要提供偏移地址`[0]`即可

`[address]`表示内存偏移地址

上面的例子只从内存中读取了一个字节，如果mov指令中给定的是16位寄存器，则会从内存中读取一个16位的字

sub指令用于减法，例如：

```asm
SUB AX, 1 ; 将AX寄存器的值减1
SUB BX, AX ; 用BX寄存器的值减去AX寄存器的值，结果存回BX
```

### CPU的栈机制

栈会占用一段内存地址

入栈出栈指令

```asm
push ax ; 将ax的数据入栈
pop ax; 将栈顶数据读入ax中
```

栈顶地址存储在段寄存器SS和**栈顶指针寄存器SP**中，也是段地址+偏移地址的形式

**栈底地址大，栈顶地址小，所以push会使SP变小，pop会使SP变大**

如何将某一部分内存指定为栈内存呢？很简单，将SS和SP设置为栈底地址即可

## 四、一个汇编程序

### 伪指令

伪指令由编译器分析执行，而不是由CPU执行

代码段定义

```asm
codesg segment; 代码段的名字位codesg
...
cosesg ends
```

汇编结束

```asm
... 
end
```

assume指令能够将段寄存器和某一个代码段关联起来

### 程序

汇编代码中真正被CPU执行的部分

### 标号

由程序员自定义的名字

### 程序返回

```asm
mov ax, 4c00h
int 21h
```

## 五、`[BX]`和loop指令

`[bx]`也表示内存单元，它的地址存放在bx寄存器中

loop代表循环，写法如下

```asm
mov cx, 循环次数
s:
    循环执行的程序段
    loop s ; 循环到s标号处
```

loop需要和寄存器cx配合，每次执行loop指令，cx寄存器的值会减1，当cx为0时，loop指令不再跳转

s是一个标号，loop指令会跳转到s处

什么时候会用到类似`[bx]`这种用法呢？如果要在loop中使用内存访问，而内存地址不断在变化的时候

`inc`是增加1的指令

访存时可以显式给出段地址和偏移地址，例如`ds:[0]`，其中`ds`叫段前缀

## 六、包含多个段的程序

### 在代码段中使用数据

```asm
assume cs : code

code segment

dw 0123h, 0456h, 0789h, 0abch, 0defh, 0fedh, 0cbah, 0987h;在代码中定义字型数据

mov bx, 0
mov ax, 0

mov cx, 8
s:add ax, cs: [bx]bx;   访问代码段中的数据
add bx, 2
loop s

mov ax, 4c00h
int 21h

code ends

end
```

dw 作用是定义字型数据，dw 即 define word，其实就是把数据硬编码到代码中，这样这些数据就会被编译器放到代码段中，可以用代码段寄存器CS加上数据在代码中的偏移量即可访问到数据

end指令可以用来指定程序的入口位置，下面的程序用start指定程序的入口地址，编译器会将start地址存储在可执行文件中，当程序加载到内存中准备执行时，将CS:IP设置为start的地址，程序就会从我们期望位置开始执行

```asm
assume cs:code

code segment

dw 0123h, 0456h, 0789h, 0abch, 0defh, 0fedh, 0cbah, 0987h

start:  mov bx, 0
        mov ax, 0

        mov cx, 8
    s:  add ax, cs: [bx]
        add bx, 2
        loop s

mov ax, 4c00h
int 21h

code ends

end start
```

因此，我们可以这么安排程序的框架

```asm
assume cs:code

code segment

数据
...

start:

代码
...

code ends

end start
```

### 在代码段中使用栈

可以使用和上面类似的方法，定义一个栈空间出来

```asm
assume cs : codesg

codesg segment

dw 0123h, 0456h, 0789h, 0abch, 0defh, 0fedh, 0cbah, 0987h

dw 0,0,0,0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
;用dw定义16个字型数据,作为栈

start: mov ax, cs
        mov ss, ax
        mov sp, 30h     ;将栈底地址设置为30h

        mov bx, 0
        mov cx, 8
    s:  push cs: [bx]
        add bx, 2
        loop s

        mov bx, 0
        mov cx, 8
    s0: pop cs: [bx]
        add bx, 2
        loop s0

        mov ax, 4c00h
        int 21h

        codesg ends

end start
```

### 将数据、代码、栈放在不同的段中

“程序的内存布局分为代码区，数据区，栈区和堆区”是一个经典面试问题，为什么程序的内存布局基本都遵循这个结构？这一节从汇编的角度解释了这个问题

cpu中有三类分别指向代码、栈和数据的寄存器，指令寄存器`[CS]IP`、栈顶指针寄存器`[SS]SP`，和数据段寄存器`DS`，这么组织程序内存布局天然符合CPU的设计

为什么线程栈的地址是从大到小增长的？因为cpu的push和pop指令就是这么设计的，push指令会使栈顶指针寄存器SP减小，pop指令会使SP增大，所以初始栈顶（也就是栈底）必须指向高地址

以下是一个例子，将数据、代码和栈放在不同的段中，并用各段的起始地址为DS、SS:SP寄存器赋初值，CS:IP由编译器根据程序入口点start的位置设置地址

```asm
assume cs: code, ds: data, ss: stack

data segment

dw 0123h, 0456h, 0789h, 0abch, 0defh, 0fedh, 0cbah, 0987h

data ends   ;数据段结束

stack segment

dw 0,0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

stack ends  ;栈段结束

code segment

start:  mov ax, stack
        mov ss, ax  
        mov sp, 20h ;设置栈顶ss:sp指向stack:20

        mov ax, data
        mov ds, ax  ;ds 指向data段

        mov bx, 0   ;ds:bx指向data段中的第一个单元

        mov cx, 8
    s:  push [bx]
        add bx, 2
        loop s

        mov bx, 0   ;以上将data段中的0~15单元中的8个字型数据依次入栈

        mov cx, 8
    s0: pop [bx]
        add bx, 2
        loop s0     ;以上依次出栈8个字型数据到data段的0~15单元中

        mov ax, 4c00h
        int 21h

code ends   ;代码段结束

end start

```
