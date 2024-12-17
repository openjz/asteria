# ---------------------- 1. check current dir ----------------------
# ����������Ŀ¼����
$hugoBinDir = "hugo_bin"
# ��ȡ��ǰĿ¼������
$currentDirectoryName = (Get-Item -Path ".").Name
# �Ƚϵ�ǰĿ¼���ֺ�������Ŀ¼����
if ($currentDirectoryName -ne $hugoBinDir) {
    Write-Error -Message "���� '$hugoBinDir' Ŀ¼��ִ������ű�������ǰĿ¼�� '$currentDirectoryName'"
    exit 1
}

# ---------------------- 2. delete old files ----------------------
# ����Ҫ�����Ŀ¼·��
$directoryPath = "../../"

# ��ȡָ��Ŀ¼�µ������ļ���Ŀ¼
# $items = Get-ChildItem -Path $directoryPath -Recurse
$items = Get-ChildItem -Path $directoryPath # ���ݹ��ȡ��ֻ��ȡһ����Ŀ¼���ļ�

# ���˵�asteria_sourceĿ¼��CNAME�ļ�
$itemsToRemove = $items | Where-Object { 
    -not ($_.Name -eq "CNAME") -and 
    # -not ($_.FullName -like "*\asteria_source*") -and 
    -not ($_.PSIsContainer -and $_.Name -eq "asteria_source") 
}

# ����Ҫɾ������Ŀ����ɾ������
foreach ($item in $itemsToRemove) {
    if ($item.PSIsContainer) {
        # �����Ŀ¼����ݹ�ɾ��
        Remove-Item -Path $item.FullName -Recurse -Force -Confirm:$false
        Write-Output "Delete dir��$item.Name"
    } else {
        # ������ļ�����ֱ��ɾ��
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