## Overview

There are situation where a user wants to build a Jenkins job using dynamic values from the VDP appliance. We can leverage on Groovy script and PowerShell script to create the dynamic list.

The following job uses the Jenkins parameterised build using Active Choices Reactive parameter:

![image](https://user-images.githubusercontent.com/17056169/78726690-f5c9d080-7975-11ea-8e6c-61a03eea14d7.png)

The first two parameters are required:  
  
![image](https://user-images.githubusercontent.com/17056169/78726707-037f5600-7976-11ea-8f2b-288a5d442e9e.png)
  
![image](https://user-images.githubusercontent.com/17056169/78726732-13973580-7976-11ea-9e8f-dc57684508c4.png)
  
And the parameters after that are dynamically generated based on the what objects are defined in the VDP appliance using the VDP CLI user.

Since the VDP appliance have both SQL and Oracle workloads, both are displayed in the dropdown list:  
![image](https://user-images.githubusercontent.com/17056169/78726761-227de800-7976-11ea-8fb1-e5d8a93e46a0.png). 
  
And, the list of databases on the source server managed by the VDP appliance is displayed below:  
![image](https://user-images.githubusercontent.com/17056169/78726838-5e18b200-7976-11ea-9dfc-5786d5371098.png). 
  
For instructions on how to set it up, please refer to [**JenkinsVdpHelper**](https://github.com/Actifio/ActJenkins/blob/master/vdp-params/JenkinsVdpHelper.md)
  
---

How to reference system variables and user-defined parameters in Jenkins running on Linux and Windows ?

bash: Built-in:
```
$hostname
$AppType
```

Windows PowerShell: Built-in:
```
$env:hostname
$env:AppType
``

Windows Batch: Built-in:
```
%hostname%. 
%AppType%. 
```
