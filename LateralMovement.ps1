# Simulate lateral movement reconnaissance
$lateralMove = @'
Write-Host "`n[*] Lateral Movement Module" -ForegroundColor Red
Write-Host "[+] Discovering network targets..." -ForegroundColor Yellow

# Scan local subnet
$network = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.IPAddress -notlike "127.*"}).IPAddress
$subnet = $network.Substring(0, $network.LastIndexOf('.'))

Write-Host "[+] Scanning subnet: $subnet.0/24" -ForegroundColor Cyan
1..5 | ForEach-Object {
    $ip = "$subnet.$_"
    Write-Host "    [>] Probing $ip..." -ForegroundColor Gray
    Start-Sleep -Milliseconds 200
}

Write-Host "`n[+] Enumerating domain computers..." -ForegroundColor Yellow
Write-Host "    [>] DC01.contoso.local" -ForegroundColor Gray
Write-Host "    [>] FILE01.contoso.local" -ForegroundColor Gray
Write-Host "    [>] WEB01.contoso.local" -ForegroundColor Gray

Write-Host "`n[+] Checking for admin access..." -ForegroundColor Yellow
Write-Host "    [!] Admin access detected on FILE01" -ForegroundColor Red
Write-Host "    [!] Admin access detected on WEB01" -ForegroundColor Red

Write-Host "`n[+] Simulating Pass-the-Hash attack..." -ForegroundColor Cyan
Write-Host "    [>] Using captured NTLM hash" -ForegroundColor Gray
Write-Host "    [>] Authenticating to FILE01..." -ForegroundColor Gray
Start-Sleep -Seconds 1
Write-Host "    [+] Success! Remote session established" -ForegroundColor Green

Write-Host "`n[*] Lateral movement complete" -ForegroundColor Red
Write-Host "[!] EDR on this system has no visibility into remote attacks" -ForegroundColor Yellow
'@

IEX $lateralMove
