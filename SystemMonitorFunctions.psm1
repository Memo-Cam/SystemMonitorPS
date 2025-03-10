function Get-CPUUsage {
    $cpuCounter = New-Object System.Diagnostics.PerformanceCounter("Processor", "% Processor Time", "_Total")
    $cpuCounter.NextValue() | Out-Null
    Start-Sleep -Milliseconds 500
    return [math]::Round($cpuCounter.NextValue(), 2)
}

function Get-RAMUsage {
    $ramCounter = New-Object System.Diagnostics.PerformanceCounter("Memory", "Available MBytes")
    $totalMemory = [math]::Round((Get-WmiObject -Class Win32_ComputerSystem).TotalPhysicalMemory / 1MB, 2)
    $availableMemory = $ramCounter.NextValue()
    $usedMemory = $totalMemory - $availableMemory
    return [PSCustomObject]@{
        UsedPercentage = [math]::Round(($usedMemory / $totalMemory) * 100, 2)
        TotalMemory = $totalMemory
        UsedMemory = $usedMemory
    }
}

function Get-NetworkUsage {
    $networkInterfaces = [System.Net.NetworkInformation.NetworkInterface]::GetAllNetworkInterfaces()
    $networkStats = @()
    foreach ($interface in $networkInterfaces) {
        $stats = $interface.GetIPv4Statistics()
        $networkStats += [PSCustomObject]@{
            Name = $interface.Name
            BytesReceived = $stats.BytesReceived
            BytesSent = $stats.BytesSent
        }
    }
    return $networkStats
}

function Get-NetworkSpeed {
    $initialStats = Get-NetworkUsage
    Start-Sleep -Seconds 1
    $finalStats = Get-NetworkUsage

    $networkSpeed = @()
    for ($i = 0; $i -lt $initialStats.Count; $i++) {
        $receivedSpeed = ($finalStats[$i].BytesReceived - $initialStats[$i].BytesReceived) / 1024
        $sentSpeed = ($finalStats[$i].BytesSent - $initialStats[$i].BytesSent) / 1024
        $networkSpeed += [PSCustomObject]@{
            Name = $initialStats[$i].Name
            ReceivedSpeed = [math]::Round($receivedSpeed, 2)
            SentSpeed = [math]::Round($sentSpeed, 2)
        }
    }
    return $networkSpeed
}

function Get-CPUInfo {
    $cpu = Get-WmiObject -Class Win32_Processor
    return [PSCustomObject]@{
        Name = $cpu.Name
        MaxClockSpeed = $cpu.MaxClockSpeed
        NumberOfCores = $cpu.NumberOfCores
    }
}

function Get-RAMInfo {
    $ram = Get-WmiObject -Class Win32_PhysicalMemory
    $totalCapacity = ($ram | Measure-Object -Property Capacity -Sum).Sum
    $speed = ($ram | Select-Object -ExpandProperty Speed | Measure-Object -Maximum).Maximum
    return [PSCustomObject]@{
        Capacity = [math]::Round($totalCapacity / 1MB, 2)
        Speed = $speed
    }
}