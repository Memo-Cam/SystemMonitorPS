Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

function Show-Window {
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "SystemÃ¼berwachung"
    $form.Size = New-Object System.Drawing.Size(800, 600)
    $form.StartPosition = "CenterScreen"
    $form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
    $form.MaximizeBox = $false

    $containerPanel = New-Object System.Windows.Forms.Panel
    $containerPanel.Size = New-Object System.Drawing.Size(780, 480)
    $containerPanel.Location = New-Object System.Drawing.Point(10, 10)
    $form.Controls.Add($containerPanel)

    $cpuChart = $null
    $ramChart = $null
    $networkChart = $null

    Initialize-Charts -cpuChart ([ref]$cpuChart) -ramChart ([ref]$ramChart) -networkChart ([ref]$networkChart)

    $containerPanel.Controls.Add($cpuChart)
    $containerPanel.Controls.Add($ramChart)
    $containerPanel.Controls.Add($networkChart)

    $cpuInfo = Get-CPUInfo
    $ramInfo = Get-RAMInfo

    $cpuLabel = New-Object System.Windows.Forms.Label
    $cpuLabel.Text = "CPU Auslastung"
    $cpuLabel.Location = New-Object System.Drawing.Point(10, 10)
    $cpuLabel.Size = New-Object System.Drawing.Size(160, 23)
    $containerPanel.Controls.Add($cpuLabel)

    $cpuDetails = New-Object System.Windows.Forms.Label
    $cpuDetails.Text = "Modell: $($cpuInfo.Name)`nMax. Taktfrequenz: $($cpuInfo.MaxClockSpeed) MHz`nKerne: $($cpuInfo.NumberOfCores)"
    $cpuDetails.Location = New-Object System.Drawing.Point(10, 40)
    $cpuDetails.Size = New-Object System.Drawing.Size(160, 60)
    $containerPanel.Controls.Add($cpuDetails)

    $ramLabel = New-Object System.Windows.Forms.Label
    $ramLabel.Text = "RAM Auslastung"
    $ramLabel.Location = New-Object System.Drawing.Point(10, 170)
    $ramLabel.Size = New-Object System.Drawing.Size(160, 23)
    $containerPanel.Controls.Add($ramLabel)

    $ramDetails = New-Object System.Windows.Forms.Label
    $ramDetails.Text = "KapazitÃ¤t: $($ramInfo.Capacity) MB`nGeschwindigkeit: $($ramInfo.Speed) MHz"
    $ramDetails.Location = New-Object System.Drawing.Point(10, 200)
    $ramDetails.Size = New-Object System.Drawing.Size(160, 40)
    $containerPanel.Controls.Add($ramDetails)

    $networkLabel = New-Object System.Windows.Forms.Label
    $networkLabel.Text = "Netzwerk Auslastung"
    $networkLabel.Location = New-Object System.Drawing.Point(10, 330)
    $networkLabel.Size = New-Object System.Drawing.Size(160, 23)
    $containerPanel.Controls.Add($networkLabel)

    $networkDetails = New-Object System.Windows.Forms.Label
    $networkDetails.Text = "Empfangen: `nGesendet: "
    $networkDetails.Location = New-Object System.Drawing.Point(10, 360)
    $networkDetails.Size = New-Object System.Drawing.Size(160, 40)
    $containerPanel.Controls.Add($networkDetails)

    $startButton = New-Object System.Windows.Forms.Button
    $startButton.Text = "Start"
    $startButton.Location = New-Object System.Drawing.Point(10, 500)
    $startButton.Size = New-Object System.Drawing.Size(75, 23)
    $form.Controls.Add($startButton)

    $stopButton = New-Object System.Windows.Forms.Button
    $stopButton.Text = "Stopp"
    $stopButton.Location = New-Object System.Drawing.Point(100, 500)
    $stopButton.Size = New-Object System.Drawing.Size(75, 23)
    $form.Controls.Add($stopButton)

    $resetButton = New-Object System.Windows.Forms.Button
    $resetButton.Text = "Reset"
    $resetButton.Location = New-Object System.Drawing.Point(10, 530)
    $resetButton.Size = New-Object System.Drawing.Size(75, 23)
    $form.Controls.Add($resetButton)

    $saveButton = New-Object System.Windows.Forms.Button
    $saveButton.Text = "Speichern"
    $saveButton.Location = New-Object System.Drawing.Point(100, 530)
    $saveButton.Size = New-Object System.Drawing.Size(75, 23)
    $form.Controls.Add($saveButton)

    $analyzeButton = New-Object System.Windows.Forms.Button
    $analyzeButton.Text = "Analyse"
    $analyzeButton.Location = New-Object System.Drawing.Point(190, 530)
    $analyzeButton.Size = New-Object System.Drawing.Size(75, 23)
    $form.Controls.Add($analyzeButton)

    $timer = New-Object System.Windows.Forms.Timer
    $timer.Interval = 2000  # Intervall auf 2 Sekunden
    $timer.Add_Tick({
        # aktuellen Zustand ermitteln
        $data = [PSCustomObject]@{
            Timestamp    = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
            CPUUsage     = Get-CPUUsage
            RAMUsage     = Get-RAMUsage
            NetworkSpeed = Get-NetworkSpeed
        }

        # Daten in beide CSV-Dateien schreiben
        Save-Data -fileName "current_data.csv" -data $data -append $true
        Save-Data -fileName "gesammelte_daten.csv" -data $data -append $true

        # current_data.csv einlesen und die letzten 60 Zeilen verwenden
        $allData = Load-Data -fileName "current_data.csv"
        if ($allData.Count -gt 60) {
            $allData = $allData[-60..-1]
        }

        # Graph für CPU aktualisieren
        $cpuSeries = $cpuChart.Series["CPU Auslastung"]
        $cpuSeries.Points.Clear()
        foreach ($entry in $allData) {
            $cpuSeries.Points.AddY([double]$entry.CPUUsage) | Out-Null
        }
        $cpuChart.ChartAreas[0].RecalculateAxesScale()

        # Graph für RAM aktualisieren
        $ramSeries = $ramChart.Series["RAM Auslastung"]
        $ramSeries.Points.Clear()
        foreach ($entry in $allData) {
            $ramSeries.Points.AddY([double]$entry.RAMUsage) | Out-Null
        }
        $ramChart.ChartAreas[0].RecalculateAxesScale()

        # Graph für Netzwerk aktualisieren
        $networkSeriesReceived = $networkChart.Series["Netzwerk Empfangen"]
        $networkSeriesSent = $networkChart.Series["Netzwerk Gesendet"]
        $networkSeriesReceived.Points.Clear()
        $networkSeriesSent.Points.Clear()
        foreach ($entry in $allData) {
            $networkSeriesReceived.Points.AddY([double]$entry.NetworkReceived) | Out-Null
            $networkSeriesSent.Points.AddY([double]$entry.NetworkSent) | Out-Null
        }
        $networkChart.ChartAreas[0].RecalculateAxesScale()

        # Netzwerkdetails aktualisieren
        $networkDetails.Text = "Empfangen: $([double]$data.NetworkSpeed[0].ReceivedSpeed) KB/s`nGesendet: $([double]$data.NetworkSpeed[0].SentSpeed) KB/s"
    })

    $startButton.Add_Click({ $timer.Start() })
    $stopButton.Add_Click({ $timer.Stop() })
    $resetButton.Add_Click({
        $cpuChart.Series["CPU Auslastung"].Points.Clear()
        $ramChart.Series["RAM Auslastung"].Points.Clear()
        $networkChart.Series["Netzwerk Empfangen"].Points.Clear()
        $networkChart.Series["Netzwerk Gesendet"].Points.Clear()
        Clear-Content -Path (Get-CurrentDataCsvPath)
    })
    $saveButton.Add_Click({
        $containerImage = New-Object System.Drawing.Bitmap($containerPanel.Width, $containerPanel.Height)
        $containerPanel.DrawToBitmap($containerImage, [System.Drawing.Rectangle]::FromLTRB(0, 0, $containerPanel.Width, $containerPanel.Height))
        $containerImage.Save((Join-Path -Path (Get-DataDirectory) -ChildPath "system_monitoring_data.png"), [System.Drawing.Imaging.ImageFormat]::Png)
    })
    $analyzeButton.Add_Click({
        Show-AnalysisWindow
    })

    $form.Add_Shown({ $form.Activate() })
    [void] $form.ShowDialog()
}