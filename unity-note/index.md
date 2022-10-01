# Unity入门笔记


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
     - 方向光可以旋转，但不能移动和放缩
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
        - **图片的左下角为原点，并且对offset和tiling参数来说，原图平铺在整个平面上的**
        - offset，指定选取图像的起始位置，取值范围为0~1（表示相对于原图的比例）
        - tiling，指定选取图片的范围，以offset为起点，取值正负均可，可以大于1。（取值同样表示相对原图的比例）
- physic material（物理材质），物理材质可以赋予对象弹跳、摩擦力、拉力等物理特性
    - 在对象的colider组件中应用物理材质（可以直接把材质拖到这里）
