# games101笔记


## 变换（Transform）

有几种常见的变换

- 缩放（Scale）
- 翻转（Reflection）
- 切变（Shear）
- 旋转（Rotate）

### 切变（Shear）

以下是一个x方向上切变的例子

```text
变换前

   ^ y
   |
 1 | +-----+
   | |     |
 0 | +-----+
   +--------------> x

变换后

   ^ y
   |
 1 |    /-----/      ← 顶边向右平移 k
   |   /     /
 0 | +-----/
   +--------------> x
```

表示为矩阵乘法：

$$
\begin{bmatrix}
x'\\
y'
\end{bmatrix}
=
\begin{bmatrix}
1 & a\\
0 & 1
\end{bmatrix}
\begin{bmatrix}
x\\
y
\end{bmatrix}
$$
