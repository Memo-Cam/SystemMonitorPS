# Importiere die Module
Import-Module -Name "$PSScriptRoot/SystemMonitorFunctions.psm1"
Import-Module -Name "$PSScriptRoot/RealtimeChart.psm1"
Import-Module -Name "$PSScriptRoot/fenster.psm1"
Import-Module -Name "$PSScriptRoot/Analyse.psm1"
Import-Module -Name "$PSScriptRoot/DataManagement.psm1"

# Überprüfen und Erstellen des Ordners und der Dateien
Ensure-DirectoryAndFiles -directoryPath "$PSScriptRoot/gesammelte_daten" -filePaths @("$PSScriptRoot/gesammelte_daten/gesammelte_daten.csv", "$PSScriptRoot/gesammelte_daten/current_data.csv")

# Erstellen Sie die CSV-Dateien, wenn sie nicht existieren
$gesammelteDatenPath = Join-Path -Path "$PSScriptRoot/gesammelte_daten" -ChildPath "gesammelte_daten.csv"
$currentDataPath = Join-Path -Path "$PSScriptRoot/gesammelte_daten" -ChildPath "current_data.csv"

if (-not (Test-Path $gesammelteDatenPath)) {
    New-Item -ItemType File -Path $gesammelteDatenPath | Out-Null
}

if (-not (Test-Path $currentDataPath)) {
    New-Item -ItemType File -Path $currentDataPath | Out-Null
}

# Starte das Fenster
Show-Window