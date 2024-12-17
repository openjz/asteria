# ---------------------- 1. check current dir ----------------------
# 定义期望的目录名字
$hugoBinDir = "hugo_bin"
# 获取当前目录的名字
$currentDirectoryName = (Get-Item -Path ".").Name
# 比较当前目录名字和期望的目录名字
if ($currentDirectoryName -ne $hugoBinDir) {
    Write-Error -Message "请在 '$hugoBinDir' 目录下执行这个脚本，但当前目录是 '$currentDirectoryName'"
    exit 1
}

# ---------------------- 2. delete old files ----------------------
# 定义要清理的目录路径
$directoryPath = "../../"

# 获取指定目录下的所有文件和目录
# $items = Get-ChildItem -Path $directoryPath -Recurse
$items = Get-ChildItem -Path $directoryPath # 不递归获取，只获取一级子目录和文件

# 过滤掉asteria_source目录和CNAME文件
$itemsToRemove = $items | Where-Object { 
    -not ($_.Name -eq "CNAME") -and 
    # -not ($_.FullName -like "*\asteria_source*") -and 
    -not ($_.PSIsContainer -and $_.Name -eq "asteria_source") 
}

# 遍历要删除的项目，并删除它们
foreach ($item in $itemsToRemove) {
    if ($item.PSIsContainer) {
        # 如果是目录，则递归删除
        Remove-Item -Path $item.FullName -Recurse -Force -Confirm:$false
        Write-Output "Delete dir：$item.Name"
    } else {
        # 如果是文件，则直接删除
        Remove-Item -Path $item.FullName -Force -Confirm:$false
        Write-Output "Delete file: $item.Name"
    }
}

# ---------------------- 3. hugo build ----------------------
Set-Location ../source
$hugoPath = "../hugo_bin/hugo.exe"
&$hugoPath

# ---------------------- 4. reset location ----------------------
Set-Location ../hugo_bin