---
title: "Unity入门笔记"
date: 2022-06-26T10:48:30+08:00
# bookComments: false
# bookSearchExclude: false
tags:
  - "unity"
categories:
  - "游戏"
  - "编程"
---

## 参考

1. [unity manual](https://docs.unity3d.com/Manual/)
2. [unity-essentials 系列教程](https://learn.unity.com/pathway/unity-essentials)

## 编辑器操作

### 场景视图导航

1. **pan（移动视图）**：使用“手”工具，按住鼠标左键拖动视图
2. **zoom（放缩）**：使用鼠标滚轮或按住 alt 和鼠标右键拖动
3. **orbit（环绕物体）**：按住 alt 和鼠标左键拖动
4. **focus（聚焦）**：按 F 聚焦到一个对象

**flythrough mode（飞越模式）**：飞越模式是指第一人称视角，飞越模式的所有操作都需要按住鼠标右键

1. 按住鼠标右键拖动来环顾四周
2. 用 wasd 前进后退左移右移
3. 用 qe 上升下降
4. 按住 shift 移动得更快

### 场景视图工具

1. 快捷键 Q，移动相机
2. 快捷键 W，移动
3. 快捷键 E，旋转
4. 快捷键 R，拉伸
5. 快捷键 T，2D 拉伸
6. 快捷键 Y，移动+旋转+拉伸

### Gizmos

Gizmos 是 unity 场景视图中的辅助图标，比如选中移动工具以后，场景视图中会出现一个帮助你移动的坐标轴，这个坐标轴就是一个 Gizmo

### 快捷键

复制，ctrl+D

## 3D 场景

### GameObject

1. 在 hierarchy 中创建 Gameobject
2. primitive object（原始对象）
   - Primitive object 是基本 3D 形状的游戏对象，例如立方体（cube）和球体（sphere），可以将它们添加到场景中作为后续导入资源的占位对象。
   - 如何在创建中创建：在 hierarchy 的空白处右键，选择 3D object，选择一个原始对象
3. 两个默认 GameObject
   - Main Camera，玩家的游戏视角
     - 可以移动、旋转、不能放缩
     - ctrl+shift+F，将 Main Camera 调整为和当前的编辑视角一致
   - Directional Light（方向光），给游戏对象打光
     - 方向光可以旋转，但不能移动（改变transform不会产生效果）和放缩
     - 可以修改方向光的颜色
     - 除方向光以外，unity 中还有很多种光，例如 Point Light、Spot Light 等.
4. 每个 GameObject 都包含一系列 component（组件）
5. 可以给一个 GameObject 添加子 GameObject，例如给一个 Cube（立方体）对象添加一个子 Sphere（球体）对象，调整 Cube 的比例、位置，Sphere 会跟着变，但是只有 Cube 的属性值变了，Sphere 的属性值并没有变，也就是说，Sphere 的变换组件的属性值是相对于 Cube 的
6. empty GameObject（空对象），占位对象，可以作为其他对象的容器
7. Transform component（变换组件），包含位置（Position）、旋转（Rotation）、大小（Scale）
   - unity 的坐标轴系统是 y 轴垂直，x、z 轴水平
   - Position，变换组件在坐标轴上的位置
   - Rotation，变换组件绕坐标轴旋转的角度（从坐标轴的正方向向负方向看，顺时针旋转为正向旋转）
   - Scale，变换组件沿坐标轴的放缩倍数（值为 1 时为原始大小）
8. rigidbody component（刚体组件）
   - 刚体组件可以给对象赋予物理特性（重量、下落、滚动等）

### material（材质）

- 材质是一类组件，可以给对象赋予表面特性
- 在project窗口中创建材质，Assets > Create > Material
- 直接把材质拖到对象上即可应用材质
- 纯色材质，修改Albedo属性后面的颜色
- 使用texture map（纹理映射）创建材质。可以把纹理映射简单理解为一张图片
    - 点击Albedo属性前面的圆圈选择图片
    - 有时我们希望选取图片的一部分作为纹理，或者让图片呈现平铺效果，这时就需要使用offset和tiling参数
        - **对offset和tiling参数来说，原图平铺在平面上，图片的左下角为原点，图片在整个平面上无限重复**
        - offset，指定选取图像的起始位置，取值范围为0~1（表示相对于原图的比例）
        - tiling，指定选取图片的范围，以offset为起点，取值正负均可，可以大于1。（取值同样表示相对原图的比例）
- physic material（物理材质），物理材质可以赋予对象弹跳、摩擦力、拉力等物理特性
    - 在对象的colider组件中应用物理材质（可以直接把材质拖到这里）

### prefab（预制物）

- 一个prefab是一个GameObject模板（相当于类），从prefab创建出的实际的GameObject叫做实例（instance）
- 修改prefab会使所有实例跟着被改
- 创建prefab，把GameObject直接拖到project窗口中
- 在hierarchy窗口中，点击，GameObject右边的箭头进入prefab编辑模式（点击的同时按住alt单独编辑prefab）
- 修改实例的属性称为“override”，修改过的属性左边会出现一条蓝线
- prefab variant，预制体变体，原prefab称为base prefab（prefab variant相当于是从base prefab继承而来），修改base prefab会影响prefab variant，但反过来不会。
  - 创建变体，将一个修改过的prefab实例拖到project中时，选择“create prefab variant”
- nested prefab（表示prefab之间的组合关系）
  - 在prefab编辑模式下可以创建prefab组合

## 脚本

- 给一个对象创建一个scripts组件，脚本文件会创建在assests窗口中。
- 脚本中包含一个类，继承自`MonoBehaviour`类，包含两个方法，`Start()`和`Update()`，`Start()`在游戏启动时调用一次，`Update()`每帧调用一次。
- 类中的变量会出现在unity editor中的脚本组件里面。
- 在unity editor中打开控制台窗口，Ctrl+Shift+C (Windows) or Cmd+Shift+C (Mac)。
- 在窗口中选择collapse可以对重复的日志只打印一条，右侧显示其计数。

## 音频

- 3D声源：unity除了能模拟真实环境中物体之间的交互，还能模拟真实环境中的声波，玩家听到的声音大小取决于玩家和声源的距离、玩家和声源之间材质的特性等。
- 3D声源的声音接收者称为Audio Listener，一个场景里只能有一个Audio Listener，默认和main camera绑定。
- 声音组件是Audio Source
  - AudioClip属性选择声音
  - Loop属性让声音循环播放
  - Spatial Blend属性将声音变为3D声源
  - 3D Sound Settings -> xxx Rolloff可以调整声音衰减
    - Min Distance设置的是能听到最大音量的距离，在这个距离之内就能听到最大音量，超过这个距离声音就会衰减。
    - Max Distince设置的是能听到声音的最远距离，超过这个距离就无法听到声音。