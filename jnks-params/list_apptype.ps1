param(
[string] $ActIP,
[string] $ActUser,
[string] $ActPass)

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

   $dbtype = $(reportapps | sort-object apptype -unique | select apptype)
   # Only list application type of SQLServer and Oracle if there are any
   # $dbtype = $( reportapps | where-object {$_.AppType -eq 'SQLServer' -or $_.AppType -eq 'Oracle'} | sort-object apptype -unique | select apptype)

   if (! $dbtype){
     write-warning "`nNo database types`n"
     break
     }

   $first = $true
   foreach($item in $dbtype) {
     if ($first -eq $true) {
       $first = $false
       $message = '{0}' -f $item.AppType 
     } else {
       $message = $message + "|" + '{0}' -f $item.AppType
     }
   }

   Disconnect-Act | Out-Null
 } 

rm "$TmpPasswdFile" -ErrorAction SilentlyContinue 

return $message
