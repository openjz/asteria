---
title: "Unity入门笔记"
date: 2022-06-26T10:48:30+08:00
# bookComments: false
# bookSearchExclude: false
tags : 
- "unity"
categories : 
- "游戏"
- "计算机"
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

## 概念

1. **primitive object（原始对象）**
    - Primitive object是基本3D形状的游戏对象，例如立方体（cube）和球体（sphere），可以将它们添加到场景中作为后续导入资源的占位对象。 
    - 如何在创建中创建：在hierarchy的空白处右键，选择3D object，选择一个原始对象
