param(
[string] $ActIP,
[string] $ActUser,
[string] $ActPass,
[string] $AppType,
[string] $AppName
)

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

   $appid = $(udsinfo lsapplication -filtervalue "appname=$AppName&appclass=$AppType").id

   if (! $appid ){
      write-warning "`nApplication Not Found`n"
      break
   }
   $workflow = $(reportworkflows -a $appid)

   if (! $workflow){
     write-warning "`nNo workflows associated with this application`n"
     break
     }

   $first = $true
   foreach($item in $workflow) {
     if ($first -eq $true) {
       $first = $false
       $message = '{0}' -f $item.WorkflowName
     } else {
       $message = $message + "|" + '{0}' -f $item.WorkflowName
     }
   }

   Disconnect-Act | Out-Null
 } 

rm "$TmpPasswdFile" -ErrorAction SilentlyContinue 

return $message
