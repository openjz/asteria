---
title: "games101 五、材质"
date: 2025-11-03T13:47:19+08:00
draft: false

tags: ["图形"]
categories: ["编程"]
---

## Diffuse / Lambertian Material

对于漫反射材质，我们认为一束入射光线会向四面八方反射，根据前面所学内容，其中某一束反射光和入射光能量存在一个比例 $f_r$，在光线追踪中，我们将其称为 brdf。

![diffuse-material.png](/img/games101-notes/diffuse-material.png)

光线追踪的渲染方程体现出一种入射光和反射光的能量关系，**一束出射光 $L_o(\omega_o)$ 是所有入射光 $L_i(\omega_i)$ 经过材质反射后的总和**（注意，这里所说的出射光不是某个入射光的反射分量，而是所有入射光的积分总和）：

$$
L_o(\omega_o)=\int_{H^2} f_r\,L_i(\omega_i)\,\cos\theta_i\,\mathrm{d}\omega_i
$$

假设入射光和反射光都是均匀的，这意味着 $L_i(\omega_i)$ 和 $f_r$ 都是常数，那么上式可以简化为：

$$
L_o(\omega_o)=f_r\,L_i\int_{H^2} \cos\theta_i\,\mathrm{d}\omega_i = \pi\,f_r\,L_i
$$

当一束入射光能量和反射光能量相等时，意味着入射光和出射光能量守恒，材质完全不吸收能量，即，

$$\pi\,f_r = 1 \implies f_r = \frac{1}{\pi}$$

我们可以定义一个反射率 $\rho$（albedo），范围为 0~1，体现材质反射多少光，$\rho=1$ 表示完全反射，$\rho=0$ 表示完全吸收，那么，最终的漫反射 brdf 定义为：

$$f_r = \frac{\rho}{\pi}$$

如果 $\rho$ 是一个三通道的颜色值（三个 0~1 范围内的值），则可以定义不同颜色的 brdf，这就是漫反射材质的定义。

## Glossy Material

不完全是镜面反射，也不完全是漫反射，比如一个磨砂的金属表面。
