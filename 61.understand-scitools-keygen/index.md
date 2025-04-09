# Scientific Toolworks Understand 7.0.x 破解机使用方法


1. 安装understand
2. 阻止understand访问网络  
    给understand加两个hosts规则  
    ```hosts
    0.0.0.0 licensing.scitools.com
    0.0.0.0 stats.scitools.com
    ```
3. 启动understand，创建新项目
4. understand会弹出一个对话框，对话框中有一项是“License Request Code”，值大概是“xxx-xxx-xxx”这种格式，把“License Request Code”的值记下来。（注意，如果没做第2步，understand是不会显示“License Request Code”的）
5. 打开注册机，输入第4步记下来的“License Request Code”
6. 将注册机生成的“Replay Code”和“Expiration Date”填入understand刚刚弹出的对话框中
