Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

function Show-AnalysisWindow {
    $currentDataFileName = "current_data.csv"
    $gesammelteDatenFileName = "gesammelte_daten.csv"
    
    $currentData = Load-Data -fileName $currentDataFileName
    $gesammelteDaten = Load-Data -fileName $gesammelteDatenFileName

    if ($currentData -eq $null -or $gesammelteDaten -eq $null) {
        Write-Host "No data found."
        return
    }

    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Analyse"
    $form.Size = New-Object System.Drawing.Size(800, 600)
    $form.StartPosition = "CenterScreen"

    $averageCurrentCPUUsage = [math]::Round(($currentData | Measure-Object -Property CPUUsage -Average).Average, 2)
    $averageCurrentRAMUsage = [math]::Round(($currentData | Measure-Object -Property RAMUsage -Average).Average, 2)
    $averageCurrentNetworkReceived = [math]::Round(($currentData | Measure-Object -Property NetworkReceived -Average).Average, 2)
    $averageCurrentNetworkSent = [math]::Round(($currentData | Measure-Object -Property NetworkSent -Average).Average, 2)

    $averageGesammelteCPUUsage = [math]::Round(($gesammelteDaten | Measure-Object -Property CPUUsage -Average).Average, 2)
    $averageGesammelteRAMUsage = [math]::Round(($gesammelteDaten | Measure-Object -Property RAMUsage -Average).Average, 2)
    $averageGesammelteNetworkReceived = [math]::Round(($gesammelteDaten | Measure-Object -Property NetworkReceived -Average).Average, 2)
    $averageGesammelteNetworkSent = [math]::Round(($gesammelteDaten | Measure-Object -Property NetworkSent -Average).Average, 2)

    $maxCurrentCPUUsage = [math]::Round(($currentData | Measure-Object -Property CPUUsage -Maximum).Maximum, 2)
    $minCurrentCPUUsage = [math]::Round(($currentData | Measure-Object -Property CPUUsage -Minimum).Minimum, 2)
    $maxCurrentRAMUsage = [math]::Round(($currentData | Measure-Object -Property RAMUsage -Maximum).Maximum, 2)
    $minCurrentRAMUsage = [math]::Round(($currentData | Measure-Object -Property RAMUsage -Minimum).Minimum, 2)
    $maxCurrentNetworkReceived = [math]::Round(($currentData | Measure-Object -Property NetworkReceived -Maximum).Maximum, 2)
    $minCurrentNetworkReceived = [math]::Round(($currentData | Measure-Object -Property NetworkReceived -Minimum).Minimum, 2)
    $maxCurrentNetworkSent = [math]::Round(($currentData | Measure-Object -Property NetworkSent -Maximum).Maximum, 2)
    $minCurrentNetworkSent = [math]::Round(($currentData | Measure-Object -Property NetworkSent -Minimum).Minimum, 2)

    $maxGesammelteCPUUsage = [math]::Round(($gesammelteDaten | Measure-Object -Property CPUUsage -Maximum).Maximum, 2)
    $minGesammelteCPUUsage = [math]::Round(($gesammelteDaten | Measure-Object -Property CPUUsage -Minimum).Minimum, 2)
    $maxGesammelteRAMUsage = [math]::Round(($gesammelteDaten | Measure-Object -Property RAMUsage -Maximum).Maximum, 2)
    $minGesammelteRAMUsage = [math]::Round(($gesammelteDaten | Measure-Object -Property RAMUsage -Minimum).Minimum, 2)
    $maxGesammelteNetworkReceived = [math]::Round(($gesammelteDaten | Measure-Object -Property NetworkReceived -Maximum).Maximum, 2)
    $minGesammelteNetworkReceived = [math]::Round(($gesammelteDaten | Measure-Object -Property NetworkReceived -Minimum).Minimum, 2)
    $maxGesammelteNetworkSent = [math]::Round(($gesammelteDaten | Measure-Object -Property NetworkSent -Maximum).Maximum, 2)
    $minGesammelteNetworkSent = [math]::Round(($gesammelteDaten | Measure-Object -Property NetworkSent -Minimum).Minimum, 2)

    $analysisLabel = New-Object System.Windows.Forms.Label
    $analysisLabel.Text = "Analyse Ergebnisse"
    $analysisLabel.Location = New-Object System.Drawing.Point(10, 10)
    $analysisLabel.Size = New-Object System.Drawing.Size(160, 23)
    $form.Controls.Add($analysisLabel)

    $currentDataLabel = New-Object System.Windows.Forms.Label
    $currentDataLabel.Text = "Current Data"
    $currentDataLabel.Location = New-Object System.Drawing.Point(10, 40)
    $currentDataLabel.Size = New-Object System.Drawing.Size(300, 23)
    $form.Controls.Add($currentDataLabel)

    $gesammelteDatenLabel = New-Object System.Windows.Forms.Label
    $gesammelteDatenLabel.Text = "Gesammelte Daten"
    $gesammelteDatenLabel.Location = New-Object System.Drawing.Point(400, 40)
    $gesammelteDatenLabel.Size = New-Object System.Drawing.Size(300, 23)
    $form.Controls.Add($gesammelteDatenLabel)

    $cpuAnalysisCurrent = New-Object System.Windows.Forms.Label
    $cpuAnalysisCurrent.Text = "CPU Auslastung: $averageCurrentCPUUsage %`nMax CPU: $maxCurrentCPUUsage %, Min CPU: $minCurrentCPUUsage %"
    $cpuAnalysisCurrent.Location = New-Object System.Drawing.Point(10, 70)
    $cpuAnalysisCurrent.Size = New-Object System.Drawing.Size(300, 46)
    $form.Controls.Add($cpuAnalysisCurrent)

    $cpuAnalysisGesammelte = New-Object System.Windows.Forms.Label
    $cpuAnalysisGesammelte.Text = "CPU Auslastung: $averageGesammelteCPUUsage %`nMax CPU: $maxGesammelteCPUUsage %, Min CPU: $minGesammelteCPUUsage %"
    $cpuAnalysisGesammelte.Location = New-Object System.Drawing.Point(400, 70)
    $cpuAnalysisGesammelte.Size = New-Object System.Drawing.Size(300, 46)
    $form.Controls.Add($cpuAnalysisGesammelte)

    $ramAnalysisCurrent = New-Object System.Windows.Forms.Label
    $ramAnalysisCurrent.Text = "RAM Auslastung: $averageCurrentRAMUsage %`nMax RAM: $maxCurrentRAMUsage %, Min RAM: $minCurrentRAMUsage %"
    $ramAnalysisCurrent.Location = New-Object System.Drawing.Point(10, 120)
    $ramAnalysisCurrent.Size = New-Object System.Drawing.Size(300, 46)
    $form.Controls.Add($ramAnalysisCurrent)

    $ramAnalysisGesammelte = New-Object System.Windows.Forms.Label
    $ramAnalysisGesammelte.Text = "RAM Auslastung: $averageGesammelteRAMUsage %`nMax RAM: $maxGesammelteRAMUsage %, Min RAM: $minGesammelteRAMUsage %"
    $ramAnalysisGesammelte.Location = New-Object System.Drawing.Point(400, 120)
    $ramAnalysisGesammelte.Size = New-Object System.Drawing.Size(300, 46)
    $form.Controls.Add($ramAnalysisGesammelte)

    $networkReceivedAnalysisCurrent = New-Object System.Windows.Forms.Label
    $networkReceivedAnalysisCurrent.Text = "Netzwerk Empfangen: $averageCurrentNetworkReceived KB/s`nMax Netzwerk Empfangen: $maxCurrentNetworkReceived KB/s, Min Netzwerk Empfangen: $minCurrentNetworkReceived KB/s"
    $networkReceivedAnalysisCurrent.Location = New-Object System.Drawing.Point(10, 170)
    $networkReceivedAnalysisCurrent.Size = New-Object System.Drawing.Size(300, 46)
    $form.Controls.Add($networkReceivedAnalysisCurrent)

    $networkReceivedAnalysisGesammelte = New-Object System.Windows.Forms.Label
    $networkReceivedAnalysisGesammelte.Text = "Netzwerk Empfangen: $averageGesammelteNetworkReceived KB/s`nMax Netzwerk Empfangen: $maxGesammelteNetworkReceived KB/s, Min Netzwerk Empfangen: $minGesammelteNetworkReceived KB/s"
    $networkReceivedAnalysisGesammelte.Location = New-Object System.Drawing.Point(400, 170)
    $networkReceivedAnalysisGesammelte.Size = New-Object System.Drawing.Size(300, 46)
    $form.Controls.Add($networkReceivedAnalysisGesammelte)

    $networkSentAnalysisCurrent = New-Object System.Windows.Forms.Label
    $networkSentAnalysisCurrent.Text = "Netzwerk Gesendet: $averageCurrentNetworkSent KB/s`nMax Netzwerk Gesendet: $maxCurrentNetworkSent KB/s, Min Netzwerk Gesendet: $minCurrentNetworkSent KB/s"
    $networkSentAnalysisCurrent.Location = New-Object System.Drawing.Point(10, 220)
    $networkSentAnalysisCurrent.Size = New-Object System.Drawing.Size(300, 46)
    $form.Controls.Add($networkSentAnalysisCurrent)

    $networkSentAnalysisGesammelte = New-Object System.Windows.Forms.Label
    $networkSentAnalysisGesammelte.Text = "Netzwerk Gesendet: $averageGesammelteNetworkSent KB/s`nMax Netzwerk Gesendet: $maxGesammelteNetworkSent KB/s, Min Netzwerk Gesendet: $minGesammelteNetworkSent KB/s"
    $networkSentAnalysisGesammelte.Location = New-Object System.Drawing.Point(400, 220)
    $networkSentAnalysisGesammelte.Size = New-Object System.Drawing.Size(300, 46)
    $form.Controls.Add($networkSentAnalysisGesammelte)

    $deviationLabel = New-Object System.Windows.Forms.Label
    $deviationLabel.Text = "Abweichung"
    $deviationLabel.Location = New-Object System.Drawing.Point(10, 280)
    $deviationLabel.Size = New-Object System.Drawing.Size(780, 23)
    $deviationLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
    $form.Controls.Add($deviationLabel)

    $cpuDeviation = [math]::Round($averageCurrentCPUUsage - $averageGesammelteCPUUsage, 2)
    $ramDeviation = [math]::Round($averageCurrentRAMUsage - $averageGesammelteRAMUsage, 2)
    $networkReceivedDeviation = [math]::Round($averageCurrentNetworkReceived - $averageGesammelteNetworkReceived, 2)
    $networkSentDeviation = [math]::Round($averageCurrentNetworkSent - $averageGesammelteNetworkSent, 2)

    $deviationDetails = New-Object System.Windows.Forms.Label
    $deviationDetails.Text = "CPU Abweichung: $cpuDeviation %`nRAM Abweichung: $ramDeviation %`nNetzwerk Empfangen Abweichung: $networkReceivedDeviation KB/s`nNetzwerk Gesendet Abweichung: $networkSentDeviation KB/s"
    $deviationDetails.Location = New-Object System.Drawing.Point(10, 310)
    $deviationDetails.Size = New-Object System.Drawing.Size(780, 80)
    $deviationDetails.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
    $form.Controls.Add($deviationDetails)

    $form.Add_Shown({ $form.Activate() })
    [void] $form.ShowDialog()
}