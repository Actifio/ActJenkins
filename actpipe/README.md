# Building an Actifio job using Jenkins pipeline 

As an alternative way of running a Jenkins job as freestyle, consider using the Jenkins pipeline.

The following is a an example of how we can integrate Jenkins with Actifio VDP appliance and deploy the build job as a pipeline. The pipeline approach allows us to visualise the build and build the job using scripts/code. The code can be checked out from a source code repository and build can automated, in this case provisioning of virtual copies of applications managed by Actifio VDP.

You will need to have a Jenkins instance running on Windows and ActPowerCLI installed. Also, check under Plugin Manager to ensure that 
- PowerShell plugin: This plugin is required to support Windows PowerShell as build scripts.
- Blue Ocean plugin: This plugin provides you an intuitive and visual view of the build
- Git executable: Install Git software on the Windows server hosting the Jenkins server.

We will be creating a Jenkins pipeline job that accepts Actifio VDP CLI user and credentials, login to the appliance and as part of the pipeline, run two stages: check the VDP version and check the health of the appliance.

### Step 1:
Login to the Jenkins server and create a pipeline project by clicking on the New Item link on the top left hand corner. Enter the name of the job - act-pipe-ls-health , and click on Pipeline project. Click OK to confirm.

![image](https://user-images.githubusercontent.com/17056169/70288911-45ad5500-1827-11ea-8d6d-3b87ef8c9517.png)

### Step 2:

Under the pipeline section, we will be using the Jenkins declarative pipeline, instead of the scripted pipeline. Declarative is simpler to learn and more friendly syntax in defining the how the job is being built. Scripted pipeline is based on Groovy programming language, and more complex if you are not a developer.

In this job, we have broken into four stages: 1) clone a copy of the code from GitHub, 2) Run the PowerShell script containing the udsinfo lsversion code, 3) Run the PowerShell script containing the reporthealth script, and 4) Clean up the cloned GitHub directory

Enter the following code in the rectangle box in the Pipeline section:
![image](https://user-images.githubusercontent.com/17056169/70289011-94f38580-1827-11ea-90f8-227beccfa2ab.png)

```
pipeline {
    agent any 

    // variables for the parameterised execution
    parameters {
      string(defaultValue: "admin", description: 'Actifio Username', name: 'ActUser')
      password(defaultValue: "TopSecret", description: 'Actifio Password', name: 'ActPass')
      string(defaultValue: "10.65.5.99", description: 'Actifio Appliance', name: 'ActIP')  
    }

    environment {
       PATH = "C:\\WINDOWS\\SYSTEM32"
       }

    stages {

        stage('Clone Git repo ') {
            agent any 
            steps {
        		dir('ActJenkins') {
                   deleteDir()
                   }
                echo "Cloning the Git repo to workspace location: ${env.WORKSPACE}"  
        		bat 'dir'
        		bat '"C:\\Program Files\\Git\\bin\\git.exe" clone https://github.com/Actifio/ActJenkins.git'
        		bat 'dir'
            }
        }

        stage('List VDP version') {
            agent any
            steps {
                echo 'Listing VDP version...'
                script {
         			// Run the udsinfo lsversion script
         			msg = powershell(script:"ActJenkins\\actpipe\\list_vdp_ver.ps1 ${ActUser} ${ActPass} ${ActIP}", returnStdout:true).trim() 
         			println msg
         			}
            	}
        	}
        stage('Execute reporthealth') {
            agent any
            steps {
                echo 'Running reporthealth ...'
                script {
         			// Run the reporthealth script
         			msg = powershell(script:"ActJenkins\\actpipe\\rpt_health.ps1 ${ActUser} ${ActPass} ${ActIP}", returnStdout:true).trim() 
         			println msg
         			}
            	}
        	}
        stage('Cleanup working Git cloned repo ') {
            agent any 
            steps {
                bat 'dir'
        		dir('ActJenkins') {
                   deleteDir()
                   }
        		bat 'dir'
            }
        }        	
    }
}
```

### Step 4:
To build the job, click on Build with Parameters to kick it off. The first job failed as the parameters are not passed to the job. As you can see in the code, we are creating the parameters in the Jenkins declarative code.
```
    // variables for the parameterised execution
    parameters {
      string(defaultValue: "admin", description: 'Actifio Username', name: 'ActUser')
      password(defaultValue: "TopSecret", description: 'Actifio Password', name: 'ActPass')
      string(defaultValue: "10.65.5.99", description: 'Actifio Appliance', name: 'ActIP')  
    }
```
Run the job again, and you will be prompted for the Actifio related parameters:
![image](https://user-images.githubusercontent.com/17056169/70289304-73df6480-1828-11ea-8e85-9f7784a5cf21.png)

If required, you can change any the build parameters before triggering the build. Click on Build to start.

### Step 5:
Once it's completed, click on the Console Output to view the output of the job. An example of the output is as follow:
![image](https://user-images.githubusercontent.com/17056169/70289714-c2413300-1829-11ea-94b4-edfbecbddb68.png)

As you can see all four stages have completed successfully. Click on the Open Blue Ocean link on the left pane, and you will be presented another view of the job. Click on the Check box in the green circle.
![image](https://user-images.githubusercontent.com/17056169/70289890-59a68600-182a-11ea-85fd-d4fe9281b06b.png)

In the following screen, it will list the details of each stage of the job. Click on the stage (1) and expand the Print Message to view the output of the command.
![image](https://user-images.githubusercontent.com/17056169/70289981-9ecab800-182a-11ea-9b02-fee962b71061.png)


## Conclusion
Using this approach, we can easily create Jenkins pipeline job to integrate the database refresh using Actifio. We can include stages to shutdown applications connecting to the database, connect to database and extract information from tables to be restored after we have refreshed or provisioned the virtual database from Actifio. The benefit of this approach is to have all the scripts stored in a version control system, making the entire refresh highly agile and scalable. 
