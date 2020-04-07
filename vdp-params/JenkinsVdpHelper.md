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

You will need to place the `JenkinsVdpHelper.ps1` script in the `c:\scripts` directory. Since we are looking for Oracle and SQL Server application type, we have included -parm1 SQLServer and -parm2 Oracle in argument section of the script.

## How can I test from command line?

You will need to launch powershell from command prompt and run the `.\JenkinsVdpHelper.ps1` script. For verbose, don't include the `-verbose` option.

PS > .\JenkinsVdpHelper.ps1 -VdpIp x.x -VdpUser cliuser -Action [ list | find | fetch ] -Object [ app | db | wf | apptype | mnt ] -silent -parm1 srch1 -parm2 srch2 -parm3 srch3 -parm4 srch4

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

## Sample output:
The following are sample of the different options supported:

#### _-VdpIp 10.10.10.1 -VdpUser cliuser -Action list -Object apptype_
List all the application type in VDP appliance:
```

```
