# List Actifio VDP version

The following is a good start on how you can integrate Jenkins with Actifio VDP appliance. We will be using the Jenkins freestyle job and perform the Build using PowerShell scripts.

You will need to have a Jenkins instance running on Windows and ActPowerCLI installed. If you need information on how to install the ActPowerCLI module, please checkout https://github.com/Actifio/powershell or https://github.com/Actifio/powershell/tree/master/setup-actpowercli .

You will need to create a Jenkins job and 

### Step 1:
Login to the Jenkins server and create a freestyle project by clicking on the New Item link on the top left hand corner. Enter the name of the job - act-lsversion , and click on Freestyle project. Click OK to confirm.

### Step 2:
In this job, we want to allow the user to provide inputs when running the job. We will create three parameters: ActUser, ActPass and ActIP by checking on the This project is parameterized. ActUser and ActIP will be of String type, whereas ActPass will be Password type.
![image](https://user-images.githubusercontent.com/17056169/70215213-206e0780-1791-11ea-8749-e612266cc0b7.png)

### Step 3:
Go to the Build section and define the tasks required to build the job. We will be making calls to Actifio VDP appliance using the commands in ActPowerCLI modules. You can copy and paste the source code from https://github.com/Actifio/ActJenkins/blob/master/act-lsversion/actlsversion.ps1 into the PowerShell Build window .

### Step 4:
To build the job, click on Build with Parameters to kick it off. If required, you can change any the build parameters before triggering the build. 
![image](https://user-images.githubusercontent.com/17056169/70215366-6fb43800-1791-11ea-907c-89c8ba525145.png)

### Step 5:
Once it's completed, click on the Console Output to view the output of the job. An example of the output is as follow:
![image](https://user-images.githubusercontent.com/17056169/70215685-24e6f000-1792-11ea-8326-a1e1a96f2604.png)
