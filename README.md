# Palworld服务端自动备份存档&进程守护脚本

使用windows原生powershell制作，无需安装任何依赖环境，复制就能用

适用于Windows系统中使用steamcmd启动的Palworld服务端

默认每半小时备份一次，自动创建时间戳命名的存档压缩包保存在指定目录下，保留48份滚动删除

默认每5秒进行一次进程检查，崩溃自动重启

须手动修改服务端路径、存档路径、指定备份文件夹

可选配置项：备份间隔时间（毫秒）、进程存活检测间隔（毫秒）


## 使用方法

复制 `server.ps1` 中所有代码创建ps1脚本文件，或直接下载 `server.ps1`，在windows中右键点击编辑进入powershell编辑器，调整好所需的配置项后，点击运行按钮即可

![image](https://github.com/DeepFal/palworld-Server-AutoBackup-ProcessGuarding/assets/41166795/313e74bc-866d-4d3e-9ab0-5e6e72863b63)
