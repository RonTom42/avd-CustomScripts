param
(    
    [Parameter(Mandatory = $true)]
    [string]$HostPoolName,

    [Parameter(Mandatory = $true)]
    [string]$RegistrationInfoToken,

    [Parameter(mandatory = $false)]
    [switch]$EnableVerboseMsiLogging,

    [Parameter(mandatory = $true)]
    [string]$DomainJoinDomain,

    [Parameter(mandatory = $true)]
    [string]$DomainJoinUser,

    [Parameter(mandatory = $true)]
    [string]$DomainJoinPassword,

    [Parameter(mandatory = $true)]
    [string]$OUPath
)

# Set startupType of Azure Connected Machine agent to auto (not auto delyed start)
# for faster update in AzureRM
sc.exe config himds start= auto

# Download and unzip Microsoft's dsc zip
$dsc_dir = (Get-Item .).FullName
# $dsc_ps_path = [IO.Path]::Combine($dsc_dir, 'Configuration.ps1')
Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/Azure/RDS-Templates/master/ARM-wvd-templates/DSC/Configuration.zip' -outfile $dsc_dir\Configuration.zip -UseBasicParsing
Get-ChildItem $dsc_dir\Configuration.zip | Expand-Archive -DestinationPath $dsc_dir

# Install RDS Agent and register
& $dsc_dir\Script-SetupSessionHost.ps1 -HostPoolName $HostPoolName -RegistrationInfoToken $RegistrationInfoToken -EnableVerboseMsiLogging:$EnableVerboseMsiLogging 

# Add computer to domain
# $DomainJoinCredential = New-object –TypeName System.Management.Automation.PSCredential -ArgumentList ("$($DomainJoinDomain)\$($DomainJoinUser)", ($DomainJoinPassword | ConvertTo-SecureString –asPlainText –Force)) 
# Add-Computer -DomainName $DomainJoinDomain -OUPath $OUPath -Credential $DomainJoinCredential -Reboot -Force
 
