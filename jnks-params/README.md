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

The following is what you can do to setup dynamic parameters. Values for the AppType parameter is dynamically populated from a PowerShell script on the Jenkins server using the Actifio CLI credentials. The output is as follow:

![image](https://user-images.githubusercontent.com/17056169/70388243-2bc86980-1a03-11ea-9310-86e31766c378.png)

ActIP : STRING parameter  
ActUser : STRING parameter  
ActPass : PASSWORD parameter  


Parameter Name: AppType   
Paramater Type: Active Choices Reactive parameter  
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
   # $dbtype = $( reportapps | where-object {$_.AppType -eq 'SQLServer' -or $_.AppType -eq 'Oracle'} | sort-object apptype -unique | select apptype)

   if (! $dbtype){
     write-warning "`nNo database types`n"
     break
     }

   $dbtype | out-file "c:\scripts\dbtype.txt" 
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
Paramater Type: Active Choices Reactive parameter  
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

   $dbtype | out-file "c:\scripts\dbtype.txt" 
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
---
