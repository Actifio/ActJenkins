# JenkinsVdpHelper 

There are situation where a user wants to build a Jenkins job using dynamic values from the VDP appliance. We can leverage on Groovy script and JenkinsVdpHelper PowerShell script to create the dynamic list.

## What does this do?

This powershell script retrieves information from the VDP appliance based on certain operations. This script will be invoked from Groovy script section to populate the list of possible values for the Jenkins parameter.

To secure the password, we will leverage on the CreateVdpPasswordFile job to create a secure encrypted password file. This way we will not have to pass the password to the script and job. For more information have a look at https://github.com/Actifio/ActJenkins/tree/master/CreateVdpPasswordFile .

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

You will need to start a command prompt and run it as administrator. Launch powershell and run the AutoInstallActCLI.ps1 with the appropriate parameters.

## Parameters

The following are parameters supported:
* _-download_  This wll download the ActPowerCLI-x.y.z.w.zip from the Actifio github repository.  


## Usage:

## Sample output:
The following are sample of the different options supported:

### _-download -TmpDir c:\temp_
Download the zipped file to c:\temp directory .
```

```
