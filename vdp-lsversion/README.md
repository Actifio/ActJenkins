# List IBM VDP version

The following is a good start on how you can integrate Jenkins with IBM VDP appliance. We will be using the Jenkins freestyle job and perform the Build using PowerShell scripts.

You will need to have a Jenkins instance running on Windows and ActPowerCLI installed. If you need information on how to install the ActPowerCLI module, please checkout https://github.com/Actifio/powershell or https://github.com/Actifio/powershell/tree/master/setup-actpowercli .

We will be creating a Jenkins job that accepts IBM VDP CLI user and credentials, login to the appliance and lists out the IBM VDP version.

### Step 1:
Login to the Jenkins server and create a freestyle project by clicking on the New Item link on the top left hand corner. Enter the name of the job - act-lsversion , and click on Freestyle project. Click OK to confirm.

### Step 2:
In this job, we want to allow the user to provide inputs when running the job. We will create three parameters: VdpUser, VdpPass and VdpIP by checking on the This project is parameterized. VdpUser and VdpIP will be of String type, whereas VdpPass will be Password type.

![2019-12-05_19-09-25](https://user-images.githubusercontent.com/17056169/70216377-8196da80-1793-11ea-8832-7b42dd3198ad.png)

### Step 3:
Go to the Build section and define the tasks required to build the job. We will be making calls to Actifio VDP appliance using the commands in ActPowerCLI modules. You can copy and paste the source code from https://github.com/Actifio/ActJenkins/blob/master/act-lsversion/actlsversion.ps1 into the PowerShell Build window .

### Step 4:
To build the job, click on Build with Parameters to kick it off. If required, you can change any the build parameters before triggering the build. 
![2019-12-05_19-11-18](https://user-images.githubusercontent.com/17056169/70216390-89567f00-1793-11ea-9428-2edd7405afc1.png)

### Step 5:
Once it's completed, click on the Console Output to view the output of the job. An example of the output is as follow:
![2019-12-05_19-12-02](https://user-images.githubusercontent.com/17056169/70216403-91aeba00-1793-11ea-9759-67a64b8422e2.png)
