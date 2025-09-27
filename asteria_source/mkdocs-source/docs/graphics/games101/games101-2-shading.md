---
title: "games101-2-着色"
date: 2025-09-20T15:26:46+08:00
draft: false

tags: ["图形"]
categories: ["编程"]
---

## 着色（Shading）

根据不同材质和光照条件，绘制物体的颜色，这个过程叫着色（Shading）。

着色是作用于一个个着色点（shading point）的。

## Blinn-Phong 反射模型（Blinn-Phong Reflectance Model）

1. Specular highlight（镜面高光）
2. Diffuse reflection（漫反射）
3. Ambient reflection（环境光反射）

### shading定义

![shading-defs](/img/games101-notes/shading-defs.png)

- Viewer direction $\vec{v}$，观察者方向向量
- Surface normal $\vec{n}$，表面法线向量
- Light direction $\vec{l}$，光源方向向量
- Surface parameters，表面材质参数
  - color
  - Shininess

上面这些向量都是单位向量。

Shading考虑的是，在不同的光照和表面材质的作用下，表面上每个点的颜色是怎样的。

Shading只考虑一个物体自己和光线的交互，不考虑物体之间的相互影响，如阴影（Shadow）、反射（Reflection）等。

### 漫反射（Diffuse Reflection）

漫反射模拟光线照射到粗糙表面上的效果。

漫反射的入射光线会均匀地向各个方向反射。

**考虑光线接收**

Lambert的余弦定律（Lambert's Cosine Law）：

假设入射光线是平行的，物体表面的法线和入射光线夹角越大，单位表面接收到的光就越少，用 $\theta$ 表示入射光线和法线的夹角，$cos\theta=\vec{l} \cdot \vec{n}$。

**考虑光线发射**

有一个点光源，我们可以以光源为中心，画出多个半径不同的球面，同一个球面上每个点的光照强度相同，不同球面的总光照强度相同，因此球面上的单个点的光照强度与距离光源的距离有关，距离越远强度越低。

定义 $I$ 为半径为1的球面上某一点的光照强度（Intensity），球面总光照强度为 $4\pi I$，那么距离光源 $r$ 处的一点上光照强度为 $I/r^2$。

**漫反射公式**

由此可得一个shading point上的漫反射公式：

$$L_d = k_d \frac{I}{r^2} \max(0, \vec{l} \cdot \vec{n})$$

其中，$k_d$ 为漫反射系数
（Diffuse coefficient），为1时表示完全反射，亮度最亮，为0时表示完全吸收，亮度最暗，当它为向量时，表示的就是颜色。

由于漫反射均匀地向各个方向反射，所以不管从哪个方向观测，看到的颜色都是一样的。