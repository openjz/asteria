# 《汇编语言第4版——王爽》阅读笔记


本书所讲内容，都基于8086 cpu架构

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

cpu中有三类分别指向代码、栈和数据的寄存器，指令寄存器`CS:IP`、栈顶指针寄存器`SS:SP`，和数据段寄存器`DS:[BX]`，这么组织程序内存布局天然符合CPU的设计

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

## 七、更灵活的定位内存地址的方法

**and 和 or 指令**

and 和 or指令分别是按位与和按位或操作

**db，定义字节型数据**

例如，`db 'unIX'`，等同于`db 75H,6EH,49H,58H`

**`[bx+200]`**

bx存储内存地址，`[bx+200]`表示访问bx中的地址再偏移200后得到的内存地址

有几个等价的写法，`200[bx]`，`[bx].200`

### SI 和 DI 寄存器

si 和 di的作用和bx类似，但si 和 di 不能拆成两个8位寄存器来使用

有了si和di，可以使用以下这种更灵活的方式访问内存

```asm
mov ax, [bx+200+si]

mov ax, [200+bx+si]

mov ax, 200 [bx] [si]

mov ax, [bx] .200 [si]

mov ax, [bx] [si].200
```

## 八、数据处理的两个基本问题

(1)处理的数据在什么地方?
(2)要处理的数据有多长?

### bx,si,di,bp

8086 cpu中，只有这四个寄存器可以用来访存，即使用`[xxx]`这种形式的写法

### 汇编中数据位置的表达

1. 立即数：直接在汇编指令中给出的字面值数据
2. 寄存器
3. 段地址和编译地址：`[bx]`，`ds:[bx]`

### 寻址方式

1. 直接寻址：`[200]`，地址以字面值的方式提供
2. 寄存器间接寻址：`[bx]`
3. 寄存器相对寻址：`[bx+200]`，bx加上一个字面值
4. 基址变址寻址：`[bx+si]`
5. 相对基址变址寻址：`[bx+si+200]`

### 指令要处理的数据有多长

汇编处理的基本单位是字节（byte）或字（word）

通过寄存器名字可以区分字节或字，ax代表字，al和ah代表字节

例如`mov ax ds:[0]`是字访存操作，而`mov al ds:[0]`是一个字节访存操作

可以使用`word ptr`或`byte ptr`明确指定访存单位是字还是字节

例如,下面的指令中,用word ptr指明了指令访问的内存单元是一个字单元。

```asm
mov word ptr ds: [0],1
inc word ptr [bx]
inc word ptr ds: [0]
add word ptr [bx],2
```

下面的指令中,用byte ptr指明了指令访问的内存单元是一个字节单元。

```asm
mov byte ptr ds: [0],1
inc byte ptr [bx]
inc byte ptr ds: [0]
add byte ptr [bx],2
```

### div指令

div是除法指令

现代编译器很少使用除法指令，因其性能比较差

被除数的长度是除数的两倍，结果分为商和余数

### 伪指令dd

dd用来定义双字（dword）

### dup

用于批量定义数据，用法如下：

`db 3 dup (0,1,2)`，定义了9个字节，也就是(0,1,2)重复三次
`db 3 dup ('abc', 'ABC')`，定义了18个字节

## 九、转移指令

能够修改CS和IP的指令称为转移指令

8086 CPU的转移指令分为以下几类。

1. 无条件转移指令(如:jmp)
2. 条件转移指令
3. 循环指令(如:loop)
4. 过程
5. 中断

### offset操作符

offset操作符由编译器处理，作用是识别标号的偏移地址

例如

```asm
assume cs : codesg

codesg segment

start:mov ax, offset start ;相当于mov ax,0

    s:mov ax, offset s ;相当于mov ax,3

codesg ends

end start
```

注意，这里是获取地址，不是去根据地址访存

### 各种jmp指令

**jmp短转移和就近转移**

`jmp short 标号` 和 `jmp near ptr 标号`

这两个指令都是跳转到标号所在指令

`jmp short`实际上是IP+8位位移，对IP的修改范围为-128~127

`jmp near ptr`实际上是IP+16位位移

**在实际的机器码中，这两个指令中并没有目的地址，只是给IP增加一个偏移量**

**带转移目的地址的jmp指令**

`jmp far ptr 标号`是段间转移指令，也叫远转移，会使用标号所在的地址修改CS:IP寄存器，生成的机器码中会包含目标地址

**转移地址在寄存器中的jmp指令**

`jmp 寄存器`，前面讲的jmp命令就是这种

**转移地址在内存中的jmp指令**

`jmp word ptr 内存地址`，段内转移

`jmp dword ptr 内存地址`，段间转移

### jcxz，有条件转移指令

`jcxz 标号`

jcxz实际上是一个短转移指令

当cx为0时跳转到标号，否则什么都不做

### loop指令

loop指令本质上也是个短转移指令

## 十、call 和 ret 指令

这两个指令都是转移指令，会修改cs和ip

### ret 和 retf

ret 和 retf 一个是近转移，一个是远转移

他们会利用栈中的数据作为转移地址，并对栈做出栈操作

ret只会pop一个数据，作为ip的值

retf会pop两个数据，作为cs:ip的值

### call

call指令会将当前的ip 或 cs和ip 压栈

**根据位移进行转移的call指令**

`call 标号`，将当前的ip压栈后，跳转到标号处执行

**带目的地址的call指令**

`call far ptr 标号`，将当前的cs和ip压栈，然后转移到标号处

**转移地址在寄存器中的call指令**

`call 寄存器`

**转移地址在内存中的call指令**

`call word ptr 内存地址`, 段内转移

`call dword ptr 内存地址`，段间转移

### call 和 ret 配合使用实现函数调用

```asm
assume cs : code
code segment
main:

    ...

    call sub1           ;调用子程序 sub1

    mov ax, 4c00h
    int 21h

sub1:                   ;子程序 sub1 开始

    ...
    call sub2           ;调用子程序 sub2
    ...
    ret
sub2:                   ;子程序 sub1 开始
    ...
    ret
codes ends
end main
```

### 乘法指令mul

两个相乘的数长度必须一致，要么都是8位，要么都是16位

如果是8位，一个数默认放在al中，另一个数在其他寄存器或内存中，结果存放在ax中

如果是16位，一个数默认放在ax中，另一个数在其他寄存器或内存中，结果高位默认放在dx中，低位放在ax中

语法：

```asm
mul reg
mul 内存单元
```

### 参数和结果传递问题

参数比较少的情况下，可以用寄存器传递参数，否则，可以用栈传递参数

### 寄存器冲突问题

被调用函数和调用函数可能会使用相同的寄存器，如何解决这种冲突？

在调用函数之前，把当前用到的寄存器保存到栈中

所以，一个子函数调用的标准框架应该是以下形式

```asm
子程序开始:  子程序用到的寄存器入栈
            子程序逻辑
            子程序用到的寄存器出栈
            返回
```

## 标志寄存器

flag寄存器是按位存储的

各标志的作用

- ZF（零标志位，Zero Flag）：
  - 当运算结果为0时，ZF=1；否则ZF=0
  - 例如：执行 `sub ax, ax` 后，ZF=1

- PF（奇偶标志位，Parity Flag）：
  - 当运算结果的低8位中1的个数为偶数时，PF=1；否则PF=0
  - 例如：结果为00000011B（两个1，偶数），PF=1

- SF（符号标志位，Sign Flag）：
  - 当运算结果为负数时，SF=1；否则SF=0
  - SF等于运算结果的最高位
  - 例如：结果为10000001B，最高位为1，SF=1

- CF（进位标志位，Carry Flag）：
  - 无符号运算时，当产生进位或借位时，CF=1；否则CF=0
  - 例如：两个8位数相加产生第9位进位时，CF=1

- OF（溢出标志位，Overflow Flag）：
  - 有符号运算时，当结果超出有效范围时，OF=1；否则OF=0
  - 例如：127+1=128，对于8位有符号数溢出，OF=1

**和flag相关指令**

- adc：进位加法指令
- sbb：借位减法指令
- cmp：比较指令

**和flag相关的条件转移指令**

| 指令 | 含义         | 检测的相关标志位        |
|------|--------------|-----------------------|
| je   | 等于则转移   | zf=1                   |
| jne  | 不等于则转移 | zf=0                   |
| jb   | 低于则转移   | cf=1                   |
| jnb  | 不低于则转移 | cf=0                   |
| ja   | 高于则转移   | cf=0 且 zf=0           |
| jna  | 不高于则转移 | cf=1 或 zf=1           |

**DF标志位和串传送指令**

DF是方向标志位，在串处理指令中,控制每次操作后si、di的增减。

**pushf 和 popf**

pushf是把标志寄存器压栈，popf是把标志值出栈并保存到标志寄存器中
