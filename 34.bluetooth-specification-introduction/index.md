# 蓝牙相关知识


## 蓝牙技术

蓝牙是一种无线通讯技术，蓝牙到目前为止一共发展了多代规范。从蓝牙4.0开始提出了BLE技术（Bluetooth Low Energy，蓝牙低功耗），一般把蓝牙4.0称为BLE，把之前的版本称为经典蓝牙（BR/EDR）或传统蓝牙。

以下列出了各代蓝牙技术

|技术|规范|版本|
|---|---|---|
|BR|1.1(2003)|Basic Rate (1 Mbit/s)|
|EDR|2.0(2004)|Enhance Data Rate (2-3 Mbit/s)|
|HS|3.0(2009)|High Speed (Alternate MAC/PHY)|
|LE|4.0(2010)|Low Energy (1 Mbit/s ultra low power)|

- BR，基础速率（Basic Rate），1.1版本，传输率约在1Mbit/s，因为是早期设计，容易受到同频率的产品干扰，影响通讯质量。
- EDR，增强速率（Enhanced Data Rate），大大提高了蓝牙数据传输速率，达到了2-3Mbit/s 。除了音频流传输更稳定和耗电量更低之外，还可充分利用带宽优势同时连接多个蓝牙设备。
- HS，High Speed。能利用WiFi作为数据传输方式，传输速度最高可达24Mbps。其核心是在802.11的基础上，通过集成802.11协议适配层，使得蓝牙协议栈可以根据任务和设备的不同，选择正确的射频。
- LE，低能耗（Low Energy），是蓝牙4.0版本提出的特性，特点是低功耗、短距离、可互操作，工作在免许可的2.4GHz ISM射频频段。

## 蓝牙host和蓝牙controller

蓝牙controller一般指蓝牙芯片控制部分，位于蓝牙技术的下层

蓝牙host一般指蓝牙协议栈，位于蓝牙技术的上层

## 经典蓝牙（BR/EDR）

### 蓝牙地址

经典蓝牙地址，长度48位（6字节），每个设备的经典蓝牙地址是唯一的，需要由企业向IEEE申请购买。

### CoD（Class of Device，设备类型）

长度24位（3字节），用来表明设备类型

## 低功耗蓝牙(BLE)

### 地址类型

public地址：和经典蓝牙地址一样，是固定的

random地址：随机地址，会经常变化（15分钟变一次）

### 广播和扫描

广播包发出后，可被其他设备扫描到，扫描分为主动扫描和被动扫描，被动扫描只是单纯地接收广播包，主动扫描会给发广播的设备发送扫描请求包，发送广播的设备会回复扫描响应包

广播包的payload由一个个data section组成，data section是一种key-value结构，常见的key有0x09（local name），0x16（service uuids）

### GATT（Generic Attribute Profile）

GATT（Generic Attribute Profile）是一种蓝牙通讯规范，用于在BLE连接上发送和接受短数据段。GATT是一种一对一的通信方式。

GATT通信的双方是C/S关系。外设作为GATT服务端（Server），维持ATT的查找表以及service和characteristic的定义。中心设备是GATT客户端（Client），负责向Server发起请求。

GATT从逻辑上由Profile、Service和Characteristic嵌套组成，一个Profile包含多个Service，一个Service包含多个Characteristic，Service和Characteristic都由唯一的UUID标识。

UUID长度为128位（16个字节），官方预先指定了一些UUID作为通用Service和Characteristic，形式是`0000xxxx-0000-1000-8000-00805f9b34fb`，只靠第96~111位这16位区分，其他位都是相同的。因此在官方文档中，UUID都是以类似`0x1800`的形式出现。

一个Service通常对应一种通信协议。

Characteristic是GATT的最小通信单位，一个Characteristic包含一个Characteristic declaration，一个Characteristic value和多个Characteristic descriptor。

GATT基于ATT（attribute protocol）协议进行通信。

### 包长度限制

ble广播包和扫描响应包长度是31字节，ble 5.0 提出了Extented Advertising机制，即扩展广播机制，可以将广播包数据最大长度提升到255字节

gatt包长度（MTU）也有限制，通常是512字节，两台设备建立连接之前会进行MTU协商

## 蓝牙配对方案

根据蓝牙规范5.3，蓝牙安全架构中有三种配对方案

1. BR/EDR Legacy Pairing 
2. BR/EDR Secure Simple Pairing
3. LE Legacy Pairing

Secure Simple Pairing (SSP) 有四种认证模式，Just Works, Numeric Comparison, Passkey Entry and Out-Of-Band。

- Numeric Comparison，两个设备都给用户展示一个6位的数字，然后让用户判断两个数字是否相同。和 BR/EDR Legacy Pairing 的输入PIN码有个很大的区别，Numeric Comparison的6位数字是由算法生成的，而不是由用户输入的。使用这种模式的典型的有手机和PC之间配对。
- Just Works，这个模式的设计目的是防止有设备不能展示数字和让用户输入确认，典型的是手机和耳机之间配对。Just Works模式使用的也是Numeric Comparison协议，但是不给用户展示数字，只会让用户确认配对。
- Out-Of-Band，例如NFC，交互过程根据不同的OOB方案而有所差异。
- Passkey Entry，这个模式是针对其中一个设备只能输入不能展示，交互过程是让一个设备给用户展示6位数字，然后让用户在另一个设备上输入6位数字。

LE Legacy Pairing，和 SSP 类似有四种模式，功能一样，底层的算法有所差异

### BR/EDR security mode

BR/EDR 有四种 security mode，分别是 security mode 1，security mode 2，security mode 3，security mode 4，数字越大安全等级越高。

同一个设备有可能同时支持两种安全模式，一个是security mode 2，用来作为对端设备不支持SSP的兼容方案，一个是security mode 4，针对支持SSP的设备

- Legacy security modes，security mode 1~3的统称
    - security mode 1，不安全
    - security mode 2 
        - 只能作为对端设备不支持 mode 4时的兼容模式。  
        - mode 2设备把service的安全需求分为三类attributes，即Authorization required（授权）、Authentication required（认证）、Encryption required（加密）  
        - mode 1可以看作是mode 2的一种特殊情况，即没有service注册这些attribute
    - security mode 3
- security mode 4
    - 把service的安全需求分为三类attributes，即Authenticated link key required、Unauthenticated link key required、Security optional; limited to specific services。
    - 分为level 0~4，数字越大越安全

### LE security mode

有三种，分别是LE security mode 1, LE security mode 2, 
and LE security mode 3

## 工具

- NORDIC的调试工具nRF Connect，可用于调试ble

## 设备分类

- cell phone，手机
- headsets，耳机
- mono headset，单声道耳机

## 参考

- 查所有的蓝牙规范，[https://www.bluetooth.com/specifications/specs/](https://www.bluetooth.com/specifications/specs/)
- 蓝牙规范里的各种代码，[https://www.bluetooth.com/specifications/assigned-numbers/](https://www.bluetooth.com/specifications/assigned-numbers/)
- 蓝牙核心文档，[https://www.bluetooth.com/specifications/specs/?types=adopted&keyword=core&filter=](https://www.bluetooth.com/specifications/specs/?types=adopted&keyword=core&filter=)
