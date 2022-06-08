+++
title = "css入门笔记"
date = 2021-11-14T10:09:46+08:00
lastmod = 2021-11-14T10:09:46+08:00
tags = ["css","前端"]
categories = ["计算机"]
draft = false
+++

参考[MDN教程](https://developer.mozilla.org/zh-CN/docs/Learn/CSS)

## 一、导入 css

1、导入外部样式：

```html
<link rel="stylesheet" href="styles.css" />
```

2、内部样式

使用 style 元素

```html
<html>
  <head>
    <meta charset="utf-8" />
    <title>My CSS experiment</title>
    <style>
      h1 {
        color: blue;
        background-color: yellow;
        border: 1px solid black;
      }

      p {
        color: red;
      }
    </style>
  </head>
  ...
</html>
```

3、内联样式

使用 style 属性

```html
<h1 style="color: blue;background-color: yellow;border: 1px solid black;">
  Hello World!
</h1>
```

## 语法

1、选择器+大括号，属性:值;

```css
h1 {
  color: red;
  font-size: 5em;
}
```

2、函数

`width: calc(90% - 30px);`

3、@规则

@import：导入样式表
@media：媒体查询（当条件成立时才应用样式）

4、速记属性

允许在一行中设置多个属性值，如 padding、border 等，例如：

```css
padding: 10px 15px 15px 5px;
/* 等价于 */
padding-top: 10px;
padding-right: 15px;
padding-bottom: 15px;
padding-left: 5px;

background: red url(bg-graphic.png)
/* 等价于 */
background-color: red;
background-image: url(bg-graphic.png);
```

## 选择器和选择符

| 选择器     | 例子                                                                                                                                                                                          |
| ---------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 元素       | h1                                                                                                                                                                                            |
| id         | #onething                                                                                                                                                                                     |
| 类         | .manythings、a.manythings、.classA.classB                                                                                                                                                     |
| 伪类       | a:link、\*:link、:link                                                                                                                                                                        |
| 属性       | `a[title]`、`a[href="https://example.com"]`、`a[attr~=v]`、`a[attr\|=v]`、`a[attr]`、`[attr^=value]`、`[attr$=value]`、`[attr*=value]`、`[attr=value i]`（结尾加个 i 代表按大小写不敏感匹配） |
| 伪元素     | p::first-line                                                                                                                                                                                 |
| 通用选择器 | \*                                                                                                                                                                                            |

注：

- **多个选择器连在一起写代表“与”的关系**。
- 伪类代表元素的状态，伪元素是一种虚拟的元素。[参考：常见伪类和伪元素](https://developer.mozilla.org/zh-CN/docs/Learn/CSS/Building_blocks/Selectors/Pseudo-classes_and_pseudo-elements)

| 运算符            | 例子        |
| ----------------- | ----------- |
| 空格：后代选择器  | article p   |
| >：子代选择器     | article > p |
| +：相邻兄弟选择器 | h1 + p      |
| ~：通用兄弟选择器 | h1 ~ p      |

## 继承

继承：有些父元素上的 css 属性可以被子元素继承，有些不能。

使用 inherit、initial、unset、revert 这四个属性值控制继承，例如

```css
.my-class-1 a {
  color: inherit;
}
```

属性 all 可以用来代表所有属性

## 层叠

1. 多个相同权重的规则应用到同一个元素时，后面的覆盖前面的
2. 选择器具有优先级，优先级计算公式
   - 千位：style 属性（内联属性）得一分
   - 百位：id 选择器得一分
   - 十位：类选择器、属性选择器、伪类选择器得一分
   - 个位：元素选择器、伪元素选择器得一份
   - 通用选择器 (\*)，组合符 (+, >, ~, ' ')，和否定伪类 (:not) 不会影响优先级。
   - 计算时不允许进位，无论多少个低位选择器的权重叠加，都不会超过一个高位选择器。
   - !important：优先级高于其他所有
3. 当浏览器遇到无法解析的 css 时（比如 css 拼写错误）这个 css 会被忽略。

## 盒子

块级盒子（Block Box）：

- 盒子会在内联的方向上扩展并占据父容器在该方向上的所有可用空间
- 会换行
- 可以设置宽高（width 和 height）
- padding、margin 和 border 会把周围的元素推开

内联盒子（Inline Box）：

- 不会换行
- 宽高不起作用（width 和 height）
- 垂直方向的 padding、margin 和 border 不会把其他 inline 盒子推开
- 水平方向的 padding、margin 和 border 会把其他 inline 盒子推开

**盒子的显示类型**：

- 外部显示类型：决定盒子在它的父元素内是如何布局的，display 值为 inline 或 block
- 内部显示类型：决定盒子内部元素如何布局，display 值为 flex、grid 等。默认为正常文档流（inline 是 inline，block 是 block）
- 其他类型：
  - inline-flex：外部显示类型为 inline，内部显示类型为 flex
  - inline-block：不换行的 block，能设置高宽、margin 和 padding，能把周围推开

## 盒模型

完整的 CSS 盒模型应用于块级盒子，内联盒子只使用盒模型中定义的部分内容。

盒模型组成：content、padding、border、margin

- 标准盒模型：width 和 height 设置的是 content。box-sizing: content-box;
- 替代（IE）盒模型：width 和 height 设置的是总长宽。box-sizing: border-box;

外边距折叠：如果两个元素相邻，它们之间的距离不是两个元素的 margin 之和，而是取两个元素 margin 的较大值

margin 可以为负值。padding 不可以为负

属性写法（去掉后缀就是简写）：{margin/border/padding}-{top/right/bottom/left}-{width/style/color}

## 背景和边框

背景（background）:

- background-image 属性可以有多个图片，图片会叠在一起显示
- {background}-{color/image/repeat/size/position/attachment}
- 可以设置渐变（gradient）背景

边框（border）:

- {border}-{width/style/color/radius}

## 文本方向与逻辑属性

writing-mode: horizontal-tb、vertical-rl、vertical-lr

逻辑属性是为了解决文本方向变化时盒子的高宽等属性不能正确变化的问题，例如

- inline-size 对应 width
- block-size 对应 height
- 内外边距、边框也有对应的逻辑属性
- 属性值也有对应的逻辑属性值

## 处理内容溢出

内容溢出

- overflow:visible/hidden/scroll/auto
- overflow-x
- overflow-y

文本换行

- word-break
- overflow-wraps
- hyphens

## 值和单位

[参考：CSS 的值与单位](https://developer.mozilla.org/zh-CN/docs/Learn/CSS/Building_blocks/Values_and_units)

css 值可以使用关键字和值。关键字是指 red、top 等。

- 数值类型：`integer`、`number`、`dimension`、`<percentage>`、`<length>`
  - 长度（length）
    - 绝对单位：px
    - 相对单位：rem
  - 百分比（percentage）
    - 百分比通常是相对于父元素
- 颜色（`<color>`）
  - RGB 和 RGBA：RGBA 颜色在 RGB 的基础上增加了一个透明度值，与 opacity 属性不同，opacity 使得元素和它里面的所有东西都不透明，而 RGBA 颜色只让指定的颜色不透明。（**可以用 RBGA 颜色来增加一层滤镜**）
  - HSL 和 HSLA：RGB 是红绿蓝，HSL 是色调、饱和度和亮度
- 图片（`<image>`）和渐变（`<gradient>`）
- 位置（`<position>`）
- 标识符，标识符就是指上面提到的 css 关键字
- 字符串，例如`content: "This is a string"`
- 函数，例如 rgb()、url()、calc()等

## 尺寸

原始尺寸/固有尺寸：

- 例如图像本身的尺寸
- 空 div 没有尺寸，高度为 0，宽度由于其是块级元素会扩展到和父元素一样宽。

用百分数设置尺寸时：

- 对于 width 和 height，是相对于父元素宽度的百分比
- 对于内外边距，不论是左右边距还是上下边距，都是相对于 inline-size（即宽度）的百分比

min-和 max-尺寸：

- 如果盒子内容会变化，用 min-和 max-设置最小或最大尺寸，盒子尺寸就会随内容自动变化
- 这个技术就是用来使图片（`<image>`）可响应的，可响应是指图片随设备尺寸自动缩放。

视口尺寸：

- vw 和 vh

## 替换元素和表单

替换元素：指图像和视频元素，css 不能影响其内部布局

- 调整大小，object-fit: cover/contain/fill;
- 在 flex 和 grid 布局中，元素会被拉伸，而图像不会

表单的样式在不同浏览器上不太统一，需要额外设置 css 样式保证其初始样式一致，已经有一些工具帮开发人员完成了这个工作，例如 Normalize.css。

## 字体

web 安全字体：可以在任何一种操作系统上找到的字体。[参考：cssfontstack](https://www.cssfontstack.com/)

五种字体的大类型：

- serif，有衬线字体，衬线是指字体笔画尾端的小装饰，常见于印刷体字体
- sans-serif，无衬线字体
- monospace，等宽字体，通常用于代码
- cursive，手写体
- fantasy，用来装饰的字体

使用上面这五种字体时，由浏览器决定具体使用什么字体

常见属性属性名：

- font-family/size/style/weight/transform/decoration
- color
- text-shadow
- text-align
- line-height
- letter-spacing
- word-spacing

web 字体：访问时和页面一起下载，本不需要本地事先有这种字体

```css
@font-face {
  font-family: "myFont";
  src: url("myFont.ttf");
}
```

注意：

1. 有些字体有版权，不能随便用
2. 不同浏览器支持的字体格式可能不同，常见的格式有.ttf, .woff, .woff2 等
3. 在线字体服务，例如 google fonts，可以从第三方站点导入字体，例如用`<link>`或`@import`导入字体，不需要开发人员自己提供字体

## 布局

### 正常布局流

正常布局流是指默认的布局。

- 块元素的布局方向垂直于书写方向
- 内联元素的布局方向和书写方向一致
- 默认的，块元素的宽度是其父元素的 100%，高度与其内容高度一致。内联元素的 height 和 width 与内容一致。
- 外边距叠加

### flexbox（弹性盒子）

display:flex

flexbox 用于创建横向或纵向的一维布局，里面的子元素被称为 flex 项，flex 有以下特点：

- 默认方向是横向（父元素 flex-direction:row）
- 元素会被拉伸到和最高的元素相同（父元素 align-items:stretch）
- 所有 flex 项都默认从容器的开始位置进行排列，排列成一行后，在尾部留下一片空白。

概念：

- 主轴是指沿着 flex 项放置方向的轴，交叉轴是指垂直方向的轴
- 设置了 display:flex 的父元素被称为 flex 容器，里面的子元素被称为 flex 项

方向：

- flex-direction:row/column/row-reverse/column-reverse，设置主轴方向，-reverse 代表反向排列元素
- flex-wrap: wrap，允许换行
- flex-flow：以上两项的缩写

动态尺寸：

- flex:1，无单位的数字代表一个比例，其所占宽度=(1/所有 flex 项所占比例之和)\*屏幕宽度
- flex:1 200px，该 flex 项至少占 200px，剩余空间按比例分配
- flex-grow、flex-basis，分别是以上两个的全写
- flex-shrink：指定了从每个 flex 项中取出多少溢出量，以阻止它们溢出它们的容器。

对齐：

- align-items 控制 flex 项在交叉轴上的位置
- justify-content 控制 flex 项在主轴上的位置，其值包括 flex-start、flex-end、flex-around、flex-between

排序：使用 order 属性，默认值是 0，值越大，越往后排

### grid（网格）

display:grid

默认只有一列，创建多个列：

- grid-template-columns: 200px 200px 200px;
- 用`fr`单位创建多个列，grid-template-columns: 2fr 1fr 1fr，`fr`定义了一个比例，有点类似于flexbox不带单位的尺寸
- grid-template-columns: 300px 2fr 1fr，剩下的两列会根据除去300px后的可用空间按比例分配
- 使用repeat函数重复生成列

在网格系统中，行和列之间的间隙被称为 gutter（沟槽），如何修改gutter：

- grid-column/row-gap

显式网格和隐式网格，隐式网格是指浏览器会自动将多出来的内容放到新的行/列里面去：

- 参数默认是auto，大小会根据放入的内容自动调整
- grid-auto-rows/columns，指定显式网格的大小

动态行列尺寸：

- 使用minmax函数设置行列尺寸，minmax函数可以设置一个取值范围，例如minmax(100px, auto)，下面是一个例子

  ```css
  .container {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
    grid-auto-rows: minmax(100px, auto);
    grid-gap: 20px;
  }
  ```

利用分隔线放置内容

- 我们的网格有许多分隔线，第一条线的起始点与文档书写模式相关。在英文中，第一条列分隔线（即网格边缘线）在网格的最左边而第一条行分隔线在网格的最上面。
- grid-column/row-start/end
- gird-column/row：同时指定开始线和结束线，**要使用/符号分开**，例如：grid-column: 1 / 3;

利用grid-template-areas和grid-area放置内容

- 对于某个横跨多个格子的元素，重复写上那个元素grid-area属性定义的区域名字
- 所有名字只能出现在一个连续的区域，不能在不同的位置出现
- 一个连续的区域必须是一个矩形
- 使用.符号让一个格子留空

```css
.container {
  display: grid;
  grid-template-areas:
      "header header"
      "sidebar content"
      "footer footer";
  grid-template-columns: 1fr 3fr;
  grid-gap: 20px;
}

header {
  grid-area: header;
}

article {
  grid-area: content;
}

aside {
  grid-area: sidebar;
}

footer {
  grid-area: footer;
}
```

### 浮动（float）

略

### 定位（position）

- 静态定位：`position: static;`，默认值，将元素放入文档布局流中的正常位置
- 相对定位：`position: relative;`，使用top, bottom, left, 和 right定位
- 绝对定位：`position: absolute;`，绝对定位的元素不再存在于正常文档布局流中，它在自己的层独立于一切。绝对定位元素相对于其“包含元素定位”。哪个元素是绝对定位元素的“包含元素”取决于绝对定位元素的父元素的position属性
  - 如果父元素都是static，绝对定位元素会被包含在初始快容器中（`<html>`元素外面，根据浏览器视口定位）
  - 如何修改绝对定位元素的相对元素？把它的一个父元素设置为相对定位（`position: relative`）就好了。
  - z-index：如果有多个绝对定位元素，用z-index指定它们的堆叠顺序（z是指z轴，假设网页有高度）。z-index默认值是0，数字大的在上面，小的在下面。
- 固定定位：`position: fixed;`，固定定位固定元素相对于浏览器视口本身。
  
    ```css
    /*让一个固定定位元素顶部居中*/
    h1 {
      position: fixed;
      top: 0;
      margin: 0 auto; /*使用auto居中*/

      width: 500px;
      background: white;
      padding: 10px;
    }
    ```

- `position: sticky;`：相对定位和固定定位的混合体，被定位的元素一开始表现得像相对定位一样，直到它滚动到某个阈值点（例如，距视口顶部1​​0px）后它就变得固定了。

### 多列布局

通过这两个属性开启多列布局，column-count 或者 column-width

- column-count属性创建指定列数，由浏览器计算每一列分配多少空间。
- column-width属性指定列宽，由浏览器计算创建几列。
- 用 column-gap 改变列间间隙。
- 用 column-rule 在列间加入一条分割线。column-rule 是 column-rule-color 和 column-rule-style的缩写，接受和 border 一样的单位。
- 禁止内容折断：break-inside: avoid 或 page-break-inside: avoid

### 响应式布局

媒体查询：当满足指定条件时css才会被应用，例如

```css
@media screen and (min-width: 800px) {
  .container {
    margin: 1em 2em;
  }
} 
```

断点：媒体查询，以及样式改变时的点，被叫做断点（breakpoints），通常是一个阈值。

现代布局方式，多栏布局，弹性盒子和网格默认是响应式的。

视口元标签：

- `<meta name="viewport" content="width=device-width,initial-scale=1">`，它告诉移动端浏览器，应该将视口宽度设定为设备的宽度，将文档放大到其预期大小的100%。**如果不加这个，用断点和媒体查询实现的响应式设计不会生效，因为视口大小还是PC端的大小**
  - initial-scale：设定了页面的初始缩放，我们设定为1。
  - height：特别为视口设定一个高度。
  - 阻止用户缩放
    - minimum-scale：设定最小缩放级别。
    - maximum-scale：设定最大缩放级别。
    - user-scalable：如果设为no的话阻止缩放。

### 媒体查询

```css
@media media-type and (media-feature-rule) {
  /* CSS rules go here */
}
```

它由以下部分组成：

- 一个媒体类型，告诉浏览器这段代码是用在什么类型的媒体上的（例如印刷品或者屏幕）；
  - 它的值可以是：all、print、screen、speech
- 一个媒体表达式，是一个被包含的CSS生效所需的规则或者测试；
  - min-width、max-width、width等
- 一组CSS规则，会在测试通过且媒体类型正确的时候应用。

