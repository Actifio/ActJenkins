# 
## File: JenkinsVdpHelper.ps1
## Purpose: Script to integrate with the Jenkins Windows server.
#
# Version 1.0 Initial Release
#

<#   
.SYNOPSIS   
    This powershell script retrieves information from the VDP appliance based on certain operations. 
.DESCRIPTION 
    This script will be invoked from Groovy script section to populate the list of possible values for the Jenkins parameter.
.PARAMETER VdpIp
    IP address of the VDP appliance
.PARAMETER VdpUser
    VDP CLI user
.PARAMETER Action
    List of actions: [ list all object | find an object based on the parameter in parm1 | fetch ]
.PARAMETER Object
    Objects in the Vdp appliance [ app | db | wf | apptype | mnt ]
.PARAMETER Parm1
    Search value based on srch1 parameter
.PARAMETER Parm2
    Search value based on srch2 parameter
.PARAMETER Silent
    Suppress any debugging information when running the script. Requires when integrating with Jenkins.
.EXAMPLE
    PS > .\JenkinsVdpHelper.ps1 -VdpIp x.x -VdpUser cliuser -Action [ list | find | fetch ] -Object [ app | db | wf | apptype | mnt ] -silent -parm1 srch1 -parm2 srch2 -parm3 srch3 -parm4 srch4

    To download and install the ActPowerCLI
.NOTES   
    Name: JenkinsVdpHelper.ps1
    Author: Michael Chew
    DateCreated: 30-March-2020
    LastUpdated: 8-April-2020
.LINK
    https://github.com/Actifio/powershell/blob/master/JenkinsVdpHelper   
#>

[CmdletBinding()]
Param
( 
  [Parameter(Mandatory=$True)][string]$VdpIP = "",              # Vdp IP
  [Parameter(Mandatory=$True)][string]$VdpUser = "",            # Vdp User
  [string]$VdpPassFile = "",        # Vdp Password File
  [Parameter(Mandatory=$True)][string]$Object = "",             # app, db, wf, apptype, mnt
  [Parameter(Mandatory=$True)][string]$Action = "",             # list, find
  [string]$parm1 = "",              # parameter 1
  [string]$parm2 = "",              # parameter 2
  [string]$parm3 = "",              # parameter 3
  [string]$parm4 = "",              # parameter 4    
  [switch]$Silent = $false           
)  ### Param

$Version = "10.0.0.227"
$ScriptVersion = "1.0"

##################################
# Function: ProcessApp
#
# xxxx
# 
##################################
function ProcessApp (
  [string]$Action,
  [string]$parm1 = "",     ### AppType
  [string]$parm2 = ""     ### Hostname
)
{
  if (! $Silent) {
    Write-Host "I will be processing ProcessApp - $Action ."
  }

  if ($Action -eq "list") {
    $dbappList = $( reportapps | select-object AppName )
  } elseif ( $Action -eq "fetch" ) {    ### "find"
    $dbappList = $( reportapps | where-object {$_.AppType -eq $parm1 -And $_.HostName -eq $parm2 } | select-object AppName ) 
  } else {   ### "find"
    $dbappList = $( reportapps | where-object {$_.AppType -eq $parm1} | select-object AppName )
  }

  if (! $Silent) {
    write-Host "$dbappList"
  }
  $dbappList | ForEach-Object { if ($_.AppName -eq $dbappList[-1]) { $strlist += $_.AppName } else { $strlist += $_.AppName + "|" } }
  
  Write-Output "$strlist"
}   ### end function
##################################
# Function: ProcessAppType
#
# xxxx
# 
##################################
function ProcessAppType (
  [string]$Action, 
  [string]$parm1 = "",       ### SQLServer   ### fetch $Hostname
  [string]$parm2 = "",       ### Oracle
  [string]$parm3 = "",       ### HANA
  [string]$parm4 = ""        ### Sybase
)
{
  if (! $Silent) {
    Write-Host "I will be processing ProcessAppType - $Action . "
  }

  if (! $Silent) {
    write-Host "$dbtypeList"
  }

  if ( $Action -eq "list" ) {
    $dbtypeList = $(reportapps | select-object apptype | get-unique -asstring)
  } elseif ( $Action -eq "fetch" ) {        ### "fetch"
    $dbtypeList = $(reportapps | where-object {$_.Hostname -eq $parm1} | select-object AppType | get-unique -asstring)
  } else {   ### "find"
#  $dbtypeList = $(reportapps | where-object {$_.AppType -eq 'SQLServer' -or $_.AppType -eq 'Oracle'} | select-object apptype | get-unique -asstring)
    if ($parm1 -ne $null -And $parm1 -ne "") {
      $dbtypeList = $(reportapps | where-object {$_.AppType -eq $parm1} | select-object apptype | get-unique -asstring)
      if ($parm2 -ne $null -And $parm2 -ne "") {
        $dbtypeList = $(reportapps | where-object {$_.AppType -eq $parm1 -or $_.AppType -eq $parm2} | select-object apptype | get-unique -asstring)
        if ($parm3 -ne $null -And $parm3 -ne "") {
          $dbtypeList = $(reportapps | where-object {$_.AppType -eq $parm1 -or $_.AppType -eq $parm2 -or $_.AppType -eq $parm3} | select-object apptype | get-unique -asstring)
          if ($parm4 -ne $null -And $parm4 -ne "") {
            $dbtypeList = $(reportapps | where-object {$_.AppType -eq $parm1 -or $_.AppType -eq $parm2 -or $_.AppType -eq $parm3 -or $_.AppType -eq $parm4} | select-object apptype | get-unique -asstring)
          }
        }
      }
    }
  }

  $dbtypeList | ForEach-Object { if ($_.AppType -eq $dbtypeList[-1]) { $strlist += $_.AppType } else { $strlist += $_.AppType + "|" } }
  
  Write-Output "$strlist"
}   ### end function

##################################
# Function: ProcessHost
#
# xxxx
# 
##################################
function ProcessHost (
  [string]$Action,
  [string]$parm1 = ""  
)
{
  if (! $Silent) {
    Write-Host "I will be processing ProcessHost - $Action . "
  }

  if ($Action -eq "list") {   ### List all the hosts with connector installed
    $hostList = $(reportconnectors -e | where { "-" -ne $_.InstalledVersion } | select-object hostname | get-unique -asstring)
  } else {   ### "find" , search for entries with application type specified in parm1
    $hostList = $( reportapps | where-object {$_.AppType -eq $parm1} | select-object HostName | get-unique -asstring )
  }

  if (! $Silent) {
    write-Host "$hostList"
  }
  $hostList | ForEach-Object { if ($_.Hostname -eq $hostList[-1]) { $strlist += $_.Hostname } else { $strlist += $_.Hostname + "|" } }
  
  Write-Output "$strlist"
}   ### end function

##################################
# Function: ProcessDb
#
# xxxx
# 
##################################
function ProcessDb (
  [string]$Action 
)
{
  Write-Host "I will be processing ProcessDb - $Action . "

}   ### end function

##################################
# Function: ProcessWorkflow
#
# xxxx
# 
##################################
function ProcessWorkflow (
  [string]$Action,
  [string]$parm1 = "" , ### AppName
  [string]$parm2 = ""   ### AppType
)
{
  if (! $Silent) {
    Write-Host "I will be processing ProcessWorkflow - $Action . "
  }

  if ($Action -eq "list") {
    $wfList = $(reportworkflows | select-object WorkflowName )
  } else {   ### "find"
    $appid = $(udsinfo lsapplication | where-object {$_.AppType -eq $parm2 -And $_.AppName -eq $parm1} | select-object Id).Id
    $wfList = $(reportworkflows | where-object {$_.SourceAppID -eq $appid} | select-object WorkflowName )
  }

  if (! $Silent) {
    write-Host "$hostList"
  }
  $wfList | ForEach-Object { if ($_.WorkflowName -eq $wfList[-1]) { $strlist += $_.WorkflowName } else { $strlist += $_.WorkflowName + "|" } }
  
  Write-Output "$strlist"
}   ### end function

##################################
# Function: ProcessImage
#
# xxxx
# 
##################################
function ProcessImage (
  [string]$Action ,
  [string]$parm1 = "" , ### AppName
  [string]$parm2 = ""   ### AppType  
)
{
  if (! $Silent) {
    Write-Host "I will be processing ProcessImage - $Action . "
  }

  $appid = $(udsinfo lsapplication | where-object {$_.AppType -eq $parm2 -And $_.AppName -eq $parm1} | select-object Id).Id
  $imageList = $( reportimages -a $appid  | where-object {$_.JobClass -eq "snapshot" -Or $_.JobClass -eq "OnVault"} | select-object ImageName, ConsistencyDate )

  $imageList | ForEach-Object { if ($_.ImageName -eq $imageList[-1]) { $strlist += $_.ImageName + " ; " + $_.ConsistencyDate } else { $strlist += $_.ImageName + " ; " + $_.ConsistencyDate + "|" } }
  
  Write-Output "$strlist"
}   ### end function

##################################
# Function: ProcessMounts
#
# xxxx
# 
##################################
function ProcessMounts (
  [string]$Action,
  [string]$parm1 = "",              # source hostname
  [string]$parm2 = "",              # source appname
  [string]$parm3 = "",              # target hostname
  [string]$parm4 = ""               # parameter 4    
)
{
  if (! $Silent) {
    Write-Host "I will be processing ProcessMounts - $Action . "
  }

  if ( $Action -eq "list" ) {
    Write-Host "Not implemented yet !! "
    $strlist = $Null
  } elseif ( $Action -eq "fetch" ) {      ### "fetch"
    $mntList = $(reportmountedimages | where-object {$_.SourceApp -eq $parm2 -And $_.SourceHost -eq $parm1 -And $_.MountedHost -eq $parm3} | select-object MountedAppName) 
    $mntList | ForEach-Object { if ($_.MountedAppName -eq $mntList[-1]) { $strlist += $_.MountedAppName } else { $strlist += $_.MountedAppName + "|" } }     
  } else {   ### "find"
    $mntList = $(reportmountedimages | where-object {$_.SourceApp -eq $parm2 -And $_.SourceHost -eq $parm1} | select-object MountedHost)
    $mntList | ForEach-Object { if ($_.MountedHost -eq $mntList[-1]) { $strlist += $_.MountedHost } else { $strlist += $_.MountedHost + "|" } }
  }

  Write-Output "$strlist"
}   ### end function
##################################
# Function: Display-Usage
#
##################################
function Display-Usage ()
{
  write-host "Usage: .\JenkinsVdpHelper.ps1 -VdpIp x.y.z.w -VdpUser cliuser [ -VdpPassFile .\cliuser.key ] -Action [ list | find | fetch ] -Object [ app | db | wf | apptype | mnt ] -silent -parm1 srch1 -parm2 srch2 -parm3 srch3 -parm4 srch4 `n"

  write-host " get-help .\JenkinsVdpHelper.ps1 -examples"
  write-host " get-help .\JenkinsVdpHelper.ps1 -detailed"
  write-host " get-help .\JenkinsVdpHelper.ps1 -full"    
}     ### end of function

##############################
#
#  M A I N    B O D Y
#
##############################

$JenkinsVdpHelperversion = "1.1"
$ObjectList =@("app", "host", "db", "wf", "apptype", "mnt", "image")
$ActionList =@("list", "find", "fetch")

# if (! $Action) {
#  Display-Usage
#  exit
#}

if ( ! ($ActionList -contains $Action) ) {
  Write-Host "`n$Action is not a valid action after the -action argument !! "
  $strlist = $Null
  $ActionList | ForEach-Object { if ($_ -eq $ActionList[-1]) { $strlist += $_ + " " } else { $strlist += $_ + " , " } }
  Write-Host "Valid action supported: $strlist`n"
  Display-Usage
  exit
}

if ( ! ($ObjectList -contains $Object) ) {
  Write-Host "`n$Object is not a valid action after the -object argument !! "
  $strlist = $Null
  $ObjectList | ForEach-Object { if ($_ -eq $ObjectList[-1]) { $strlist += $_ + " " } else { $strlist += $_ + " , " } }
  Write-Host "Valid action supported: $strlist`n"
  Display-Usage
  exit
}

if ($VdpPassFile -eq $null -or $VdpPassFile -eq "") {
  # Determine script location for PowerShell
  $ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path
  if (! $Silent) {
    Write-Host "Current script directory is $ScriptDir"
  }
  $VdpPassFile = $ScriptDir + "\" + $VdpUser + ".key"
  }
## "12!pass345"| ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString | Out-File c:\scripts\cliuser2.key

Connect-Act $VdpIP -actuser $VdpUser -passwordfile $VdpPassFile -ignorecerts -quiet
if (! $env:ACTSESSIONID ){
   write-warning "Login to Vdp $VdpIP failed"
   break
 } else {
    if (! $Silent) {
      write-Host "I have successfully logged into $VdpIp as $VdpUser using the $VdpPassFile encrypted password file"
    }
 }

 switch ($Object)  {
  "app"     { ProcessApp $Action $parm1 $parm2 }
  "host"    { ProcessHost $Action $parm1 }
  "db"      { ProcessDb $Action }
  "wf"      { ProcessWorkflow $Action $parm1 $parm2 }
  "apptype" { ProcessAppType $Action $parm1 $parm2 $parm3 $parm4 }
  "mnt"     { ProcessMounts $Action $parm1 $parm2 $parm3 $parm4}
  "image"   { ProcessImage $Action $parm1 $parm2 }      
}

if ($env:ACTSESSIONID) {
  if (! $Silent) {
    write-Host "I have successfully logged out from $VdpIp"
  }
  Disconnect-Act | Out-Null
}

exit