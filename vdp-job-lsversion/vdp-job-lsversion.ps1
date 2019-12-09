##
## File: vdp-job-lsversion.ps1
##
## Prerequisites:
##   - Parameters defined in Jenkins build job:
##     : VdpUser - IBM VDP CLI user
##     : VdpPass - password for the above VDP CLI user
##     : VdpIP - IP address or FQDN of the IBM VDP appliance
##

$LocalTempDir = "c:\temp\"
If(!(test-path $LocalTempDir)) {
    New-Item -ItemType Directory -Force -Path $LocalTempDir | out-null
    }
    
$TmpPasswdFile = "$LocalTempDir\$env:USERNAME-passwd.key"
"$env:VdpPass" | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString | Out-File $TmpPasswdFile

if (! $env:ACTSESSIONID ){
   Connect-Act $env:VdpIP -actuser $env:VdpUser -passwordfile $TmpPasswdFile -ignorecerts
}


if (! $env:ACTSESSIONID ){
   write-warning "Login to VDP $Env:VdpifioIP failed"
   break
 }
 else {
    udsinfo lsversion
    Disconnect-Act | Out-Null
 } 

rm "$TmpPasswdFile" -ErrorAction SilentlyContinue 
