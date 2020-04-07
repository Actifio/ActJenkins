## Create a secure encrypted password file using the VDP CLI user credentials

This job helps build a secure encrypted password file using the VDP CLI user credentials. The encrypted file can then be used to securely authenticating to VDP appliance when running Groovy helper scripts and Jenkins build job. This eliminate the need the pass the password to the scripts and build job.

### Step 1:
Login to the Jenkins server and create a freestyle project by clicking on the New Item link on the top left hand corner. Enter the name of the job - CreateVdpPasswordFile , and click on Freestyle project. Click OK to confirm.

### Step 2:
In this job, we want to allow the user to provide inputs when running the job. We will create three parameters: VdpUser, VdpPassword and VdpIP by checking on the This project is parameterized. VdpUser and VdpIP will be of String type, whereas VdpPassword will be Password type.

![image](https://user-images.githubusercontent.com/17056169/78641196-3123bb00-78f4-11ea-8dff-bff74887872e.png)

![image](https://user-images.githubusercontent.com/17056169/78641252-4ac50280-78f4-11ea-8b67-2b843a324d98.png)

![image](https://user-images.githubusercontent.com/17056169/78641289-5a444b80-78f4-11ea-9814-10bda9899973.png)

### Step 3:
Go to the Build section and define the tasks required to build the job. We will be connecting to the VDP appliance using the encrypted file to ensure the credentials are correct. You can copy and paste the following:
```
$pwfile = "c:\scripts\" + $Env:VdpUser + ".key"
$env:IGNOREACTCERTS = $true
 
$env:VdpPassword| ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString | Out-File $pwfile
 
$moduleins = get-module -listavailable -name ActPowerCLI
if ($moduleins -eq $null) {
    Import-Module ActPowerCLI
}

Connect-Act $Env:VdpIP -actuser $Env:VdpUser -passwordfile $pwfile -ignorecerts -quiet
if (! $env:ACTSESSIONID ){
   write-warning "Login to Vdp $Env:VdpIP failed"
   break
 }
 else {
   write-Host "I have successfully logged into $Env:VdpIp as $Env:VdpUser using the $pwfile encrypted password file"
   Disconnect-Act | Out-Null
 } 
```

### Step 4:
Build the job and once it's completed, click on the Console Output to view the output of the job. An example of the output is as follow:

