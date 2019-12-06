# Building an Actifio job using Jenkins pipeline 

As an alternative way of running a Jenkins job as freestyle, consider using the Jenkins pipeline.

The following is a an example of how we can integrate Jenkins with Actifio VDP appliance and deploy the build job as a pipeline. The pipeline approach allows us to visualise the build and build the job using scripts/code. The code can be checked out from a source code repository and build can automated, in this case provisioning of virtual copies of applications managed by Actifio VDP.

You will need to have a Jenkins instance running on Linux installed. By default, bash will be available and we will be using bash to trigger the jobs on the remote server. Install git on the Jenkins server to allow the job to clone source code from GitHub repository. Also, check under Plugin Manager to ensure that 
- Blue Ocean plugin: This plugin provides you an intuitive and visual view of the build

In this example, we will be using the public/private key to connect from the Jenkins server to the Oracle server. We will be ssh-ing to the Oracle server as oracle from the jenkins user on the Jenkins server. In Jenkins, we will be storing the credential in Jenkins store. In addition, we will also be storing the system Oracle user along with the password. 

Following is how we store
a) ssh keys
b) Oracle credentials to the Oracle database


We will be creating a Jenkins pipeline job that queries the Oracle database before and after the refresh.


### Step 1:
Login to the Jenkins server and create a pipeline project by clicking on the New Item link on the top left hand corner. Enter the name of the job - refresh-db , and click on Pipeline project. Click OK to confirm.


### Step 2:

Under the pipeline section, we will be using the Jenkins declarative pipeline, instead of the scripted pipeline. Declarative is simpler to learn and more friendly syntax in defining the how the job is being built. Scripted pipeline is based on Groovy programming language, and more complex if you are not a developer.

In this job, we have broken into four stages: 1) clone a copy of the code from GitHub, 2) Run the PowerShell script containing the udsinfo lsversion code, 3) Run the PowerShell script containing the reporthealth script, and 4) Clean up the cloned GitHub directory

Both the PowerShell scripts in Stage 2 and 3 are stored in the https://github.com/Actifio/ActJenkins/tree/master/actpipe folder. This way once the job is created, DevOps engineers can make changes to the code the Git repository and not worry of propagating the changes to Jenkins.

Enter the following code in the rectangle box in the Pipeline section:

```

```

### Step 4:
To build the job, click on Build with Parameters to kick it off. The first job failed as the parameters are not passed to the job. As you can see in the code, we are creating the parameters in the Jenkins declarative code.
