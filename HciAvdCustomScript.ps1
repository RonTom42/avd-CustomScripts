param
(    
    [Parameter(Mandatory = $true)]
    [string]$HostPoolName,

    [Parameter(Mandatory = $true)]
    [string]$RegistrationInfoToken,

    [Parameter(mandatory = $false)]
    [switch]$EnableVerboseMsiLogging
)

# Set startupType of Azure Connected Machine agent to auto (not auto delyed start)
# for faster update in AzureRM
sc.exe config himds start= auto

# Disable and stop Windows Update Service
sc.exe config wuauserv start=disabled
sc.exe stop wuauserv

# Download and unzip Microsoft's dsc zip
$dsc_dir = (Get-Item .).FullName
Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/Azure/RDS-Templates/master/ARM-wvd-templates/DSC/Configuration.zip' -outfile $dsc_dir\Configuration.zip -UseBasicParsing
Get-ChildItem $dsc_dir\Configuration.zip | Expand-Archive -DestinationPath $dsc_dir

# Install RDS Agent and register
write-output "Installing RDS agent..."
& $dsc_dir\Script-SetupSessionHost.ps1 -HostPoolName $HostPoolName -RegistrationInfoToken $RegistrationInfoToken -EnableVerboseMsiLogging:$true #$EnableVerboseMsiLogging 
