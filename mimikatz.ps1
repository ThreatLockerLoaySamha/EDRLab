# Create a safe Mimikatz simulation (doesn't actually dump credentials)
$safeMimikatz = @'
function Invoke-SafeMimikatz {
    $banner = @"
  .#####.   mimikatz 2.2.0 (x64) #19041 Sep 19 2022 17:44:08
 .## ^ ##.  "A La Vie, A L'Amour" - (oe.eo)
 ## / \ ##  /*** Benjamin DELPY `gentilkiwi` ( benjamin@gentilkiwi.com )
 ## \ / ##       > https://blog.gentilkiwi.com/mimikatz
 '## v ##'       Vincent LE TOUX             ( vincent.letoux@gmail.com )
  '#####'        > https://pingcastle.com / https://mysmartlogon.com ***/
"@
    
    Write-Host $banner -ForegroundColor Yellow
    Write-Host "`nmimikatz(powershell) # " -NoNewline -ForegroundColor Cyan
    Write-Host "sekurlsa::logonpasswords" -ForegroundColor White
    Start-Sleep -Milliseconds 500
    
    Write-Host "`nAuthentication Id : 0 ; 996 (00000000:000003e4)" -ForegroundColor Gray
    Write-Host "Session           : Service from 0" -ForegroundColor Gray
    Write-Host "User Name         : $env:COMPUTERNAME$" -ForegroundColor Gray
    Write-Host "Domain            : $env:USERDOMAIN" -ForegroundColor Gray
    Write-Host "Logon Server      : (null)" -ForegroundColor Gray
    Write-Host "Logon Time        : $(Get-Date)" -ForegroundColor Gray
    Write-Host "SID               : S-1-5-18" -ForegroundColor Gray
    Write-Host "        msv :" -ForegroundColor Magenta
    Write-Host "        tspkg :" -ForegroundColor Magenta
    Write-Host "        wdigest :" -ForegroundColor Magenta
    Write-Host "         * Username : $env:USERNAME" -ForegroundColor Yellow
    Write-Host "         * Domain   : $env:USERDOMAIN" -ForegroundColor Yellow
    Write-Host "         * Password : (PROTECTED)" -ForegroundColor Red
    Write-Host "        kerberos :" -ForegroundColor Magenta
    Write-Host "         * Username : $env:USERNAME" -ForegroundColor Yellow
    Write-Host "         * Domain   : $env:USERDOMAIN" -ForegroundColor Yellow
    Write-Host "         * Password : (PROTECTED)" -ForegroundColor Red
    Write-Host "`n[!] This is a simulation - no actual credentials extracted" -ForegroundColor Green
    Write-Host "[!] Real Mimikatz would dump plaintext passwords from memory" -ForegroundColor Yellow
    Write-Host "[!] EDR may detect Mimikatz signatures but not always obfuscated versions" -ForegroundColor Red
}
'@

$safeMimikatz | Out-File /home/kali/EDRLab/lab2/mimikatz.ps1
Write-Host "Safe Mimikatz simulation created!" -ForegroundColor Green
