---
title: "Unity入门笔记"
date: 2022-06-26T10:48:30+08:00
# bookComments: false
# bookSearchExclude: false
tags : 
- "unity"
categories : 
- "游戏"
- "编程"
---

## 参考

1. [unity manual](https://docs.unity3d.com/Manual/)
2. [unity-essentials系列教程](https://learn.unity.com/pathway/unity-essentials)

## 本文约定

**粗体**代表术语

## 编辑器操作

### 场景视图导航

1. **pan（移动视图）**：使用“手”工具，按住鼠标左键拖动视图
2. **zoom（放缩）**：使用鼠标滚轮或按住alt和鼠标右键拖动
3. **orbit（环绕物体）**：按住alt和鼠标左键拖动
5. **focus（聚焦）**：按F聚焦到一个对象

**flythrough mode（飞越模式）**：飞越模式是指第一人称视角，飞越模式的所有操作都需要按住鼠标右键

1. 按住鼠标右键拖动来环顾四周
2. 用wasd前进后退左移右移
3. 用qe上升下降
4. 按住shift移动得更快

### 场景视图工具

1. 快捷键Q，移动相机 
2. 快捷键W，移动
3. 快捷键E，旋转
4. 快捷键R，拉伸
5. 快捷键T，2D拉伸
6. 快捷键Y，移动+旋转+拉伸

### Gizmos

Gizmos是unity场景视图中的辅助图标，比如选中移动工具以后，场景视图中会出现一个帮助你移动的坐标轴，这个坐标轴就是一个Gizmo

## 3D场景

两个默认GameObject

- Main Camera，玩家的游戏视角
- Directional Light，给游戏对象打光

每个GameObject都包含一系列component（组件）

- Transform component（变换组件），包含位置（Position）、旋转（Rotation）、大小（Scale）
    - unity的坐标轴系统是y轴垂直，x、z轴水平
    - Position，变换组件在坐标轴上的位置
    - Rotation，变换组件绕坐标轴旋转的角度（从坐标轴的正方向向负方向看，顺时针旋转为正向旋转）
    - Scale，变换组件沿坐标轴的放缩倍数（值为1时为原始大小）

可以给一个GameObject添加子GameObject，例如给一个Cube（立方体）对象添加一个子Sphere（球体）对象，调整Cube的比例、位置，Sphere会跟着变，但是只有Cube的属性值变了，Sphere的属性值并没有变，也就是说，Sphere的变换组件的属性值是相对于Cube的

## 概念

1. **primitive object（原始对象）**
    - Primitive object是基本3D形状的游戏对象，例如立方体（cube）和球体（sphere），可以将它们添加到场景中作为后续导入资源的占位对象。 
    - 如何在创建中创建：在hierarchy的空白处右键，选择3D object，选择一个原始对象
