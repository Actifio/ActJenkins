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

### Step 2:

Under the pipeline section, we will be using the Jenkins declarative pipeline, instead of the scripted pipeline. Declarative is simpler to learn and more friendly syntax in defining the how the job is being built. Scripted pipeline is based on Groovy programming language, and more complex if you are not a developer.

Enter the following code:

```
pipeline {
    agent any 

    // variables for the parameterised execution
    parameters {
      string(defaultValue: "admin", description: 'Actifio Username', name: 'ActUser')
      password(defaultValue: "actifio", description: 'Actifio Password', name: 'ActPass')
      string(defaultValue: "10.65.5.35", description: 'Actifio Appliance', name: 'ActIP')  
    }

    environment {
       PATH = "C:\\WINDOWS\\SYSTEM32"
       }

    stages {

        stage('Clone Git repo ') {
            agent any 
            steps {

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
To build the job, click on Build with Parameters to kick it off. If required, you can change any the build parameters before triggering the build. 


### Step 5:
Once it's completed, click on the Console Output to view the output of the job. An example of the output is as follow:
