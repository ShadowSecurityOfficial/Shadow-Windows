$ErrorActionPreference = 'Continue'

# Global values
# TODO: Do we need these here?
$cache = "${Env:UserProfile}\AppData\Local\ChocoCache"
$globalCinstArgs  = "--cacheLocation $cache -y"


# ################################################################################################ #
# \ \ ---------------------------------------- N O T E ---------------------------------------- / /
#
#     Below are general helper functions for any FEVM package to use
#
# ################################################################################################ #

function FE-ConvertTo-HashTable([object] $jsonTree) {
  $result = @{}
  foreach ($node in $jsonTree) {
    foreach ($property in $node.Keys) {
      if ($node[$property] -is [System.Collections.Generic.Dictionary[String, Object]] -or $node[$property] -is [Object[]]) {
        $result[$property] = FE-ConvertTo-HashTable $node[$property]
      } else {
        $result[$property] = $node[$property]
      }
    }
  }
  $result
}


function FE-ConvertFrom-Json([object] $item) {
<#
.SYNOPSIS
  Convert a JSON string into a hash table

.DESCRIPTION
  Convert a JSON string into a hash table, without any validation

.OUTPUTS
  [hashtable] or $null
#>
  Add-Type -Assembly system.web.extensions
  $ps_js = New-Object system.web.script.serialization.javascriptSerializer

  try {
    $result = $ps_js.DeserializeObject($item)
  } catch {
    $result = $null
  }
  
  # Cast dictionary to hashtable
  [hashtable] $result
}


function FE-ConvertTo-Json([object] $data) {
<#
.SYNOPSIS
  Convert a hashtable to a JSON string

.DESCRIPTION
  Convert a hashtable to a JSON string, without any validation

.OUTPUTS
  [string] or $null
#>
  Add-Type -Assembly system.web.extensions
  $ps_js = New-Object system.web.script.serialization.javascriptSerializer

  #The comma operator is the array construction operator in PowerShell
  try {
    $result = $ps_js.Serialize($data)
  } catch {
    $result = $null
  }
  
  $result
}


function FE-Import-JsonFile {
<#
.DESCRIPTION
  Load a hashtable from a JSON file
  
.OUTPUTS
  [hashtable] or $null
#>
  param([string] $path)
  try {
    $json = Get-Content $path
    $result = FE-ConvertFrom-Json $json
  } catch {
    $result = $null
  }
  
  $result
}


function FE-Install-OnePackage {
<#
.DESCRIPTION
  Install a package, specified by a hash table with the following properties:
  $pkg = @{
    name = "foo.python"
    args = "--source python"
    x64Only = $true
  }

.OUTPUTS
  $true OR $false
#>
  param([hashtable] $pkg)
  $name = $pkg.name
  $pkgargs = $pkg.args
  try {
    $is64Only = $pkg.x64Only
  } catch {
    $is64Only = $false
  }

  if ($is64Only) {
    if (Get-OSArchitectureWidth -Compare 64) {
      # pass
    } else {
      Write-Warning "[!] Not installing $name on x86 systems"
      return $true
    }
  }

  if ($pkgargs -eq $null) {
    $args = $globalCinstArgs
  } else {
    $args = $pkgargs,$globalCinstArgs -Join " "
  }

  if ($args -like "*-source*" -Or $args -like "*--package-parameters*" -Or $args -like "*--parameters*") {
    Write-Warning "[!] Installing using host choco.exe! Errors are ignored. Please check to confirm $name is installed properly"
    Write-Warning "[!] Executing: iex choco upgrade $name $args"
    $rc = iex "choco upgrade $name $args"
    Write-Host $rc
  } else {
    choco upgrade $name $args
  }

  if ($([System.Environment]::ExitCode) -ne 0 -And $([System.Environment]::ExitCode) -ne 3010) {
    Write-Host "ExitCode: $([System.Environment]::ExitCode)"
    return $false
  }
  return $true
}


function FE-Install-Packages {
<#
.DESCRIPTION
  Install a list of packages, following this JSON format:
  [
    {"name": "foo"},
    {"name": "bar", "x64Only": true},
    {"name": "foo.python", "args": "--source python"},
    {"name": "bar.fancy", "args": "--package-parameters \'/InstallDir:C\\bar.fancy\'"}
  ]
.OUTPUTS
  None, however it may write to stderr
#>
  param([hashtable] $packages)
  foreach ($pkg in $packages) {
    $rc = InstallOnePackage $pkg
    $name = $pkg.name
    if ($rc) {
      # self throttle
      if (-Not ($name.Contains(".flare") -Or -Not ($name.Contains(".fireeye")))) {
        Start-Sleep -Seconds 4
      }
    } else {
      Write-Error "Failed to install $name"
    }
  }
}


function FE-Remove-PreviousZipPackage {
<#
.DESCRIPTION
  Remove files from previous zips for upgrade. They should be listed in a *.txt file.
  If no expression is provided, it will look for files matching: *.zip.txt and *.7z.txt
.PARAMETER packagePath
  Path to the chocolatey package (usually %PROGRAMDATA%\Chocolatey\lib\<package_name>)
.PARAMETER expression
  [OPTIONAL] A wildcard expression for a file type containing a list of files to delete.
#>
  param(
    [string] $packagePath,
    [string] $expression=$null
  )

  if ($expression) {
    $previousZipFiles = Get-ChildItem -Path (Join-Path $packagePath $expression)
  } else {
    $previousZipFiles = Get-ChildItem -Path (Join-Path $packagePath "*.zip.txt"), (Join-Path $packagePath "*.7z.txt")
  }

  foreach ($zipFileName in $previousZipFiles) {
    if ((Test-Path -Path $zipFileName)) {
      $zipContents = Get-Content $zipFileName -Force
      foreach ($fileInZip in $zipContents) {
        if ($fileInZip -ne $null -and $fileInZip.Trim() -ne '' -and (Test-Path "$fileInZip")) {
          Remove-Item -Path "$fileInZip" -ErrorAction SilentlyContinue -Recurse -Force
        }
      }
    }
  }
}


# Set Pinned Applications from https://gist.github.com/jhorsman/0e4655da25c3e1700cb2
function FE-Set-PinnedApplication { 
  [CmdletBinding()] 
  param( 
    [Parameter(Mandatory=$true)][string]$Action,  
    [Parameter(Mandatory=$true)][string]$FilePath 
  ) 
  if(-not (test-path $FilePath)) {  
    throw "FilePath does not exist."   
  } 

  function InvokeVerb { 
    param([string]$FilePath,$verb) 
    $verb = $verb.Replace("&","") 
    $path= split-path $FilePath 
    $shell=new-object -com "Shell.Application"  
    $folder=$shell.Namespace($path)    
    $item = $folder.Parsename((split-path $FilePath -leaf)) 
    $itemVerb = $item.Verbs() | ? {$_.Name.Replace("&","") -eq $verb} 
    if($itemVerb -eq $null){ 
      throw "Verb $verb not found."             
    } else { 
      $itemVerb.DoIt() 
    }
  }

  function GetVerb { 
    param([int]$verbId) 
    try { 
      $t = [type]"CosmosKey.Util.MuiHelper" 
    } catch { 
      $def = [Text.StringBuilder]"" 
      [void]$def.AppendLine('[DllImport("user32.dll")]') 
      [void]$def.AppendLine('public static extern int LoadString(IntPtr h,uint id, System.Text.StringBuilder sb,int maxBuffer);') 
      [void]$def.AppendLine('[DllImport("kernel32.dll")]') 
      [void]$def.AppendLine('public static extern IntPtr LoadLibrary(string s);') 
      add-type -MemberDefinition $def.ToString() -name MuiHelper -namespace CosmosKey.Util             
    } 
    if($global:CosmosKey_Utils_MuiHelper_Shell32 -eq $null){         
      $global:CosmosKey_Utils_MuiHelper_Shell32 = [CosmosKey.Util.MuiHelper]::LoadLibrary("shell32.dll") 
    } 
    $maxVerbLength=255 
    $verbBuilder = new-object Text.StringBuilder "",$maxVerbLength 
    [void][CosmosKey.Util.MuiHelper]::LoadString($CosmosKey_Utils_MuiHelper_Shell32,$verbId,$verbBuilder,$maxVerbLength) 
    return $verbBuilder.ToString() 
  } 

  $verbs = @{  
    "PintoStartMenu"=5381 
    "UnpinfromStartMenu"=5382 
    "PintoTaskbar"=5386 
    "UnpinfromTaskbar"=5387 
  } 
    
  if ($verbs.$Action -eq $null) {
    Throw "Action $action not supported`nSupported actions are:`n`tPintoStartMenu`n`tUnpinfromStartMenu`n`tPintoTaskbar`n`tUnpinfromTaskbar"
  }
  InvokeVerb -FilePath $FilePath -Verb $(GetVerb -VerbId $verbs.$action)
}


function FE-Write-Log {
  [CmdletBinding()]
  Param(
  [Parameter(Mandatory=$True)]
  [ValidateSet("INFO","WARN","ERROR","FATAL","DEBUG")]
  [String]
  $level,

  [Parameter(Mandatory=$True)]
  [string]
  $message
  )

  if(($level -eq "ERROR") -Or ($level -eq "FATAL")){
    $format = "-ForegroundColor Red -BackgroundColor White"
  } elseif ($level -eq "WARN") {
    $format = "-ForegroundColor Yellow"
  } else {
    $format = ""
  }

  $envVarName = "VM_COMMON_DIR"
  $commonDirPath = [Environment]::GetEnvironmentVariable($envVarName, 2)
  $logFile = Join-Path $commonDirPath "log.txt"

  # If it doesn't exist, create it
  if (-Not (Test-Path $logFile)) {
    New-Item -Path $logFile -ItemType file -Force | Out-Null
  }

  $stamp = (Get-Date).toString("yyyy/MM/dd HH:mm:ss")
  $scriptName = Split-Path -Path $MyInvocation.ScriptName -Leaf
  if (Test-Path env:\"chocolateyPackageFolder") {
    $choco_dir = Split-Path -Path ${Env:chocolateyPackageFolder} -Leaf
    $line = "$stamp [$choco_dir] $scriptName [+] $level : $message"
  } else {
    $line = "$stamp $scriptName [+] $level : $message"
  }
  Add-Content $logfile -Value $line
  Invoke-Expression "Write-Host $line $format"
}


function FE-Assert-Path {
  [CmdletBinding()]
  Param(
    [Parameter(Mandatory=$True)]
    [String]
    $path
  )

  if (-Not (Test-Path $path)) {
    $err_msg = "Invalid path: $path"
    FE-Write-Log "ERROR" $err_msg
    throw $err_msg
  }
}

function FE-Get-DiskSize {
  $diskdrive = "${env:SystemDrive}"
  $driveName = $diskdrive.substring(0, $diskdrive.length-1)
  $disk = Get-PSDrive "$driveName"
  $disksize = (($disk.used + $disk.free)/1GB)
  return $disksize
}

function Temporary-FE-Get-FreeSpace {
  $diskdrive = "${env:SystemDrive}"
  $driveName = $diskdrive.substring(0, $diskdrive.length-1)
  $disk = Get-PSDrive "$driveName"
  $freeSpace = $disk.free/1GB
  return $freeSpace
}

function FE-Get-FreeSpace {
	'pwsh -Command Temporary-FE-Get-FreeSpace'
}

function FE-Check-Reboot {
  [CmdletBinding()]
  Param(
    [Parameter(Mandatory=$True)]
    [String]
    $package
  )
  try {
    if (Test-PendingReboot){
      FE-Write-Log "ERROR" "[Err] Host must be rebooted before continuing install of $package.`n"
      Invoke-Reboot
      exit 1
    }
  } catch {
    continue
  }
}


function FE-New-Install-Log {
  [CmdletBinding()]
  Param(
    [Parameter(Mandatory=$True)]
    [String] $dir
  )
  FE-Assert-Path $dir
  $outputFile = Join-Path $dir "install_log.txt"
  if (-Not (Test-Path $outputFile)) {
    New-Item -Path $outputFile -Force | Out-Null
  }
  $(Get-Date -f o) | Out-File -FilePath $outputFile -Append
  return $outputFile
}