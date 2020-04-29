# JenkinsVdpHelper 

There are situation where a user wants to build a Jenkins job using dynamic values from the VDP appliance. We can leverage on Groovy script and JenkinsVdpHelper PowerShell script to create the dynamic list.

## What does this do?

This powershell script retrieves information from the VDP appliance based on certain operations. This script will be invoked from Groovy script section to populate the list of possible values for the Jenkins parameter.

To secure the password, we will leverage on the [**CreateVdpPasswordFile**](https://github.com/Actifio/ActJenkins/tree/master/CreateVdpPasswordFile) job to create a secure encrypted password file. This way we will not have to pass the password to the script and job. 

## How does this work with Groovy?

The following uses the Jenkins parameterised build using Active Choices Reactive parameter:

![image](https://user-images.githubusercontent.com/17056169/78659386-d21f6f80-790e-11ea-8af9-9dca80d8b27b.png)

The name of the parameter is AppType and the dynamic values are dependent on the VdpUser and VdpIp parameters. We will need to define the two parameters before defining the AppType. The two parameters are used for us to communicate with the Vdp appliance.

When we checked the Groovy Script option, We will need to cut and paste the code from the following section into the Groovy section of the Jenkins parameter:

![image](https://user-images.githubusercontent.com/17056169/78660004-af418b00-790f-11ea-983d-278bfb09803c.png)

```
//
def powerShellCmd = 'c:\\scripts\\JenkinsVdpHelper.ps1 -VdpIP ' + VdpIP + ' -VdpUser ' + VdpUser 
def powerShellArgs = ' -Action find -Object apptype ' + ' -parm1 SQLServer -parm2 Oracle -silent'
//
def shellCommand = "powershell.exe -ExecutionPolicy Bypass -NoLogo -NonInteractive -NoProfile -Command \"${powerShellCmd}${powerShellArgs}\""

// No changes required for the following section:
//
def process = shellCommand.execute()
process.waitFor()

def outputStream = new StringBuffer();
def clist = []

process.waitForProcessOutput(outputStream, System.err)
if(process.exitValue()){
  println process.err.text
} else {
  println outputStream
  clist = outputStream.tokenize("|")
}
return clist
```

You will need to place the `JenkinsVdpHelper.ps1` script in the `c:\scripts` directory. In the above example, since we are looking for Oracle and SQL Server application type, we have included -parm1 SQLServer and -parm2 Oracle in argument section of the script. For more examples on refer to the `Sample Output` section.

## How can I test from command line?

You will need to launch powershell from command prompt and run the `.\JenkinsVdpHelper.ps1` script. For verbose, don't include the `-verbose` option. This is useful to test out the script before integrating with Groovy in Jenkins. You can also specify a passwordfile when running the script. Following are some examples:

Connect to VDP appliance 10.10.10.55 and list all application types:
```
PS C:\scripts> .\JenkinsVdpHelper.ps1 -vdpip 10.10.10.55 -vdpuser cliuser -vdppassfile ".\cliuser2.key"  -action list -object apptype
I have successfully logged into 10.10.10.55 as cliuser using the .\cliuser2.key encrypted password file
I will be processing ProcessAppType - list .

CIFS|DB2Instance|Exchange|FileSystem|LVM Volume|Microsoft Hyper-V VSS Writer|MYSQLInstance|nas|NFS|Oracle|SAPHANA|SqlInstance|SQLServer|SYBASEInstance|SystemState|VMBackup|
I have successfully logged out from 10.10.10.55
```

When integrating with Jenkins and Groovy, use the -silent parameters:
```
PS C:\scripts> .\JenkinsVdpHelper.ps1 -vdpip 10.10.10.55 -vdpuser cliuser -vdppassfile ".\cliuser2.key"  -action list -object apptype -silent
CIFS|DB2Instance|Exchange|FileSystem|LVM Volume|Microsoft Hyper-V VSS Writer|MYSQLInstance|nas|NFS|Oracle|SAPHANA|SqlInstance|SQLServer|SYBASEInstance|SystemState|VMBackup|
```

Connect to VDP appliance 10.10.10.1 with limited number of applications and list all application types:
```
PS C:\scripts> .\JenkinsVdpHelper.ps1 -vdpip 10.10.10.1 -vdpuser cliuser -vdppassfile ".\cliuser2.key"  -action list -object apptype
I have successfully logged into 10.10.10.1 as cliuser using the .\cliuser2.key encrypted password file
I will be processing ProcessAppType - list .

Oracle|SQLServer|
I have successfully logged out from 10.10.10.1
PS C:\scripts>
```

Filter out the Oracle application type:
```
PS C:\scripts> .\JenkinsVdpHelper.ps1 -vdpip 10.10.10.1 -vdpuser cliuser -vdppassfile ".\cliuser2.key"  -action find -object apptype -parm1 oracle 
I have successfully logged into 10.10.10.1 as cliuser using the .\cliuser2.key encrypted password file
I will be processing ProcessAppType - find . 

Oracle|
I have successfully logged out from 10.10.10.1
PS C:\scripts>
```

Use the `-silent` option to integrate with Jenkins Active Choices Reactive parameter:
```
PS C:\scripts> .\JenkinsVdpHelper.ps1 -vdpip 10.10.10.1 -vdpuser cliuser -vdppassfile ".\cliuser2.key"  -action list -object apptype -silent
Oracle|SQLServer|
PS C:\scripts>
```

## Parameters

The following are parameters supported:
* _-Action_   Action supported by this script - list all the object, find a single object, and fetch based on multiple search parameters.  
* _-Object_   List of objects in VDP appliance - app, db, wf apptype and mnt .
* _-silent_   Suppress any debugging information when running the script .
* _-VdpIP_    VDP IP appliance .
* _-VdpUser_  VDP CLI user .
* _-parm1_    Seach parameter based on the srch1 value. 
* _-parm2_    Seach parameter based on the srch2 value. 
* _-parm3_    Seach parameter based on the srch3 value. 
* _-parm4_    Seach parameter based on the srch4 value. 

## Usage:

```
PS > .\JenkinsVdpHelper.ps1 -VdpIp x.x -VdpUser cliuser -Action [ list | find | fetch ] -Object [ app | db | wf | apptype | mnt ] -silent -parm1 srch1 -parm2 srch2 -parm3 srch3 -parm4 srch4
```

## Sample output:
The following are sample of the different options supported:

AppType: Find all the SQL Server and Oracle application types in VDP appliance  (reference VdpIP and VdpUser):
```
//
def powerShellCmd = 'c:\\scripts\\JenkinsVdpHelper.ps1 -VdpIP ' + VdpIP + ' -VdpUser ' + VdpUser 
def powerShellArgs = ' -Action find -Object apptype ' + ' -parm1 SQLServer -parm2 Oracle -silent'
//
```

AppType: List all application types in VDP appliance (reference VdpIP and VdpUser):
```
//
def powerShellCmd = 'c:\\scripts\\JenkinsVdpHelper.ps1 -VdpIP ' + VdpIP + ' -VdpUser ' + VdpUser 
def powerShellArgs = ' -Action list -Object apptype -silent'
//
```

HostAppType: List all application types for a selected host in VDP appliance (reference VdpIP, VdpUser, srcHostname):
```
def powerShellCommand = 'c:\\scripts\\JenkinsVdpHelper.ps1 -VdpIP ' + VdpIP + ' -VdpUser ' + VdpUser + ' -Action fetch -Object apptype -parm1 ' + srcHostname + ' -silent'
def shellCommand = "powershell.exe -ExecutionPolicy Bypass -NoLogo -NonInteractive -NoProfile -Command \"${powerShellCommand}\""
```

srcHostname: List the hosts with a selected application type (reference VdpIP, VdpUser, srcAppType):
```
//
def powerShellCmd = 'c:\\scripts\\JenkinsVdpHelper.ps1 -VdpIP ' + VdpIP + ' -VdpUser ' + VdpUser 
def powerShellArgs = ' -Action find -Object host -parm1 ' + srcAppType + ' -silent'
//
```

allHostname: List all the hosts in the system (reference VdpIP, VdpUser):
```
def powerShellCommand = 'c:\\scripts\\JenkinsVdpHelper.ps1 -VdpIP ' + VdpIP + ' -VdpUser ' + VdpUser + ' -Action list -Object host -silent'
def shellCommand = "powershell.exe -ExecutionPolicy Bypass -NoLogo -NonInteractive -NoProfile -Command \"${powerShellCommand}\""

```

allAppName: List all applications based on the application type (reference VdpIP, VdpUser, srcAppType):
```
def powerShellCommand = 'c:\\scripts\\JenkinsVdpHelper.ps1 -VdpIP ' + VdpIP + ' -VdpUser ' + VdpUser + ' -Action find -Object app -parm1 ' + SrcAppType + ' -silent'
def shellCommand = "powershell.exe -ExecutionPolicy Bypass -NoLogo -NonInteractive -NoProfile -Command \"${powerShellCommand}\""
```

srcAppName: List all applications protected by Vdp based on the host of the selected application type (reference VdpIP, VdpUser, srcAppType, srcHostname):
```
def powerShellCommand = 'c:\\scripts\\JenkinsVdpHelper.ps1 -VdpIP ' + VdpIP + ' -VdpUser ' + VdpUser + ' -Action fetch -Object app -parm1 ' + srcAppType + ' -parm2 ' + srcHostname + ' -silent'
def shellCommand = "powershell.exe -ExecutionPolicy Bypass -NoLogo -NonInteractive -NoProfile -Command \"${powerShellCommand}\""
```

thisWorkflow: List all workflows based on the application name and application type (reference VdpIP, VdpUser, srcAppType, srcAppName):
```
def powerShellCommand = 'c:\\scripts\\JenkinsVdpHelper.ps1 -VdpIP ' + VdpIP + ' -VdpUser ' + VdpUser + ' -Action find -Object wf -parm1 ' + srcAppName + ' -parm2 ' + srcAppType + ' -silent'
def shellCommand = "powershell.exe -ExecutionPolicy Bypass -NoLogo -NonInteractive -NoProfile -Command \"${powerShellCommand}\""
```

thisImage: List all images associated with the application name and application type (reference VdpIP, VdpUser, srcAppType, srcAppName):
```
def powerShellCommand = 'c:\\scripts\\JenkinsVdpHelper.ps1 -VdpIP ' + VdpIP + ' -VdpUser ' + VdpUser + ' -Action find -Object image -parm1 ' + srcAppName + ' -parm2 ' + srcAppType + ' -silent'
def shellCommand = "powershell.exe -ExecutionPolicy Bypass -NoLogo -NonInteractive -NoProfile -Command \"${powerShellCommand}\""
```
---

TgtHostname: List all hostnames with mounted images from the source hostname and application name (reference VdpIP, VdpUser, srcHostname, srcAppName):
```
def powerShellCommand = 'c:\\scripts\\JenkinsVdpHelper.ps1 -VdpIP ' + VdpIP + ' -VdpUser ' + VdpUser + ' -Action find -Object mnt -parm1 ' + SrcHostname + ' -parm2 ' + SrcAppName + ' -silent'
def shellCommand = "powershell.exe -ExecutionPolicy Bypass -NoLogo -NonInteractive -NoProfile -Command \"${powerShellCommand}\""
```

TgtAppname: List all application names on the target hostname with with mounted images from the source hostname and application name (reference VdpIP, VdpUser, srcHostname, srcAppName, TgtHostname):
```
def powerShellCommand = 'c:\\scripts\\JenkinsVdpHelper.ps1 -VdpIP ' + VdpIP + ' -VdpUser ' + VdpUser + ' -Action fetch -Object mnt -parm1 ' + SrcHostname + ' -parm2 ' + SrcAppName + ' -parm3 ' + TgtHostname + ' -silent'
def shellCommand = "powershell.exe -ExecutionPolicy Bypass -NoLogo -NonInteractive -NoProfile -Command \"${powerShellCommand}\""
```

Suggested Description of the parameters:
```
VdpIP: VDP IP address
VdpUser: VDP service account for this Jenkins job
srcAppType: Database Application Type: Oracle and SQL
srcHostname: List of hosts with the selected application type
srcAppName: List of applications with the selected application type on the hostname
Workflow: List of workflows with the selected application name and application type
ImageName: List of images with the selected application name and application type
```
