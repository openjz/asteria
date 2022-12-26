# 渲染管线介绍


## 什么是渲染

广义上的渲染过程，既包括CPU参与部分，也包括GPU参与部分。通过图形API来调用GPU渲染管线，

广义的渲染分为六个步骤

- 应用阶段
- 顶点处理阶段（vertex processing）
- 三角形处理阶段（triangle processing）
- 光栅化（rasterization）
- 片元处理（fragment processing）
- 帧缓冲区操作（framebuffer operation）

## 应用阶段

CPU主导，开发者完全可控，任务是输出需要渲染的图元，图元是绘制到屏幕上的最小几何体，例如点、线、三角形等。

模型信息通过mesh传给GPU，mesh数据存储在顶点上。

## 顶点处理

顶点数据包括坐标、UV、颜色、法线等等。

顶点处理节点把顶点空间上的数据转换为屏幕空间上的数据，3D模型转换为2D图像。

顶点处理阶段有一种可编程渲染管线，叫vertex shader。

shader是指一段用来操作GPU的程序。

local space（本地空间） -> world space（世界空间） -> view space（视图空间） -> clip space（裁剪空间）

这三个过程分别叫modeling transformation、viewing transformation、projection transformation

每个顶点都会调用一次vertex shader。

视图空间指的是相机的视锥空间，从视图空间到裁剪空间，会做一个投影，将视锥挤压成一个立方体，裁减掉立方体之外的东西。vertex shader输出的还是3D数据，这一整个变换也叫MVP变换。

在vertex shader中，我们通常可以做一些顶点操作，比如修改顶点位置（修改模型形状）、逐顶点光照、改变顶点着色等等。

GPU接着会将裁剪空间转换为NDC坐标（标准设备空间坐标），这个过程是一种归一化处理（perspective divide），将坐标变为-1到1之间，然后再将NDC坐标映射到屏幕上（视口映射，viewport mapping）

只有x、y值发生变化，z值不变。（注意，z轴是指向屏幕里面的坐标轴，不是朝上的坐标轴，y轴是朝上的，x轴是左右方向的，z轴是朝屏幕里面的，指的是深度值。）

这就完成了整个顶点处理阶段。
