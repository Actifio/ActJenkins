##
## File: list_vdp_ver.ps1
##
## Prerequisites:
##   - Parameters defined in Jenkins build job:
##     : ActUser - Actifio user
##     : ActPass - password for the above Actifio user
##     : ActIP - IP address or FQDN of the Actifio appliance
##

param(
[string]$ActUser,
[string]$ActPass,
[string]$ActIP
)

$LocalTempDir = "c:\temp\"
If(!(test-path $LocalTempDir)) {
    New-Item -ItemType Directory -Force -Path $LocalTempDir | out-null
    }
    
$TmpPasswdFile = "$LocalTempDir\$env:USERNAME-passwd.key"
"$ActPass" | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString | Out-File $TmpPasswdFile

if (! $env:ACTSESSIONID ){
   Connect-Act $ActIP -actuser $ActUser -passwordfile $TmpPasswdFile -ignorecerts
}


if (! $env:ACTSESSIONID ){
   write-warning "Login to VDP $ActIP failed"
   break
 }
 else {
# @{name="installed"; expression={$_.installed}}, 
    udsinfo lsversion | select  @{name="component"; expression={"{0,-15}" -f $_.component}}, @{name="version"; expression={"{0,-25}" -f $_.version}} 
    Disconnect-Act | Out-Null
 } 

rm "$TmpPasswdFile" -ErrorAction SilentlyContinue
