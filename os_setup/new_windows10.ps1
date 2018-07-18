# Install Cmder console emulator
$CmderDownloadDir = "C:\Program Files"
$CmderZipFile = "$CmderDownloadDir\cmder.zip"
$CmderDir = "$CmderDownloadDir\cmder" 
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri https://github.com/cmderdev/cmder/releases/download/v1.3.6/cmder.zip -OutFile "$CmderZipFile"
[System.IO.Compression.ZipFile]::ExtractToDirectory("cmder.zip", "$CmderDir")

# Add cmder directory to system Path
Set-ItemProperty -Path ‘Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager
\Environment’ -Name PATH -Value "$Env:Path;$CmderDir"

# Remove downloaded ZipFile
 rm -r -Force $CmderZipFile