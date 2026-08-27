---
title: "如何根据旋转矩阵获取欧拉角"
date: 2026-08-26T01:59:30+08:00
draft: false

tags: ["图形"]
categories: ["编程"]
---

本文所讨论的矩阵全部都是列主序。

## 欧拉角三维旋转矩阵

二维旋转矩阵很容易求，根据旋转角度，求基向量绕原点旋转之后的坐标，就可以得到一组新的基向量，这组新的基向量就构成了旋转矩阵。

![2drotation](/img/how-to-get-euler-angles-from-rotation-matrix/2drotation.png)

三维旋转矩阵的求解有多种方法，四元数和罗德里格斯旋转公式可以求出绕空间中任意一个轴的旋转矩阵，而欧拉角旋转是将三维旋转矩阵分解为三个旋转矩阵的乘积，每个旋转矩阵都是绕坐标轴的旋转，类似二维旋转矩阵，比较直观。

下面以左手坐标系为例说明如何计算欧拉角旋转矩阵。

注意：左手坐标系和右手坐标系下的旋转矩阵是相同的，原因是它们对旋转方向的判定方法相反，刚好使得最终的旋转矩阵相同。左手坐标系下，从旋转轴负方向向原点看去时，逆时针旋转为正方向，而在右手坐标系下，则是从旋转轴正方向向原点看去时，逆时针旋转为正方向。

按照图形学的惯例，我们将绕 x 轴、y 轴、z 轴的旋转分别记为 pitch（俯仰）、yaw（偏航）、roll（滚转），旋转角度分别记为 θ、ψ、φ。

我们以 roll-pitch-yaw 的顺序来进行旋转，最终的旋转矩阵 $R$ 可以表示为：$R = R_y(\psi) R_x(\theta) R_z(\phi)$。

**绕 z 轴的旋转矩阵（roll）**

![3drotation-z-forward](/img/how-to-get-euler-angles-from-rotation-matrix/3drotation-z-forward.png)

$R_z(\phi) = \begin{bmatrix} \cos\phi & -\sin\phi & 0 \\ \sin\phi & \cos\phi & 0 \\ 0 & 0 & 1 \end{bmatrix}$

**绕 x 轴的旋转矩阵（pitch）**

![3drotation-x-forward](/img/how-to-get-euler-angles-from-rotation-matrix/3drotation-x-forward.png)

$R_x(\theta) = \begin{bmatrix} 1 & 0 & 0 \\ 0 & \cos\theta & -\sin\theta \\ 0 & \sin\theta & \cos\theta \end{bmatrix}$

**绕 y 轴的旋转矩阵（yaw）**

![3drotation-y-forward](/img/how-to-get-euler-angles-from-rotation-matrix/3drotation-y-forward.png)

$R_y(\psi) = \begin{bmatrix} \cos\psi & 0 & \sin\psi \\ 0 & 1 & 0 \\ -\sin\psi & 0 & \cos\psi \end{bmatrix}$

**最终的旋转矩阵**

$$
\begin{aligned}
R &= R_y(\psi) R_x(\theta) R_z(\phi) \\
  &=
  \begin{bmatrix} 
  \cos\psi & 0 & \sin\psi \\ 0 & 1 & 0 \\ -\sin\psi & 0 & \cos\psi 
  \end{bmatrix}
  \begin{bmatrix} 1 & 0 & 0 \\ 0 & \cos\theta & -\sin\theta \\ 0 & \sin\theta & \cos\theta
  \end{bmatrix}
  \begin{bmatrix} \cos\phi & -\sin\phi & 0 \\ \sin\phi & \cos\phi & 0 \\ 0 & 0 & 1
  \end{bmatrix} \\
  &=
  \begin{bmatrix}
  \cos\psi \cos\phi + \sin\psi \sin\theta \sin\phi & -\cos\psi \sin\phi + \sin\psi \sin\theta \cos\phi & \sin\psi \cos\theta \\
  \cos\theta \sin\phi & \cos\theta \cos\phi & -\sin\theta \\
  -\sin\psi \cos\phi + \cos\psi \sin\theta \sin\phi & \sin\psi \sin\phi + \cos\psi \sin\theta \cos\phi & \cos\psi \cos\theta
  \end{bmatrix}
\end{aligned}
$$

## 根据旋转矩阵获取欧拉角

由旋转矩阵的计算公式可得：

$$
R_{23} = -\sin\theta \\
$$

这样就得到了 $\theta$，再将 $\theta$ 代入另两个元素，例如：

$$
R_{22} = \cos\theta \cos\phi
$$

$$
R_{13} = \sin\psi \cos\theta 
$$

这样就得到了 $\phi$ 和 $\psi$，从而得到全部欧拉角。

### 万向节锁问题

这里要注意，当 $\theta = \pm \frac{\pi}{2}$ 时，$\cos\theta = 0$，此时无法确定 $\phi$ 和 $\psi$ 的值（从几何上来看，当 $\theta = \pm \frac{\pi}{2}$ 时，z 轴和 y 轴这两个旋转自由度会重合，无法区分）。

