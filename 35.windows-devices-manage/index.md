# windows设备管理


## 蓝牙

- 经典蓝牙
    - win32 蓝牙 api 介绍，[https://learn.microsoft.com/en-us/windows/win32/bluetooth/bluetooth-start-page](https://learn.microsoft.com/en-us/windows/win32/bluetooth/bluetooth-start-page)
    - win32 经典蓝牙设备发现和管理，[https://learn.microsoft.com/en-us/windows/win32/api/_bluetooth/](https://learn.microsoft.com/en-us/windows/win32/api/_bluetooth/)
    - win32 经典蓝牙通信，[https://learn.microsoft.com/en-us/windows/win32/bluetooth/windows-sockets-support-for-bluetooth](https://learn.microsoft.com/en-us/windows/win32/bluetooth/windows-sockets-support-for-bluetooth)
- ble
    - win32 GATT 通信，[https://learn.microsoft.com/en-us/windows/win32/api/_bltooth/](https://learn.microsoft.com/en-us/windows/win32/api/_bltooth/)
    - uwp ble 广播介绍，[https://learn.microsoft.com/en-us/windows/uwp/devices-sensors/ble-beacon](https://learn.microsoft.com/en-us/windows/uwp/devices-sensors/ble-beacon)
- uwp 也提供经典蓝牙 api 和 GATT api，
    - 介绍，[https://learn.microsoft.com/en-us/windows/uwp/devices-sensors/bluetooth](https://learn.microsoft.com/en-us/windows/uwp/devices-sensors/bluetooth)


## setup api

使用一些上层API的时候可能会用到setup api，这套api比较底层，比较难用，涉及一些概念，如IO control、PNP设备等。

setup api 对设备做了两种分类，一类是device setup class，另一类是device interface class。

每个class都有对应的GUID，查找GUID有两种方式

1. 可以在设备管理器中查到。  
例如，蓝牙设备的GUID是`e0cbf06c-cd8b-4647-bb8a-263b43f0f974`
2. GUID分为系统提供的和供应商提供的，系统提供的 GUID 被定义成了不同的宏，类似`GUID_DEVCLASS_Xxx`这样的形式，其中device setup class GUID 在 Devguid.h 这个头文件中，而device interface class的 GUID 定义在不同的头文件中。  
例如，蓝牙设备的GUID宏是`GUID_DEVCLASS_BLUETOOTH`。

参考

- [https://learn.microsoft.com/en-us/windows-hardware/drivers/install/device-information-sets](https://learn.microsoft.com/en-us/windows-hardware/drivers/install/device-information-sets)

## 获取设备电量

怎么获取，分不同的设备类型和协议

- 蓝牙设备
    - BLE battery service
    - HFP(Hands-Free-Profile，免提协议)
- HID设备（Human Interface Devices，人机接口设备）

在windows系统设置中，蓝牙设备的电量是在设备连接时获取一次的，不是实时的。参考[https://blogs.windows.com/windows-insider/2018/04/04/announcing-windows-10-insider-preview-build-17639-for-skip-ahead/](https://blogs.windows.com/windows-insider/2018/04/04/announcing-windows-10-insider-preview-build-17639-for-skip-ahead/)



