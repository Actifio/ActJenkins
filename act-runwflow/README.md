# Building an Actifio job using Jenkins pipeline { DRAFT }

As an alternative way of running a Jenkins job as freestyle, consider using the Jenkins pipeline.

The following is a an example of how we can integrate Jenkins with Actifio VDP appliance and deploy the build job as a pipeline. The pipeline approach allows us to visualise the build and build the job using scripts/code. The code can be checked out from a source code repository and build can automated, in this case provisioning of virtual copies of applications managed by Actifio VDP.

You will need to have a Jenkins instance running on Linux installed. By default, bash will be available and we will be using bash to trigger the jobs on the remote server. Install git on the Jenkins server to allow the job to clone source code from GitHub repository. Also, check under Plugin Manager to ensure that 
- Blue Ocean plugin: This plugin provides you an intuitive and visual view of the build

In this example, we will be using the public/private key to connect from the Jenkins server to the Oracle server. We will be ssh-ing to the Oracle server as oracle from the jenkins user on the Jenkins server. In Jenkins, we will be storing the credential in Jenkins store. In addition, we will also be storing the system Oracle user along with the password. 

![image](https://user-images.githubusercontent.com/17056169/70307398-2df0c380-185d-11ea-89f0-c44121584065.png)

Following is how we store
a) ssh keys
![image](https://user-images.githubusercontent.com/17056169/70307439-46f97480-185d-11ea-8b63-2abd42f51647.png)

b) Oracle credentials to the Oracle database
![image](https://user-images.githubusercontent.com/17056169/70307521-79a36d00-185d-11ea-85e2-d55f94327a02.png)

We will be creating a Jenkins pipeline job that queries the Oracle database before and after the refresh.

### Step 1:
Login to the Jenkins server and create a pipeline project by clicking on the New Item link on the top left hand corner. Enter the name of the job - refresh-db , and click on Pipeline project. Click OK to confirm.


### Step 2:

Under the pipeline section, we will be using the Jenkins declarative pipeline, instead of the scripted pipeline. Declarative is simpler to learn and more friendly syntax in defining the how the job is being built. Scripted pipeline is based on Groovy programming language, and more complex if you are not a developer.

In this job, we have broken into five stages: 1) clone a copy of the code from GitHub, 2) Query the Oracle database before refresh 3) Refresh the database 4) Query the Oracle database after refresh, and 5) Clean up the cloned GitHub directory

The Oracle SQL and bash scripts are stored in the https://github.com/Actifio/ActJenkins/tree/master/act-runwflow folder. This way once the job is created, DevOps engineers can make changes to the code the Git repository and not worry of propagating the changes to Jenkins.

Enter the following code in the rectangle box in the Pipeline section:

```
#!/usr/bin/env groovy

def runFunc() {

  def ora_owner = 'oracle'
  def act_ip = '10.65.5.193'
  def sql_script = 'query_db.sql'
  def ora_sid = 'demodb'
    
  withCredentials([sshUserPrivateKey(credentialsId: 'syd-ora12-1', keyFileVariable: 'KEY')]) {
    sh "scp -o StrictHostKeyChecking=no -i ${KEY} $sql_script $ora_owner@$act_ip:/tmp "
    withCredentials([usernamePassword(credentialsId: 'system_ora', passwordVariable: 'ora_pw', usernameVariable: 'ora_user')]) {
      sh "ssh -o StrictHostKeyChecking=no -i ${KEY} $ora_owner@$act_ip 'export ORACLE_SID=$ora_sid; export ORAENV_ASK=no; \
      source oraenv -s ; sqlplus $ora_user/$ora_pw as sysdba @/tmp/$sql_script'"  
      }
    }  
}

def runActFunc() {


  def act_script = 'refresh_db.sh'
  def ora_sid = 'demodb'
  def ora_owner = 'oracle'
  def act_ip = '10.65.5.193'  
    
  withCredentials([sshUserPrivateKey(credentialsId: 'syd-ora12-1', keyFileVariable: 'KEY')]) {
    sh "scp -o StrictHostKeyChecking=no -i ${KEY} $act_script $ora_owner@$act_ip:/tmp "
    sh "ssh -o StrictHostKeyChecking=no -i ${KEY} $ora_owner@$act_ip 'chmod 0755 /tmp/$act_script'" 
    sh "ssh -o StrictHostKeyChecking=no -i ${KEY} $ora_owner@$act_ip '/tmp/$act_script'" 
    }  
}

pipeline {
   agent any

   stages {
      stage('Git checkout') {
         steps {
            echo 'Cloning repository'
            sh 'git clone https://github.com/Actifio/ActJenkins.git'
            sh 'cp ActJenkins/act-runwflow/refresh_db.sh .'
            sh 'cp ActJenkins/act-runwflow/query_db.sql .'
         }
      }

      stage('pre-refresh') {
         steps {
            echo 'pre-refresh'
            runFunc()
         }
      }

      stage('Refresh database from Actifio') {
         steps {
            echo 'refresh DB'
            runActFunc()
         }
      }

      stage('post-refresh') {
         steps {
            echo 'post-refresh'
            runFunc()
         }
      }      

      stage('Cleaning up repo') {
         steps {
            echo 'Removing working directory'
            dir('ActJenkins') {
              deleteDir()
              }
         }
      }   

   }
}
```

### Step 4:
To build the job, click on Build with Parameters to kick it off. 
