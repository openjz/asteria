---
title: "Windows CPU/GPU 内存管理概念介绍"
date: 2026-09-11T09:23:27+08:00
tags: ["windows", "操作系统"]
categories: ["编程"]
---

# Windows CPU/GPU 内存管理概念

Windows 的 CPU 内存指标主要描述进程虚拟内存和物理内存驻留情况；GPU 内存指标主要描述 GPU 可使用的本地显存和系统内存。

## CPU 内存指标

### 已使用

**已使用**通常表示当前已被系统占用的物理内存，包括进程、内核、驱动、缓存和内存压缩等部分。

它不是所有进程内存之和，因为内核内存和共享页面不一定按进程重复统计。

### 已提交

**已提交（Committed）**表示系统已经承诺提供存储支持的虚拟内存总量，支持来源通常是物理内存或页面文件。

系统的提交限制通常近似为：

```text
提交限制 = 物理内存 + 页面文件
```

已提交不等于当前位于 RAM 中的内存，已提交页面可能已经换出到页面文件。

### 工作集（内存）

**工作集（Working Set）**表示当前驻留在物理内存中的进程页面，包括私有页面和共享页面。

多个进程可能共享同一个页面，因此所有进程工作集之和可能重复计算共享页面。

### 内存（专用工作集）

**专用工作集（Private Working Set）**表示工作集中当前驻留在 RAM 中、不能与其他进程共享的页面。

它更接近进程当前独占的物理内存，但不包括已提交而暂未驻留或已经换出的页面。

### 内存（共享工作集）

**共享工作集（Shared Working Set）**表示工作集中可以与其他进程共享的页面，例如共享 DLL、共享内存和内存映射文件。

通常可以粗略理解为：

```text
工作集 = 专用工作集 + 共享工作集
```

### 提交大小

**提交大小（Commit Size）**表示进程已经提交的虚拟内存量，包括当前不在 RAM 中、但需要物理内存或页面文件支持的页面。

因此：

```text
提交大小 != 工作集
提交大小 >= 专用工作集（通常）
```

## GPU 显存指标

DXGI 的 `DXGI_ADAPTER_DESC` 提供以下容量字段：

- `DedicatedVideoMemory`
- `DedicatedSystemMemory`
- `SharedSystemMemory`

这些字段描述适配器的内存能力或容量，不表示当前实际使用量；当前使用量和预算应通过 WDDM/DXGI 的显存查询接口获取。

### Dedicated Video Memory

**Dedicated Video Memory**（专用视频内存）是 GPU 本地显存，例如独立显卡上的 GDDR 或 HBM 显存。

在 dGPU 上，它通常等于显卡物理显存容量；在 iGPU 上通常为 0 或一个由固件、驱动保留的数值，不代表 iGPU 没有可用显存。

### Shared System Memory

**Shared System Memory**（共享系统内存）是 GPU 可以使用、同时也属于 CPU 系统内存的 RAM。

- dGPU 通常优先使用本地显存，显存不足或资源被驱动迁移时才使用系统内存；通过 PCIe 访问系统内存通常慢于访问本地显存。
- iGPU 没有独立显存，Shared System Memory 通常是 GPU 的主要内存来源，并与 CPU 共享内存带宽。

### Dedicated System Memory

**Dedicated System Memory**（专用系统内存）是从系统 RAM 中专门分配给适配器使用的区域。

- dGPU 通常为 0 或较小，因为 dGPU 主要使用本地显存。
- iGPU 可能因固件预留而存在，但它不等于 iGPU 的全部可用内存。

## dGPU 与 iGPU 对比

| 指标 | dGPU | iGPU |
| --- | --- | --- |
| Dedicated Video Memory | 通常是独立显卡的物理显存 | 通常为 0 或保留值 |
| Dedicated System Memory | 通常为 0 或较小 | 可能存在固件预留区域 |
| Shared System Memory | 显存不足时的补充 | 通常是主要 GPU 内存来源 |
| CPU/GPU 内存关系 | GPU 有独立显存，也可访问系统 RAM | CPU 和 GPU 共享系统 RAM |
| 主要性能限制 | 本地显存不足时访问系统 RAM 的带宽和延迟 | CPU/GPU 争用系统内存带宽 |

