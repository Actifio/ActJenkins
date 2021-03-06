##
## File: act-job-lsversion.ps1
##
## Prerequisites:
##   - Parameters defined in Jenkins build job:
##     : ActUser - Actifio user
##     : ActPass - password for the above Actifio user
##     : ActIP - IP address or FQDN of the Actifio appliance
##

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
   write-warning "Login to Actifio VDP $Env:ActifioIP failed"
   break
 }
 else {
    write-output "The version of the VDP software running on $Env:ActIP is as follow"
    udsinfo lsversion
    Disconnect-Act | Out-Null
 } 

rm "$TmpPasswdFile" -ErrorAction SilentlyContinue 
