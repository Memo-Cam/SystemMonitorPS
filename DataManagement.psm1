function Ensure-Directory {
    param (
        [string]$directoryPath
    )
    if (-not (Test-Path $directoryPath)) {
        New-Item -ItemType Directory -Path $directoryPath | Out-Null
    }
}

function Ensure-DirectoryAndFiles {
    param (
        [string]$directoryPath,
        [string[]]$filePaths
    )
    Ensure-Directory -directoryPath $directoryPath
    foreach ($filePath in $filePaths) {
        if (-not (Test-Path $filePath)) {
            New-Item -ItemType File -Path $filePath | Out-Null
        }
    }
}

function Get-DataDirectory {
    $scriptPath = $PSScriptRoot
    if ([string]::IsNullOrEmpty($scriptPath)) {
        throw "PSScriptRoot is null or empty."
    }
    return Join-Path -Path $scriptPath -ChildPath "gesammelte_daten"
}

function Get-CurrentDataCsvPath {
    return Join-Path -Path (Get-DataDirectory) -ChildPath "current_data.csv"
}

function Get-GesammelteDatenCsvPath {
    return Join-Path -Path (Get-DataDirectory) -ChildPath "gesammelte_daten.csv"
}

function Save-Data {
    param (
        [string]$fileName,   
        [PSCustomObject]$data,
        [bool]$append = $true
    )
    $dataDir = Get-DataDirectory
    Ensure-Directory -directoryPath $dataDir
    $fullPath = Join-Path -Path $dataDir -ChildPath $fileName  

    $csvData = "$($data.Timestamp),$($data.CPUUsage),$($data.RAMUsage.UsedPercentage),$($data.NetworkSpeed[0].ReceivedSpeed),$($data.NetworkSpeed[0].SentSpeed)"

    if ($append) {
        Add-Content -Path $fullPath -Value $csvData
    } else {
        Set-Content -Path $fullPath -Value $csvData
    }
}

function Load-Data {
    param (
        [string]$fileName
    )
    $dataDir = Get-DataDirectory
    Ensure-Directory -directoryPath $dataDir
    $fullPath = Join-Path -Path $dataDir -ChildPath $fileName
    if (Test-Path $fullPath) {
        $data = Import-Csv -Path $fullPath -Header "Timestamp", "CPUUsage", "RAMUsage", "NetworkReceived", "NetworkSent"
        return $data
    } else {
        Write-Host "No data found at $fullPath."
        return $null
    }
}