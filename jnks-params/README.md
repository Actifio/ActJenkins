## Jenkins parameterised build

The following are the different parameterized build supported:

* **STRING** : String  
![image](https://user-images.githubusercontent.com/17056169/70323042-e62f6380-187f-11ea-82a4-3554dbffc6bb.png)

* **PASSWORD** : Password (Hidden)  
![image](https://user-images.githubusercontent.com/17056169/70323072-f6474300-187f-11ea-9726-e3770e1868a6.png)

* **DATE** : Date  
```
Date Format: yyyy-MM-dd  |  dd/MM/yyyy

LocalDate.now();
LocalDate.now().plusDays(1).plusMinutes(5);
LocalDate.now().plusDays(1).plusMinutes(5).plusYears(1);
LocalDate.now().minusDays(5);
Default Value: LocalDate.now().minusDays(1);  |  01/05/2017
```
![image](https://user-images.githubusercontent.com/17056169/70323111-0e1ec700-1880-11ea-9b47-828bb5559331.png)

* **BOOLEAN** : Boolean   

* **CHOICE** : Choice  
![image](https://user-images.githubusercontent.com/17056169/70323130-1b3bb600-1880-11ea-8112-268dbca63951.png)

* **CHOICE** : Active Choices  
![image](https://user-images.githubusercontent.com/17056169/70323144-28f13b80-1880-11ea-8c6b-ba34574de2e1.png)

Using Groovy Script:   
![image](https://user-images.githubusercontent.com/17056169/70323177-41f9ec80-1880-11ea-89c9-40e91b7ea9e9.png)

----

How to reference the vaule in Jenkins running on Linux?

bash:
Built-in:
```
$hostname
```
Reference:
```
echo "The current state in Australia is ${CurrState}"
```
----

How to reference the vaule in Jenkins running on Windows?

Windows PowerShell:
Built-in:
```
$env:hostname
```
Reference:
```
LoginServer -User $UserID -Password $UserPass
```
---

### Jenkins parameterised build using Active Choices Reactive parameter

The following is what you can do to setup dynamic parameters. Values for the AppType parameter is dynamically populated from a PowerShell script on the Jenkins server using the Actifio CLI credentials. You would need to upload the PS scripts to C:\SQL directory on the Jenkins server. The output is as follow:

![image](https://user-images.githubusercontent.com/17056169/70397821-96ac8b80-1a69-11ea-8cdc-d6379372ea6a.png)

ActUser : STRING parameter  
ActPass : PASSWORD parameter  
ActIP : STRING parameter  

Parameter Name: AppType   
Parameter Type: Active Choices Reactive parameter  
Referenced parameters: ActPass,ActIP,ActUser  
Groovy script:
```
def AppTypeList = []
def powerShellCommand = 'c:\\sql\\list_apptype.ps1 -ActIP ' + ActIP + ' -ActUser ' + ActUser + ' -ActPass ' + ActPass
def shellCommand = "powershell.exe -ExecutionPolicy Bypass -NoLogo -NonInteractive -NoProfile -Command \"${powerShellCommand}\""
def process = shellCommand.execute()
process.waitFor()
def outputStream = new StringBuffer();
process.waitForProcessOutput(outputStream, System.err)
if(process.exitValue()){
  println process.err.text
} else {
  println outputStream
  AppTypeList = outputStream.tokenize("|")
  }
return AppTypeList
```

Content of the Powershell Script: C:\SQL\list_apptype.ps1
```
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
```

Parameter Name: AppName  
Parameter Type: Active Choices Reactive parameter  
Referenced parameters: ActType,ActPass,ActIP,ActUser  
Groovy script:
```
def AppNameList = []
def powerShellCommand = 'c:\\sql\\list_apps.ps1 -ActIP ' + ActIP + ' -ActUser ' + ActUser + ' -ActPass ' + ActPass + ' -AppType ' + AppType
def shellCommand = "powershell.exe -ExecutionPolicy Bypass -NoLogo -NonInteractive -NoProfile -Command \"${powerShellCommand}\""
def process = shellCommand.execute()
process.waitFor()
def outputStream = new StringBuffer();
process.waitForProcessOutput(outputStream, System.err)
if (process.exitValue()){
  println process.err.text
} else {
  println outputStream
  AppNameList = outputStream.tokenize("|")
}
return AppNameList
```

Content of the Powershell Script: C:\SQL\list_apps.ps1
```
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
```

Parameter Name: WorkflowName   
Parameter Type: Active Choices Reactive parameter  
Referenced parameters: AppName,AppType,ActPass,ActIP,ActUser  
Groovy script:
```
def WflowNameList = []
def powerShellCommand = 'c:\\sql\\list_wflows.ps1 -ActIP ' + ActIP + ' -ActUser ' + ActUser + ' -ActPass ' + ActPass + ' -AppType ' + AppType + ' -AppName ' + AppName

def shellCommand = "powershell.exe -ExecutionPolicy Bypass -NoLogo -NonInteractive -NoProfile -Command \"${powerShellCommand}\""

def process = shellCommand.execute()
process.waitFor()
def outputStream = new StringBuffer();
process.waitForProcessOutput(outputStream, System.err)
if(process.exitValue()){
  println process.err.text
} else {
  println outputStream
  WflowNameList = outputStream.tokenize("|")
}
return WflowNameList
```

Content of the Powershell Script: C:\SQL\list_wflows.ps1
```
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
```

---
