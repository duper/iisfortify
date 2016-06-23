@echo off
reg export "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders" SecurityProviders_BKP.reg
reg export "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Cryptography\Configuration\Local\SSL\00010002" CipherSuitesHex_BKP.reg
reg export "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002" CipherSuites_BKP.reg
copy SecurityProviders_BKP.reg+CipherSuitesHex_BKP.reg+CipherSuites_BKP.reg CryptoBackup.reg
del SecurityProviders_BKP.reg CipherSuitesHex_BKP.reg CipherSuites_BKP.reg