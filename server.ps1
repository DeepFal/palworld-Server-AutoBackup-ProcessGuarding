# 备份文件夹路径
# $source = "C:\Users\Administrator\Desktop\steamcmd\steamapps\common\PalServer\Pal\Saved"
$source = ""
# 备份存储路径
# $destination = "C:\Users\Administrator\Desktop\steamcmd\savedBackup"
$destination = ""
# 服务端路径
# $serverprogram = "C:\Users\Administrator\Desktop\steamcmd\steamapps\common\PalServer\PalServer.exe"
$serverprogram = ""
# 备份副本数量
$maxBackups = 48
# 守护进程名
$processName = "PalServer-Win64-Test-Cmd"

# 创建备份任务的计时器
$backupTimer = New-Object Timers.Timer
$backupTimer.Interval = 1800000 # 设置间隔为30分钟（单位为毫秒）

# 创建检测任务的计时器
$checkTimer = New-Object Timers.Timer
$checkTimer.Interval = 5000 # 设置间隔为5秒（单位为毫秒）

# 创建备份任务的脚本块
$backupScriptBlock = {
    # 创建备份
    $timestamp = Get-Date -Format 'yyyyMMddHHmmss'
    $backupFile = "$destination\Backup$timestamp.zip"
    Compress-Archive -Path $source -DestinationPath $backupFile

    # 打印备份消息
    Write-Host "已创建存档备份 $backupFile"

    # 获取备份文件列表
    $backups = Get-ChildItem $destination -Filter "*.zip" | Sort-Object CreationTime

    # 如果备份数量超过最大值，则删除最旧的备份
    while ($backups.Count -gt $maxBackups) {
        $oldestBackup = $backups[0]
        Remove-Item $oldestBackup.FullName -Force
        $backups = $backups | Where-Object { $_.FullName -ne $oldestBackup.FullName }
    }
}

# 创建检测任务的脚本块
$checkScriptBlock = {
    # 检查进程是否在运行
    $process = Get-Process | Where-Object { $_.ProcessName -eq $global:processName }

    # 如果进程不存在，启动它
    if ($process -eq $null) {
        # 打印重启消息
        Write-Host "检测到 $global:processName 未运行. 正在重启...."
        
        Start-Process -FilePath $serverprogram

        Write-Host "重启完成！"
    }
}

# 创建备份任务的事件
Register-ObjectEvent -InputObject $backupTimer -EventName Elapsed -Action $backupScriptBlock

# 创建检测任务的事件
Register-ObjectEvent -InputObject $checkTimer -EventName Elapsed -Action $checkScriptBlock

# 启动计时器
$backupTimer.Start()
$checkTimer.Start()
