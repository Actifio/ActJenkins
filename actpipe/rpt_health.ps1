##
## File: rpt_health.ps1
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
   write-warning "Login to CDS $ActIP failed"
   break
 }
 else {
    reporthealth | format-list
    Disconnect-Act | Out-Null
 } 

rm "$TmpPasswdFile" -ErrorAction SilentlyContinue 
