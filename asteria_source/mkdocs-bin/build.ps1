# ---------------------- 1. check current dir ----------------------
$BinDir = "mkdocs-bin"
$currentDirectoryName = (Get-Item -Path ".").Name
if ($currentDirectoryName -ne $BinDir) {
    Write-Error -Message "Must be in '$BinDir' directory, but current directory is '$currentDirectoryName'"
    exit 1
}

# ---------------------- 2. delete old files ----------------------
$directoryPath = "../../"

$items = Get-ChildItem -Path $directoryPath 

$itemsToRemove = $items | Where-Object { 
    -not ($_.Name -eq "CNAME") -and 
    -not ($_.PSIsContainer -and $_.Name -eq "asteria_source") 
}

foreach ($item in $itemsToRemove) {
    if ($item.PSIsContainer) {
        
        Remove-Item -Path $item.FullName -Recurse -Force -Confirm:$false
        Write-Output "Delete dir: $item.Name"
    } else {
        
        Remove-Item -Path $item.FullName -Force -Confirm:$false
        Write-Output "Delete file: $item.Name"
    }
}

# ---------------------- 3. build ----------------------
Set-Location ../mkdocs-source

# 运行 mkdocs build
& mkdocs build
if ($LASTEXITCODE -ne 0) {
    throw "mkdocs build failed，code：$LASTEXITCODE"
}

# 将生成的 site 内容拷贝到工作区根目录（../../）
$sourceDir = "site"
$destDir = "../../"
if (-not (Test-Path $sourceDir)) {
    throw "Dose not exist: $sourceDir"
}
Copy-Item -Path "$sourceDir\*" -Destination $destDir -Recurse -Force
Write-Output "Copy: $sourceDir -> $destDir"

# 拷贝完成后删除 site 目录
Remove-Item -Path $sourceDir -Recurse -Force -Confirm:$false
Write-Output "Delete dir: $sourceDir"

# ---------------------- 4. reset location ----------------------
Set-Location -Path ../$BinDir