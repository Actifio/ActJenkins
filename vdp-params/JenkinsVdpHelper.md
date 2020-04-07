# JenkinsVdpHelper 

There are situation where a user wants to build a Jenkins job using dynamic values from the VDP appliance. We can leverage on Groovy script and JenkinsVdpHelper PowerShell script to create the dynamic list.

## What does this do?

This powershell script retrieves information from the VDP appliance based on certain operations. This script will be invoked from Groovy script section to populate the list of possible values for the Jenkins parameter.

To secure the password, we will leverage on the CreateVdpPasswordFile job to create a secure encrypted password file. This way we will not have to pass the password to the script and job.

## How does this work with Groovy?

The following uses the Jenkins parameterised build using Active Choices Reactive parameter:

The following code can be used in the Groovy section of the Jenkins parameter:
```
//
def powerShellCmd = 'c:\\scripts\\JenkinsVdpHelper.ps1 -VdpIP ' + VdpIP + ' -VdpUser ' + VdpUser 
def powerShellArgs = ' -Action find -Object apptype ' + ' -parm1 SQLServer -parm2 Oracle -silent'
//
def shellCommand = "powershell.exe -ExecutionPolicy Bypass -NoLogo -NonInteractive -NoProfile -Command \"${powerShellCmd}${powerShellArgs}\""

// No changes required for the following code:
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
