# IISFortify Patching Check
# By Chris Campbell

$ssl3ClientPath = "HKLM:SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0\Client"
$ssl3ServerPath = "HKLM:SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0\Server"
$tls12ClientPath = "HKLM:SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Client"
$tls12ServerPath = "HKLM:SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server"

if ((Test-Path $ssl3ClientPath) -and (Test-Path $ssl3ServerPath) -and (Test-Path $tls12ClientPath) -and (Test-Path $tls12ServerPath))
{
    $ssl3ClientEnabled = (Get-ItemProperty -Path $ssl3ClientPath -Name "Enabled").Enabled
    $ssl3ServerEnabled = (Get-ItemProperty -Path $ssl3ServerPath -Name "Enabled").Enabled
    $tls12ClientEnabled = (Get-ItemProperty -Path $tls12ClientPath -Name "Enabled").Enabled
    $tls12ServerEnabled = (Get-ItemProperty -Path $tls12ServerPath -Name "Enabled").Enabled

    if ($ssl3ClientEnabled -eq 0 -and $ssl3ServerEnabled -eq 0 -and $tls12ClientEnabled -eq 1 -and $tls12ServerEnabled -eq 4294967295)
    {
        Write-Host "Patched!"
    }

    else
    {
        Write-Host "Server Requires Patching. Registry values incorrect."
    }
}

else
{
    Write-Host "Server Requires Patching. Registry keys missing."
}