# 蓝牙调试工具


参考：

- [https://learn.microsoft.com/zh-cn/windows-hardware/drivers/bluetooth/testing-btp-setup-package?source=recommendations](https://learn.microsoft.com/zh-cn/windows-hardware/drivers/bluetooth/testing-btp-setup-package?source=recommendations)

1. 下载微软BTP软件包
    - 禁用 BitLocker
    - 禁用安全启动（先禁用bitlocker，再禁用安全启动，不然启动的时候会要求你输入bitlocker恢复密钥）
2. 安装Wireshark
    - 能安装的项都装上
    - 弹出npcap安装窗口的时候，选择“Support raw 802.11 traffic(and monitor mode)for wireless adapters”和“Install Npcap in WinPcap API-compatible Mode”
3. 给btvs.exe配置环境变量（C:\BTP\v1.14.0\x86）
4. 在powershell中输入`btvs.exe -Mode Wireshark`即可自动拉起wireshark分析蓝牙数据包
