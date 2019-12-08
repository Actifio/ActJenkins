param(
[string] $ActIP,
[string] $ActUser,
[string] $ActPass,
[string] $AppType)

$env:IGNOREACTCERTS = $true
 
$LocalTempDir = "c:\temp\"
If(!(test-path $LocalTempDir)) {
    New-Item -ItemType Directory -Force -Path $LocalTempDir | out-null
    }
    
$TmpPasswdFile = "$LocalTempDir\$env:USERNAME-passwd.key"

"$ActPass" | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString | Out-File $TmpPasswdFile

if (! $env:ACTSESSIONID ){
   Connect-Act $ActIP -actuser $ActUser -passwordfile $TmpPasswdFile -ignorecerts | Out-Null
}

$message = ""

if (! $env:ACTSESSIONID ){
   write-warning "Login to CDS $ActIP failed"
   break
   }
 else {

   $dbappname = $(reportapps | where-object {$_.AppType -eq $AppType} | select-object AppName)
   if (! $dbappname){
     write-warning "`nNo list of database names`n"
     break
     }

   $first = $true
   foreach($item in $dbappname) {
     if ($first -eq $true) {
       $first = $false
       $message = '{0}' -f $item.AppName
     } else {
       $message = $message + "|" + '{0}' -f $item.AppName
     }
   }
   Disconnect-Act | Out-Null
 } 

rm "$TmpPasswdFile" -ErrorAction SilentlyContinue 

return $message
