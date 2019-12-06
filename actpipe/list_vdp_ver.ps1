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
"$env:ActPass" | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString | Out-File $TmpPasswdFile

if (! $env:ACTSESSIONID ){
   Connect-Act $env:ActIP -actuser $env:ActUser -passwordfile $TmpPasswdFile -ignorecerts
}


if (! $env:ACTSESSIONID ){
   write-warning "Login to CDS $Env:ActifioIP failed"
   break
 }
 else {
    udsinfo lsversion
    Disconnect-Act | Out-Null
 } 

rm "$TmpPasswdFile" -ErrorAction SilentlyContinue 
