@echo off

echo IIS Security Hardening Script v1.2.0
rem Informational.
echo By Chris Campbell
echo.

rem Run registry script to apply crypto changes.
echo Applying optimal SSL+TLS configuration...
echo.

VER | FINDSTR /L "5.2." > NUL
IF %ERRORLEVEL% EQU 0 SET OSVersion=2003

VER | FINDSTR /L "6.1." > NUL
IF %ERRORLEVEL% EQU 0 SET OSVersion=2008

VER | FINDSTR /L "6.3." > NUL
IF %ERRORLEVEL% EQU 0 SET OSVersion=2012

VER | FINDSTR /L "10.0." > NUL
IF %ERRORLEVEL% EQU 0 SET OSVersion=2016

IF %OSVersion%==Unknown (
 echo Unable to determine your version of Windows.
)
IF %OSVersion%==2003 (
 rem OS is Server 2003/2003 R2 x86.
 IF %PROCESSOR_ARCHITECTURE%==x86 (
  "%~dp0\CryptoConfig_2003x86_Hotfix.exe" /passive /norestart
  regedit.exe /S "%~dp0\CryptoConfig_2003.reg"
  echo Applied registry patch and hotfix for 2003 x86.
 )
 rem OS is Server 2003/2003 R2 x64.
 IF %PROCESSOR_ARCHITECTURE%==x64 (
  "%~dp0\CryptoConfig_2003x64_Hotfix.exe" /passive /norestart
  regedit.exe /S "%~dp0\CryptoConfig_2003.reg"
  echo Applied registry patch and hotfix for 2003 x64.
 ) 
  echo Applying secure response headers and removing default...
  echo.
  cscript C:\Inetpub\AdminScripts\adsutil.vbs SET W3SVC\HTTPCustomHeaders "Strict-Transport-Security: max-age=31536000; includeSubDomains" "cache-control: private, max-age=0, no-cache" "X-Content-Type-Options: nosniff" "X-XSS-Protection: 1; mode=block" "X-Frame-Options: SAMEORIGIN" "X-Download-Options: noopen"
)
rem OS is Server 2008/2008 R2.
IF %OSVersion%==2008 (
 regedit.exe /S "%~dp0\CryptoConfig_2008.reg"
 echo Applied registry patch for 2008. Continuing with HTTP Response Header configuration.
 set 2008or2012=1
)

rem OS is Server 2012/2012 R2.
IF %OSVersion%==2012 (
 regedit.exe /S "%~dp0\CryptoConfig_2012.reg"
 echo Applied registry patch for 2012. Continuing with HTTP Response Header configuration.
 set 2008or2012=1
)

rem OS is Server 2016.
IF %OSVersion%==2016 (
 regedit.exe /S "%~dp0\CryptoConfig_2016.reg"
 echo Applied registry patch for 2016. Continuing with HTTP Response Header configuration.
 set 2008or2012or2016=1
)

IF defined 2008or2012or2016 (
 rem Add secure headers.
 echo Applying secure response headers...
 echo.
 %windir%\system32\inetsrv\appcmd set config /section:httpProtocol /+customHeaders.[name='Strict-Transport-Security',value='"max-age=31536000; includeSubDomains"']
 %windir%\system32\inetsrv\appcmd set config /section:httpProtocol /+customHeaders.[name='cache-control',value='"private, max-age=0, no-cache"']
 %windir%\system32\inetsrv\appcmd set config /section:httpProtocol /+customHeaders.[name='X-Content-Type-Options',value='nosniff']
 %windir%\system32\inetsrv\appcmd set config /section:httpProtocol /+customHeaders.[name='X-XSS-Protection',value='"1; mode=block"']
 %windir%\system32\inetsrv\appcmd set config /section:httpProtocol /+customHeaders.[name='X-Frame-Options',value='SAMEORIGIN']
 %windir%\system32\inetsrv\appcmd set config /section:httpProtocol /+customHeaders.[name='X-Download-Options',value='noopen']

 rem Remove insecure headers.
 echo Removing pesky default headers...
 echo.
 %windir%\system32\inetsrv\appcmd set config /section:httpProtocol /-customHeaders.[name='X-Powered-By']
)

rem Informational.
echo.
echo Headers configured. You'll need to manually configure the cache-control header according to individual application requirements. As a default it has been set to private to prevent proxy caching. Similarly, the X-Frame-Options may need adjustment to allow cross-domain iframes.
echo.

rem Completion tasks.
echo Script complete!