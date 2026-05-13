---
title: "信号与系统学习笔记"
date: 2026-04-30T05:24:27+08:00
draft: false

tags: ["信号与系统"]
categories: ["编程"]
---

参考奥本海姆的信号与系统第二版中译版。

## 基本概念

### 信号的能量和功率

信号与系统中，信号 $x(t)$ 在一段时间内的能量定义为：

$$
\int_{t_1}^{t_2} |x(t)|^2\,dt
$$

除以时间段的长度 $t_2 - t_1$ 就是信号在这段时间内的平均功率。

### 复指数信号

连续时间复指数信号的形式如下：

$$
x(t) = Ce^{at}
$$

有一类重要的复指数信号是以下这种形式：

$$
x(t) = e^{j\omega_0 t}
$$

基波周期 $T_0$ 是信号的最小周期，对应的频率 $ \omega_0 = \frac{2\pi}{T_0} $ 叫基波频率。

**谐波**是指一系列具有公共周期的复指数信号，如下所示：

$$
\phi_k(t)=e^{jk\omega_0 t},\quad k=0,\pm1,\pm2,\ldots
$$

离散时间复指数信号的形式如下：

$$
x[n] = C\alpha^{n}
$$

或

$$
x[n] = Ce^{\beta n}
$$

有一类重要的复指数信号是以下这种形式：

$$
x[n] = e^{j\omega_0 n}
$$

**离散时间复指数信号的频率具有周期性**

频率为 $\omega_0 + 2k\pi$ 的一系列信号是完全相同的，它们的基波频率都是 $\omega_0$。

$$
e^{j(\omega_0 + 2k\pi)n} = e^{j2k\pi n}e^{j\omega_0 n} = e^{j\omega_0 n}
$$

也就是说，离散时间复指数信号的频率只能在 $[0, 2\pi)$ 这个范围内变化，超出这个范围的频率会被映射回这个范围内，0 是最小频率，$\pi$ 是最大频率，从 0 到 $\pi$ 频率越来越大，从 $\pi$ 到 $2\pi$ 频率越来越小。

**离散时间复指数信号也存在谐波，由于上面提到的性质，当谐波公共周期为 N 时，一共有 N 个不同的复指数信号**。

**欧拉公式**

$$
e^{j\omega_0 t}=\cos\omega_0 t+j\sin\omega_0 t
$$

$$
A\cos(\omega_0 t+\phi)=\frac{A}{2}e^{j\phi}e^{j\omega_0 t}+\frac{A}{2}e^{-j\phi}e^{-j\omega_0 t}
$$

### 时不变性

时不变性是一种基本的系统特性，指的是系统的特性不随时间改变，一个输入信号，如果在不同的时间点输入，系统的响应是一样的。

信号与系统一般是这么描述系统的输出和输入之间关系的，用离散系统举例，输入信号是一个序列，代表在不同时间点的输入值，把序列里面其中一个输入信号单拿出来（比如说在时刻 2 有一个冲激信号），对应的系统响应不是一个值，而是一个序列，它想表达的是，系统在某个时刻接收到一个冲激信号后，对这个信号的响应是持续的，可以简单理解为，接收到一个信号，输出一系列响应。

从图像上看，如果一个输入信号改变了时刻，比如说从时刻 2 改变到时刻 3，那么系统的响应的图像相当于整体向右平移了一个单位。

### 线性

线性要求系统满足可加性和齐次性（比例性）。

可加性：如果输入是几个信号的线性组合，那么输出也是这几个信号的响应的线性组合。

$$
\text{如果 } x[n] = a_1 x_1[n] + a_2 x_2[n] \text{，则 } y[n] = a_1 y_1[n] + a_2 y_2[n]
$$

齐次性：如果输入信号乘以一个常数，那么输出也乘以同样的常数。

$$
\text{如果 } x[n] = a x_1[n] \text{，则 } y[n] = a y_1[n]
$$

增量线性系统（Incrementally Linear System）是指系统输出的变化量与输入的变化量成正比，系统本身可能不是线性的，例如：

$$
y[n] = 2x[n] + 3
$$

它不是线性系统，但它满足：

$$
\Delta y[n] = 2 \Delta x[n]
$$

这有点类似于微积分中的函数概念，$y = 2x+3$ 也不是线性函数，它属于仿射函数，但它的增量是线性的，从函数图像上看，像是被整体抬高了 3 个单位。

## 离散时间线性时不变系统：卷积和

卷积和这种形式是把离散系统的每个输入信号的响应叠加起来的结果。

### 用脉冲表示离散时间信号

一个离散时间信号序列，可以表示为一系列脉冲信号的叠加。

$$
x[n] = \sum_{k=-\infty}^{+\infty} x[k]\delta[n-k]
$$

### 线性系统

先看任意线性系统（可能不是时不变系统），任意一个线性系统都能表现为以下形式（注意，这不是卷积和）：

$$
y[n] = \sum_{k=-\infty}^{+\infty} x[k] h_k[n]
$$

$y[n]$ 代表输出信号序列，$x[n]$ 代表输入信号序列，$x[k]$ 是第 $k$ 个输入信号，$h_k[n]$ 是系统对 $x[k]$ 的响应（**注意，$x[k]$ 是其中一个输入信号，而对应的响应 $h_k[n]$ 是一系列信号**，信号与系统中对输入和响应间关系的描述方式参考前面“时不变性”一节）。

举个例子，下图是一个输入序列 $x[n]$：

![/img/signals-and-systems/xn.png](/img/signals-and-systems/xn.png)

其中，-1、0、1 三个时刻的输入信号分别是 $x[-1]$、$x[0]$、$x[1]$，对应的响应如下图所示：

![/img/signals-and-systems/hns.png](/img/signals-and-systems/hns.png)

每个输入信号 $x[k]$ 和对应的响应 $h_k[n]$ 的乘积如下图所示：

![/img/signals-and-systems/xk-hkn.png](/img/signals-and-systems/xk-hkn.png)

最终的输出信号 $y[n]$ 是所有输入信号和对应响应的乘积的叠加，如下图所示：

![/img/signals-and-systems/xn-yn.png](/img/signals-and-systems/xn-yn.png)

### 线性时不变系统

（看不懂可以先看前面的“线性系统”一节以及“时不变性”一节的内容）

对于线性时不变系统，系统对输入信号的响应不随时间改变，因此 $h_k[n]$ 可以简化为 $h[n-k]$，即，$h[n]$的图像仅仅是在坐标轴向右平移了 $k$ 个单位。

线性时不变系统可以表示为以下形式：

$$
y[n] = \sum_{k=-\infty}^{+\infty} x[k] h[n-k]
$$

$$
h[n] = h_0[n]
$$

$y[n]$ 叫做**卷积和**，$h[n]$ 是信号 0 的响应，$x[k]$ 都是冲激信号，$h[n]$ 是系统对冲激信号的响应。

$y[n]$ 右侧的运算称为卷积运算，记为 $y[n] = x[n] * h[n]$ 

（后面的内容会提到，也可以将系统用单位阶跃响应的卷积和表示）

例如，下图是一个线性时不变系统：

![/img/signals-and-systems/lti.png](/img/signals-and-systems/lti.png)

线性时不变系统之所以能表示成输入信号和响应的乘积和的形式，是因为系统是线性的，因此当一个冲激强度大于 1 时，系统的响应也会成比例地增加，形式上也就是 $x[k] h[n-k]$。

### 来看看 Y[k] 到底在计算什么

现在我们有了卷积和公式，我们要计算某一时刻的系统输出信号 $y[k]$。

假设在时刻 0、1、2 有三个冲激信号输入，我们要计算时刻 2 的输出，将 k 代入卷积和公式：

$$
y[2] = x[0] h[2] + x[1] h[1] + x[2] h[0]
$$

看明白了吗？$y[2]$ 计算的是所有三个输入信号在时刻 2 对系统产生的影响的叠加。

对 $x[0]$ 来讲，它对系统时刻 2 产生的影响是相对它自身时刻 2 的响应 $h[2]$，对 $x[1]$ 来讲，它对系统时刻 2 产生的影响是相对它自身时刻 1 的响应 $h[1]$，对 $x[2]$ 来讲，它对系统时刻 2 产生的影响是相对它自身时刻 0 的响应 $h[0]$。

## 连续时间线性时不变系统：卷积积分

$$
y(t)=\int_{-\infty}^{+\infty} x(\tau)h(t-\tau)d\tau
$$

## 用微分方程和差分方程描述因果线性时不变系统

### 线性常系数微分方程

一个 N 阶线性常系数微分方程可以表示为以下形式：

$$
\sum_{k=0}^{N} a_k \frac{d^k y(t)}{dt^k} = \sum_{k=0}^{M} b_k \frac{d^k x(t)}{dt^k}
$$

$y(t)$ 的解由通解和特解两部分构成，通解是对应的齐次方程的解：

$$
\sum_{k=0}^{N} a_k \frac{d^k y(t)}{dt^k} = 0
$$

这个方程的解称为系统的自然响应。

求特解的通用方法是找一个受迫响应，即一个与输入信号 $x(t)$ 形式相同的信号，代入方程中求解。

最后，再结合系统的初始条件，求出通解中的常数项，得到完整的系统响应 $y(t)$。

### 线性常系数差分方程

一个 N 阶线性常系数差分方程可以表示为以下形式：

$$
\sum_{k=0}^{N} a_k y[n-k] = \sum_{k=0}^{M} b_k x[n-k]
$$

## 奇异函数

奇异函数是指在某个时刻发生突变的函数。

单位冲激函数 $\delta(t)$ 是一种奇异函数，它的面积为 1 ，它的值用它的面积来表示。

单位冲激偶函数也是一种奇异函数，它是单位冲激函数的导数，一次导数用 $u_1(t)$ 表示。

$$
\frac{dx(t)}{dt} = x(t) * u_1(t)
$$

$$
\frac{d^2 x(t)}{dt^2}=\frac{d}{dt}\left(\frac{dx(t)}{dt}\right)=x(t)*u_1(t)*u_1(t)
$$

$$
u_k(t)=\underbrace{u_1(t)*\cdots*u_1(t)}_{k\text{次}}
$$

单位冲激偶的面积为 0。

## 连续时间周期信号的傅里叶级数表示

### 傅里叶级数

$x(t)$ 是周期信号，T 是 $x(t)$ 的基波周期（也就是最小周期），$\omega_0$ 是 $x(t)$ 的基波频率，那么，

$$
x(t) = \sum_{k=-\infty}^{+\infty} a_k e^{jk\omega_0 t}
= \sum_{k=-\infty}^{+\infty} a_k e^{jk(2\pi/T)t}
$$

$$
a_k = \frac{1}{T}\int_T x(t)e^{-jk\omega_0 t}\,dt
= \frac{1}{T}\int_T x(t)e^{-jk(2\pi/T)t}\,dt
$$

第一个公式叫做综合公式，第二个公式叫做分析公式，$a_k$ 是傅里叶级数系数，也叫 $x(t)$ 的频谱系数。

$x(t)$ 可以表示为一系列复指数信号的叠加，**这些复指数信号是一系列谐波信号**，即他们有公共的周期 T（T 是这些信号基波周期的最小公倍数），每个复指数信号的基波频率是 $k\omega_0$，基波周期是 $\frac{2\pi}{k\omega_0}$，其中 $k$ 是整数。

这些复指数信号的形式如下：

$$
\phi_k(t)=e^{jk\omega_0 t}=e^{jk(2\pi/T)t},\quad k=0,\pm1,\pm2,\ldots
$$

其中，K = +N 和 K = -N 的两个信号为一对，叫做 N 次谐波分量，K = 1 和 K = -1 的两个信号叫做基波分量，K = 2 和 K = -2 的两个信号叫做 2 次谐波分量。

$a_0$ 是 $x(t)$ 的直流或常数分量，代入 k =0 可得：

$$
a_0=\frac{1}{T}\int_T x(t)\,dt
$$

它是 $x(t)$ 在一个周期内的平均值。

如果 $x(t)$ 是实信号，那么 $a_{-k} = a_k^*$，其中 $a_k^*$ 是 $a_k$ 的复共轭。

### 傅里叶级数的收敛

如果 k 是有限的，那么傅里叶级数可以表示为：

$$
x_N(t)=\sum_{k=-N}^{N} a_k e^{jk\omega_0 t}
$$

此时傅里叶级数和原信号之间存在一个误差：

$$
e_N(t)=x(t)-x_N(t)=x(t)-\sum_{k=-N}^{+N} a_k e^{jk\omega_0 t}
$$

用一个周期内误差的能量来衡量这个误差：

$$
E_N=\int_T |e_N(t)|^2\,dt
$$

如果 N 趋近于无穷大时，$E_N$ 趋近于 0，那么就说傅里叶级数收敛于 $x(t)$，或者说 $x(t)$ 可以由其傅里叶级数表示。

满足以下几个条件，信号 $x(t)$ 就可以由其傅里叶级数表示，这些条件也叫**狄利克雷条件**（狄里赫利条件）。

**条件 1**

在任意周期内，$x(t)$ 必须可积，即：

$$
\int_T |x(t)|\,dt < \infty
$$

**条件 2**

在任意有限区间内，$x(t)$ 只能有有限个极值点。

**条件 3**

在任意有限区间内，$x(t)$ 只能有有限个不连续点，并且每个不连续点上函数都是有限值。

### 连续时间傅里叶级数的性质

**线性**

$x(t)$ 和 $y(t)$ 是两个周期信号，它们的傅里叶级数系数分别是 $a_k$ 和 $b_k$，这个描述可以表示为以下形式：

$$
x(t) \xleftrightarrow{\mathcal{FS}} a_k
$$

$$
y(t) \xleftrightarrow{\mathcal{FS}} b_k
$$

由它们的线性组合得到的新信号 $z(t)$ 的傅里叶级数系数是它们各自系数的线性组合：

$$
z(t)=Ax(t)+By(t)\xleftrightarrow{\mathcal{FS}} c_k=Aa_k+Bb_k
$$

**时移**

对于以下周期信号：

$$
x(t) \xleftrightarrow{\mathcal{FS}} a_k
$$

当他在时间上移位时，新信号的傅里叶级数系数的模不变，相位发生改变：

$$
x(t-t_0)\xleftrightarrow{\mathcal{FS}} e^{-jk\omega_0 t_0}a_k = e^{-jk(2\pi/T)t_0}a_k
$$

新信号的傅里叶级数系数为：

$$
b_k=\frac{1}{T}\int_T x(t-t_0)e^{-jk\omega_0 t}\,dt
$$

$$
|b_k|=|a_k|
$$

**时间反转**

如果，

$$
x(t)\xleftrightarrow{\mathcal{FS}} a_{k}
$$

那么，

$$
x(-t)\xleftrightarrow{\mathcal{FS}} a_{-k}
$$

此外，由此还可以得出，如果 $x(t)$ 是偶函数，那么 $a_k = a_{-k}$，如果 $x(t)$ 是奇函数，那么 $a_k = -a_{-k}$。

**时域尺度变换**

$$
x(\alpha t)=\sum_{k=-\infty}^{+\infty} a_k e^{jk(\alpha\omega_0)t}
$$

**相乘**

如果，

$$
x(t) \xleftrightarrow{\mathcal{FS}} a_k
$$

$$
y(t) \xleftrightarrow{\mathcal{FS}} b_k
$$

那么，

$$
x(t)y(t)\xleftrightarrow{\mathcal{FS}} h_k=\sum_{l=-\infty}^{\infty} a_l b_{k-l}
$$

等式右侧是 $a_k$ 和 $b_k$ 的卷积和。

**共轭及共轭对称**

如果对一个信号取它的共轭复数，那么，

$$
x(t)\xleftrightarrow{\mathcal{FS}} a_{k}
$$

$$
x^*(t)\xleftrightarrow{\mathcal{FS}} a_{-k}^*
$$

当 $x(t)$ 是实信号时，$a_{-k} = a_k^*$，$a_0$ 为实数，$|a_{-k}| = |a_k|$。

如果 $x(t)$ 为实偶信号，$a_k = a_{-k} = a_k^*$。

### 连续时间周期信号的帕斯瓦尔定理

$$
\frac{1}{T}\int_T |x(t)|^2\,dt=\sum_{k=-\infty}^{+\infty}|a_k|^2
$$

等式左侧表示信号在一个周期内的平均功率，右侧的 $|a_k|^2$ 是信号第 k 次谐波的平均功率。

## 离散时间周期信号的傅里叶级数表示

### 傅里叶级数

信号 $x[n]$ 是周期信号，基波周期为 N。

信号可以表示为以下谐波信号的线性组合：

$$
\phi_k[n]=e^{jk\omega_0 n}=e^{jk(2\pi/N)n},\quad k=0,\pm1,\pm2,\cdots
$$

由于离散谐波信号只有 N 个不同的信号，因此离散时间周期信号的傅里叶级数表示为以下形式：

$$
x[n] = \sum_{k=\langle N \rangle} a_k e^{jk\omega_0 n}
= \sum_{k=\langle N \rangle} a_k e^{jk(2\pi/N)n}
$$

$$
a_k = \frac{1}{N} \sum_{n=\langle N \rangle} x[n] e^{-jk\omega_0 n}
= \frac{1}{N} \sum_{n=\langle N \rangle} x[n] e^{-jk(2\pi/N)n}
$$

$k=\langle N \rangle$ 表示取 N 个连续整数，例如，$k=3,4,...,N+2$。

$k=\langle N \rangle$ 和 $n=\langle N \rangle$ 不需要取同一组数。

### 离散时间周期信号的傅里叶级数性质

**相乘**

相乘性质和连续时间周期信号的傅里叶级数性质类似，唯一的区别是，离散时间周期信号的傅里叶级数系数的卷积和是有限项的，而连续时间周期信号的傅里叶级数系数的卷积和是无限项的。

如果，

$$
x[n]\xleftrightarrow{\mathcal{FS}} a_k
$$

$$
y[n]\xleftrightarrow{\mathcal{FS}} b_k
$$

那么，

$$
x[n]y[n]\xleftrightarrow{\mathcal{FS}} d_k=\sum_{l=\langle N \rangle} a_l b_{k-l}
$$

这种形式的卷积叫做周期卷积，求和变量是无限的那种卷积是非周期卷积。

**一次差分**

如果，

$$
x[n]\xleftrightarrow{\mathcal{FS}} a_k
$$

那么，

$$
x[n]-x[n-1]\xleftrightarrow{\mathcal{FS}} (1-e^{-jk(2\pi/N)})a_k
$$

### 离散时间周期信号的帕斯瓦尔定理

$$
\frac{1}{N}\sum_{n\in\langle N\rangle}|x[n]|^2=\sum_{k\in\langle N\rangle}|a_k|^2
$$

左边是信号在一个周期内的平均功率，右边的 $|a_k|^2$ 是信号的第 k 次谐波的平均功率。

## 线性时不变系统对复指数信号的响应

（教材上这一节本来在傅里叶级数之前，这里为了和下一节连贯，将其放到这里）

如果系统对信号的的输出响应仅仅是一个常数乘以输入，那么这个输入信号叫做系统的**特征函数**，常数叫做系统的**特征值**。

**复指数信号就是线性时不变系统的特征函数**。

考虑一个连续线性时不变系统，系统对冲激信号的响应为 $h(t)$，输入信号是一个复指数信号 $x(t) = e^{st}$，系统的输出信号为：

$$
y(t) = H(s)e^{st}
$$

其中，H(s) 是一个复常数，

$$
H(s) = \int_{-\infty}^{+\infty} h(\tau)e^{-s\tau}d\tau
$$

对于离散线性时不变系统，系统对冲激信号的响应为 $h[n]$，输入信号是一个复指数信号 $x[n] = z^{n}$，系统的输出信号为：

$$
y[n] = H(z)z^{n}
$$

其中，H(z) 是一个复常数，

$$
H(z) = \sum_{k=-\infty}^{+\infty} h[k]z^{-k}
$$

$H(s)$ 和 $H(z)$ 叫做该系统的**系统函数**。

## 傅里叶级数与线性时不变系统

对于连续时间信号与系统，考虑 s 为纯虚数的情况，具有 $s = j\omega$ 形式的系统函数称为系统的**频率响应**。

$$
H(j\omega)=\int_{-\infty}^{+\infty} h(t)e^{-j\omega t}\,dt
$$

对于离散时间信号与系统，考虑 z 的模为1，即在单位圆上的情况，具有 $z = e^{j\omega}$ 形式的系统函数称为系统的频率响应。

$$
H(e^{j\omega})=\sum_{n=-\infty}^{+\infty} h[n]e^{-j\omega n}
$$

对于连续时间系统，令 $x(t)$ 为一个周期信号，其傅里叶级数表示为：

$$
x(t) = \sum_{k=-\infty}^{+\infty} a_k e^{jk\omega_0 t}
$$

假如 $x(t)$ 为输入信号，系统的单位冲激响应为 $h(t)$，系统的输出信号为：

$$
y(t) = \sum_{k=-\infty}^{+\infty} a_k H(jk\omega_0) e^{jk\omega_0 t}
$$

$y(t)$ 是周期的，周期和 $x(t)$ 相同。

也就是说，**线性时不变系统的作用就是改变输入信号的每一个傅里叶系数，给系数乘上响应频率点上的频率响应值**。

对于离散时间系统，令 $x[n]$ 为一个周期信号，其傅里叶级数表示为：

$$
x[n] = \sum_{k=\langle N \rangle} a_k e^{jk\omega_0 n}
$$

假如 $x[n]$ 为输入信号，系统的单位冲激响应为 $h[n]$，系统的输出信号为：

$$
y[n]=\sum_{k=\langle N\rangle} a_k H\!\left(e^{j2\pi k/N}\right)e^{jk(2\pi/N)n}
$$

$y[n]$ 是周期的，周期和 $x[n]$ 相同。

## 滤波

滤波的目的是要改变信号中各频率分量的相对大小，或者消除某些频率分量。

滤波器就相当于是一个线性时不变系统。

比如微分滤波器，$y(t) = \frac{dx(t)}{dt}$，当 $x(t)$ 为 $e^{j\omega t}$ 时，$y(t) = j\omega e^{j\omega t}$，因此它的频率响应为 $H(j\omega) = j\omega = \omega e^{j\pi/2}$，频率响应的模是 $|\omega|$，相位是 $\pi/2$ 或 $-\pi/2$（分别对应 $\omega > 0$ 和 $\omega < 0$）。

微分滤波器会增大高频信号的强度，在图像处理中可以用来边缘增强。

低通滤波器：保留低频信号，抑制高频信号。

高通滤波器：保留高频信号，抑制低频信号。

带通滤波器：保留某个频率范围内的信号，抑制其他频率的信号，边界频率叫做截止频率，保留的频率范围叫做通带，抑制的频率范围叫做阻带。

如果是由微分方程或者差分方程描述的系统，如果我们知道系统是线性时不变系统，可以将 $y(t) = H(j\omega)x(t)$ 或 $y[n] = H(e^{j\omega})x[n]$ 代入方程中，将系统的频率响应 $H(j\omega)$ 或 $H(e^{j\omega})$ 求解出来。

## 连续时间傅里叶变换

### 非周期信号的傅里叶变换

傅里叶变换是将非周期信号也表示为傅里叶级数的形式。

对周期信号来说，$a_k$ 和 $\omega$ 是傅里叶级数中某个复指数信号的系数和频率（$\omega = k\omega_0$），如果将 $a_k$ 视为 $\omega$ 的函数，那么每个 $a_k$ 就是这个函数上的一个采样，函数本身的图像相当于是一条包络线。

每个复指数信号的频率间隔 是$\omega_0$，因此，信号的基波周期越长，基波频率越小，采样点就越密集，如下图所示：

![/img/signals-and-systems/ft-mechanism.png](/img/signals-and-systems/ft-mechanism.png)

非周期信号的傅里叶变换是将信号看作一个周期无限长的周期信号，此时，频率间隔 $\omega_0$ 趋近于 0，采样点就变成了连续的，傅里叶级数也就从求和变成了积分。

$$
x(t)=\frac{1}{2\pi}\int_{-\infty}^{+\infty}X(j\omega)e^{j\omega t}\,d\omega
$$

$$
X(j\omega)=\int_{-\infty}^{+\infty}x(t)e^{-j\omega t}\,dt
$$

以上两个公式称为傅里叶变换对，第二个公式叫**傅里叶变换**或傅里叶积分，第一个公式叫**傅里叶逆变换**，这两个公式也叫傅里叶变换的综合公式和分析公式。

傅里叶逆变换将信号 $x(t)$ 表示为无穷个复指数信号的叠加，它们的的频率是连续的，$X(j\omega)\frac{d\omega}{2\pi}$ 是每个频率点上的复指数信号的系数，$X(j\omega)$ 叫做信号 $x(t)$ 的**频谱**。

周期信号的系数 $a_k$ 也能利用傅里叶变换来求，把周期信号的其中一个周期单拿出来，把它视为一个非周期信号（只在单拿出来这个周期上非零，其他地方为零），然后对这个非周期信号进行傅里叶变换，就可以得到周期信号的傅里叶系数 $a_k$，具体关系如下：

$$
a_k=\frac{1}{T}X(j\omega)\Big|_{\omega=k\omega_0}
$$

傅里叶变换的收敛条件和傅里叶级数的收敛条件类似，也是一组狄里赫利条件：

1. $x(t)$ 必须绝对可积，$\int_{-\infty}^{+\infty} |x(t)|\,dt < \infty$
2. $x(t)$ 在任意有限区间内只能有有限个极值点。
3. $x(t)$ 在任意有限区间内只能有有限个不连续点，并且每个不连续点上函数都是有限值。

下一节可以看到，如果在变换过程中使用冲激函数，即使信号 $x(t)$ 不绝对可积，傅里叶变换也能收敛，周期信号的傅里叶变换就是这种情况。

### 周期信号的傅里叶变换

周期信号也能用傅里叶变换来表示，所得到的变换在频域是一系列冲激，冲激的面积对应着周期信号的傅里叶级数系数。

周期信号的 $X(j\omega)$ 是频率上等间隔的一组冲激函数的线性组合：

$$
X(j\omega)=\sum_{k=-\infty}^{+\infty} 2\pi a_k\,\delta(\omega-k\omega_0)
$$

代入傅里叶逆变换公式可得：

$$
x(t)=\sum_{k=-\infty}^{+\infty} a_k e^{jk\omega_0 t}
$$

其实就是周期信号的傅里叶级数表示。

### 连续时间傅里叶变换的性质

**线性性质**：

$$
\text{若}\quad x(t)\xleftrightarrow{\mathcal{F}}X(j\omega)
$$

$$
\text{且}\quad y(t)\xleftrightarrow{\mathcal{F}}Y(j\omega)
$$

$$
\text{则}\quad ax(t)+by(t)\xleftrightarrow{\mathcal{F}}aX(j\omega)+bY(j\omega)
$$

**时移性质**：

$$
\text{若}\quad x(t)\xleftrightarrow{\mathcal{F}}X(j\omega)
$$

$$
\text{则}\quad x(t-t_0)\xleftrightarrow{\mathcal{F}}e^{-j\omega t_0}X(j\omega)
$$

**共轭**：

$$
\text{若}\quad x(t)\xleftrightarrow{\mathcal{F}}X(j\omega)
$$

$$
\text{则}\quad x^*(t)\xleftrightarrow{\mathcal{F}}X^*(-j\omega)
$$

**共轭对称性**：如果 $x(t)$ 是实信号，那么 $X(j\omega)$ 满足共轭对称性：

$$
X(-j\omega)=X^*(j\omega)
$$

**微分与积分**：

$$
\frac{d x(t)}{dt}\xleftrightarrow{\mathcal{F}}j\omega X(j\omega)
$$

$$
\int_{-\infty}^{t} x(\tau)\,d\tau \xleftrightarrow{\mathcal{F}} \frac{1}{j\omega}X(j\omega)+\pi X(0)\delta(\omega)
$$

右边的冲激函数项反映了由积分所产生的直流或平均值。

**时间与频率的尺度变换**：

$$
\text{若}\quad x(t)\xleftrightarrow{\mathcal{F}}X(j\omega)
$$

$$
\text{则}\quad x(at)\xleftrightarrow{\mathcal{F}}\frac{1}{|a|}X\!\left(j\frac{\omega}{a}\right)
$$

其中 a 是个实常数。

$$
x(-t)\xleftrightarrow{\mathcal{F}}X(-j\omega)
$$

$x(t)$ 如果在时间上反转，它的傅里叶变换也反转。

**对偶性**：

这个性质是说，如果一个时域函数由某些特性，这些特性在其傅里叶变换中隐含着别的东西，那么反之亦然。换句话说，上面提到的性质，在频域中也有对应的性质。

$$
-jt\,x(t)\xleftrightarrow{\mathcal{F}}\frac{dX(j\omega)}{d\omega}
$$

$$
e^{j\omega_0 t}x(t)\xleftrightarrow{\mathcal{F}}X\!\big(j(\omega-\omega_0)\big)
$$

$$
-\frac{1}{jt}x(t)+\pi x(0)\delta(t)\xleftrightarrow{\mathcal{F}}\int_{-\infty}^{\omega} x(\eta)\,d\eta
$$

**帕斯瓦尔定理**：

$$
\int_{-\infty}^{+\infty}|x(t)|^2\,dt=\frac{1}{2\pi}\int_{-\infty}^{+\infty}|X(j\omega)|^2\,d\omega
$$

左边是信号 $x(t)$ 的总能量，右边各频率能量的总和，$|X(j\omega)|^2$ 是信号 $x(t)$ 的能谱密度（Energy-density spectrum）。

### 卷积性质

前面提到的线性时不变系统对复指数信号的响应中，介绍了系统的频率响应 $H(j\omega)$ ，站在本章的角度，$H(j\omega)$ 同时也是系统对冲激信号的响应 $h(t)$ 的傅里叶变换。

存在以下规律，

$$
y(t)=h(t)*x(t)\xleftrightarrow{\mathcal{F}}Y(j\omega)=H(j\omega)X(j\omega)
$$

简单来讲，就是时域的卷积对应频域的乘积。

两个级联的线性时不变系统的单位冲激响应是他们各自单位冲激响应的卷积，频率响应是他们各自频率响应的乘积，如图所示：

![/img/signals-and-systems/cascaded-systems.png](/img/signals-and-systems/cascaded-systems.png)

### 相乘性质

这是卷积性质的对偶性质，即时域的乘积对应频域的卷积：

$$
r(t)=s(t)p(t)\leftrightarrow R(j\omega)=\frac{1}{2\pi}\int_{-\infty}^{+\infty} S(j\theta)P\big(j(\omega-\theta)\big)\,d\theta
$$

两个信号相乘，相当于用一个信号去调制另一个信号的幅度，因此信号相乘也叫幅度调制，相乘性质有时候也叫调制性质。

### 线性常系数微分方程的频率响应

考虑前文提到的一个由 N 阶线性常系数微分方程表示的系统：

$$
\sum_{k=0}^{N} a_k \frac{d^k y(t)}{dt^k}=\sum_{k=0}^{M} b_k \frac{d^k x(t)}{dt^k}
$$

我们希望求出系统的频率响应 $H(j\omega)$。

根据卷积性质可得：

$$
H(j\omega) = \frac{Y(j\omega)}{X(j\omega)}
$$

对上面的微分方程两边进行傅里叶变换，最终得到：

$$
H(j\omega)=\frac{Y(j\omega)}{X(j\omega)}=\frac{\sum_{k=0}^{M} b_k (j\omega)^k}{\sum_{k=0}^{N} a_k (j\omega)^k}
$$

## 离散时间傅里叶变换

### 非周期信号的傅里叶变换

对于非周期离散信号 $x[n]$：

$$
x[n]=\frac{1}{2\pi}\int_{2\pi} X(e^{j\omega})e^{j\omega n}\,d\omega
$$

$$
X(e^{j\omega})=\sum_{n=-\infty}^{+\infty}x[n]e^{-j\omega n}
$$

以上两个公式是离散时间傅里叶变换对，$X(e^{j\omega})$ 是信号 $x[n]$ 的频谱。

由于离散时间复指数谐波信号的周期性（在频率上相差 $2\pi$ 的离散时间复指数信号是相同的），因此离散时间傅里叶变换和傅里叶级数一样具有周期性（周期长度为 $2\pi$），逆变换的积分上下限是有限区间。

其周期性如下图所示：

![/img/signals-and-systems/ft-discrete-aperiodic.png](/img/signals-and-systems/ft-discrete-aperiodic.png)

傅里叶变换的收敛条件是，$x[n]$ 必须绝对可和，即 $\sum_{n=-\infty}^{+\infty} |x[n]| < \infty$，逆变换积分上下限是有限的，一般不存在收敛问题。

### 周期信号的傅里叶变换

非周期离散信号的傅里叶变换的图像是一个连续的函数，而周期离散信号的傅里叶变换和周期连续信号的傅里叶变换一样，是频率上等间隔的一组冲激函数的线性组合。

现在考虑一个周期序列 $x[n]$，周期为 $N$，其傅里叶级数为：

$$
x[n]=\sum_{k=\langle N\rangle} a_k e^{jk(2\pi/N)n}
$$

这时，傅里叶变换就是：

$$
X(e^{j\omega})=\sum_{k=-\infty}^{+\infty} 2\pi a_k\,\delta\!\left(\omega-\frac{2\pi k}{N}\right)
$$

其周期性如下图所示：

![/img/signals-and-systems/ft-discrete-periodic.png](/img/signals-and-systems/ft-discrete-periodic.png)

### 离散时间傅里叶变换的性质

**周期性**

$$
X\!\left(e^{j(\omega+2\pi)}\right)=X\!\left(e^{j\omega}\right)
$$

**线性性质**

$$
ax_1[n]+bx_2[n]\xleftrightarrow{\mathcal{F}}aX_1(e^{j\omega})+bX_2(e^{j\omega})
$$

**时移与频移性质**

$$
x[n-n_0]\xleftrightarrow{\mathcal{F}}e^{-j\omega n_0}X(e^{j\omega})
$$

$$
e^{j\omega_0 n}x[n]\xleftrightarrow{\mathcal{F}}X\!\left(e^{j(\omega-\omega_0)}\right)
$$

**共轭与共轭对称性**

$$
x^*[n]\xleftrightarrow{\mathcal{F}}X^*\!\left(e^{-j\omega}\right)
$$

如果 $x[n]$ 是实信号，那么 $X(e^{j\omega})$ 满足共轭对称性：

$$
X(e^{j\omega})=X^*(e^{-j\omega})
$$

**差分与累加**

$$
x[n]-x[n-1]\xleftrightarrow{\mathcal{F}}(1-e^{-j\omega})X(e^{j\omega})
$$

$$
\sum_{m=-\infty}^{n} x[m]\xleftrightarrow{\mathcal{F}} \frac{1}{1-e^{-j\omega}}X(e^{j\omega})+\pi X(e^{j0})\sum_{k=-\infty}^{+\infty}\delta(\omega-2\pi k)
$$

等式右边的冲激串反映了由累加所产生的直流或平均值。

**时间反转**

$$
x[-n]\xleftrightarrow{\mathcal{F}}X(e^{-j\omega})
$$

**时域扩展**
令 k 是一个正整数，定义

$$
x_{\langle k\rangle}[n]=
\begin{cases}
x[n/k], & n\text{为}k\text{的整数倍} \\
0, & n\text{不为}k\text{的整数倍}
\end{cases}
$$

那么

$$
x_{\langle k\rangle}[n]\xleftrightarrow{\mathcal{F}}X(e^{jk\omega})
$$

**频域微分**

$$
n x[n]\xleftrightarrow{\mathcal{F}}j\frac{dX(e^{j\omega})}{d\omega}
$$

**帕斯瓦尔定理**

$$
\sum_{n=-\infty}^{+\infty}|x[n]|^2=\frac{1}{2\pi}\int_{2\pi}|X(e^{j\omega})|^2\,d\omega
$$

左边是信号 $x[n]$ 的总能量，$|X(e^{j\omega})|^2$ 是信号 $x[n]$ 的能量密度谱（Energy-density spectrum）。

**卷积性质**

$$
Y(e^{j\omega})=X(e^{j\omega})H(e^{j\omega})
$$

**相乘性质**

$$
y[n]=x_1[n]x_2[n]\xleftrightarrow{\mathcal{F}}Y(e^{j\omega})=\frac{1}{2\pi}\int_{2\pi} X_1(e^{j\theta})X_2(e^{j(\omega-\theta)})\,d\theta
$$

注意，这里是一个周期卷积。

### 对偶性

![/img/signals-and-systems/ft-duality.png](/img/signals-and-systems/ft-duality.png)

### 线性常系数差分方程的频率响应

$$
\sum_{k=0}^{N} a_k y[n-k]=\sum_{k=0}^{M} b_k x[n-k]
$$

$$
H(e^{j\omega})=\frac{Y(e^{j\omega})}{X(e^{j\omega})}=\frac{\sum_{k=0}^{M} b_k e^{-jk\omega}}{\sum_{k=0}^{N} a_k e^{-jk\omega}}
$$

## 信号与系统的时域和频域特性

线性时不变系统输入输出的傅里叶变换有以下关系：

$$
Y(j\omega)=H(j\omega)X(j\omega)
$$

$H(j\omega)$ 是系统的频率响应，也是系统单位冲激响应的傅里叶变换。

$|H(j\omega)|$ 称为系统的增益（Gain），$\angle H(j\omega)$ 称为系统的相移（Phase Shift）。 

线性相移会造成输入信号的时移，例如：

$$
|H(j\omega)|=1,\quad \angle H(j\omega)=-\omega t_0
$$

$$
y(t)=x(t-t_0)
$$

非线性相移会导致输入信号的每个频率分量会有不同的时移，最终输出一个完全不同的信号。

模为 1 的频率响应叫做全通系统（All-pass system），也就是每个输入频率分量的幅度不变。

**信号与系统的时域和频域特性这一章就是把常见的系统按照数学模型进行分类，总结成一个个通用的模板，以后遇到同样的系统，直接按照对应模板去分析即可**。

**基本上只要把一阶和二阶系统的时域和频域特性掌握好就行了**。
