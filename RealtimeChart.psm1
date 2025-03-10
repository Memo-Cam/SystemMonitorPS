Add-Type -AssemblyName System.Windows.Forms.DataVisualization

function Initialize-Charts {
    param (
        [ref]$cpuChart,
        [ref]$ramChart,
        [ref]$networkChart
    )

    # CPU Chart
    $cpuChart.Value = New-Object System.Windows.Forms.DataVisualization.Charting.Chart
    $cpuChart.Value.Size = New-Object System.Drawing.Size(600, 150)
    $cpuChart.Value.Location = New-Object System.Drawing.Point(180, 10)
    $cpuChartArea = New-Object System.Windows.Forms.DataVisualization.Charting.ChartArea
    $cpuChartArea.AxisY.Title = "Prozent (%)"
    $cpuChart.Value.ChartAreas.Add($cpuChartArea)
    $cpuSeries = New-Object System.Windows.Forms.DataVisualization.Charting.Series
    $cpuSeries.ChartType = [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]::Line
    $cpuSeries.Name = "CPU Auslastung"
    $cpuChart.Value.Series.Add($cpuSeries)
    $cpuChart.Value.Legends.Add("Legende")
    $cpuChart.Value.Series["CPU Auslastung"].LegendText = "CPU Auslastung (%)"

    # RAM Chart
    $ramChart.Value = New-Object System.Windows.Forms.DataVisualization.Charting.Chart
    $ramChart.Value.Size = New-Object System.Drawing.Size(600, 150)
    $ramChart.Value.Location = New-Object System.Drawing.Point(180, 170)
    $ramChartArea = New-Object System.Windows.Forms.DataVisualization.Charting.ChartArea
    $ramChartArea.AxisY.Title = "Prozent (%)"
    $ramChart.Value.ChartAreas.Add($ramChartArea)
    $ramSeries = New-Object System.Windows.Forms.DataVisualization.Charting.Series
    $ramSeries.ChartType = [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]::Line
    $ramSeries.Name = "RAM Auslastung"
    $ramChart.Value.Series.Add($ramSeries)
    $ramChart.Value.Legends.Add("Legende")
    $ramChart.Value.Series["RAM Auslastung"].LegendText = "RAM Auslastung (%)"

    # Network Chart
    $networkChart.Value = New-Object System.Windows.Forms.DataVisualization.Charting.Chart
    $networkChart.Value.Size = New-Object System.Drawing.Size(600, 150)
    $networkChart.Value.Location = New-Object System.Drawing.Point(180, 330)
    $networkChartArea = New-Object System.Windows.Forms.DataVisualization.Charting.ChartArea
    $networkChartArea.AxisY.Title = "Geschwindigkeit (KB/s)"
    $networkChart.Value.ChartAreas.Add($networkChartArea)
    $networkSeriesReceived = New-Object System.Windows.Forms.DataVisualization.Charting.Series
    $networkSeriesReceived.ChartType = [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]::Line
    $networkSeriesReceived.Name = "Netzwerk Empfangen"
    $networkChart.Value.Series.Add($networkSeriesReceived)
    $networkSeriesSent = New-Object System.Windows.Forms.DataVisualization.Charting.Series
    $networkSeriesSent.ChartType = [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]::Line
    $networkSeriesSent.Name = "Netzwerk Gesendet"
    $networkChart.Value.Series.Add($networkSeriesSent)
    $networkChart.Value.Legends.Add("Legende")
    $networkChart.Value.Series["Netzwerk Empfangen"].LegendText = "Empfangen (KB/s)"
    $networkChart.Value.Series["Netzwerk Gesendet"].LegendText = "Gesendet (KB/s)"
}