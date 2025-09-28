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
（Diffuse coefficient），为1时表示完全反射，亮度最亮，为0时表示完全吸收，亮度最暗，当它为向量时，表示的就是颜色系数。

由于漫反射均匀地向各个方向反射，所以不管从哪个方向观测，看到的颜色都是一样的。

### 高光（Specular Highlight）

只有当观察方向和镜面反射方向接近时，才会看到高光，因此光照强度（Intensity）与观察方向有关。

观察方向和镜面反射方向接近也也意味着半程向量 $\vec{h}$ 和法线方向接近，半程向量是指光线入射方向和观察方向的角平分线方向。

$$\vec{h} = \frac{\vec{l} + \vec{v}}{|\vec{l} + \vec{v}|}$$

高光的反射公式为：

$$L_s = k_s \frac{I}{r^2} \max(0, \vec{h} \cdot \vec{n})^{p}$$

其中，$\vec{h} \cdot \vec{n}$ 为 半程向量和法线的夹角余弦 $\cos{\alpha}$，$k_s$ 为高光系数（Specular coefficient），$p$ 是为了加快 $\cos{\alpha}$ 的衰减，$p$ 的值较大时，夹角 $\alpha$ 稍微大一点，$\cos{\alpha}$ 的值就会降低很多，高光就会衰减很快，体现在视觉上就是高光比较集中。

Blinn-Phong 模型将光线接收项 $\vec{l} \cdot \vec{n}$ 简化掉了。

### 环境光（Ambient Light）

环境光来自四面八方，我们假任何一个点接收到的环境光永远相同。

$$L_a = k_a I_a$$

$I_a$ 为环境光强度（Ambient Intensity），是一个恒定值，$k_a$ 为环境光系数（Ambient coefficient）。

### 合起来

将三种光照模型合起来：

$$L = L_a + L_d + L_s$$

## 着色频率（Shading Frequency）

着色频率研究的是如何让渲染结果更精细，更平滑，比如，一个球体实际上是由很多三角形组成的，如果每个三角形只计算一个着色点，那么渲染出来的球体就会有棱角，为了解决这个问题，我们可以增加着色点的数量，比如在每个三角形内部进行插值计算，以提高着色频率，这样就能让渲染结果更平滑。

**Flat Shading (Face)**

一个三角形面只有一个法线，把三角形面视为一个平坦的平面。

**Gouraud Shading (Vertex)**

求出几个顶点的法线，计算出顶点的颜色，然后在三角形面内进行颜色插值。

**Phong Shading (Pixel)**

注意这个并不是Blinn-Phong反射模型。

求出几个顶点的法线，在三角形面内进行法线插值，然后计算出每个像素点的颜色。

### 如何计算顶点的法线？

对顶点所在面的法线进行平均。

$$
\vec{n}_v = \frac{\sum_{i=1}^{k} \vec{n}_i}{|\sum_{i=1}^{k} \vec{n}_i|}
$$

### 如何对法线插值？

Barycentric interpolation（重心插值）

## 实时渲染管线（Real-time Rendering Pipeline）

1. Vertex Processing，将顶点从模型空间变换到屏幕空间（MVP变换）
2. Triangle Processing，将顶点划分为一个个三角形
3. Rasterization，光栅化，将三角形离散化为一个个采样点（Fragments），抗锯齿
4. Fragment Processing，根据采样结果对每个像素进行着色，深度测试 / 可见性测试
5. Framebuffer Operations

着色（Shading）主要发生在Vertex Processing 和 Fragment Processing，控制着色的程序叫做 Shader。

图形管线运行在GPU上，充分利用GPU的并行计算能力。

### Shader

Shader 需要用硬件上执行的语言来编写，比如 GLSL、HLSL 等。

Shader 只需要关心单个顶点或像素的着色，不需要写循环等控制结构。

Shader 分为两种：

- Vertex Shader，顶点着色器
- Fragment Shader，片段着色器/像素着色器

## 纹理映射（Texture Mapping）

纹理是对表面上的每个点赋予一个属性。

纹理映射是把一张二维的图片映射到三维物体表面上的过程，纹理上的每一个点都要和物体表面的一个**顶点**对应。

纹理上的坐标系通常称为uv坐标系，u表示水平方向，v表示垂直方向。

Tilable texture（可平铺纹理），纹理在上下左右方向上重复使用的时候，起到一种无缝衔接的效果。

### 重心坐标插值（Barycentric Coordinates Interpolation）

纹理映射只规定了三维顶点和二维纹理坐标之间的映射关系，而对三角形面内的某一点来说，它的纹理坐标需要通过重心坐标插值来计算。

同样，前面讲着色频率的时候也提到了一种重心坐标插值方法，用于对法线插值。

