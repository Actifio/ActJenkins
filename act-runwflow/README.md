# Building an Actifio job using Jenkins pipeline { DRAFT }

As an alternative way of running a Jenkins job as freestyle, consider using the Jenkins pipeline.

The following is a an example of how we can integrate Jenkins with Actifio VDP appliance and deploy the build job as a pipeline. The pipeline approach allows us to visualise the build and build the job using scripts/code. The code can be checked out from a source code repository and build can automated, in this case provisioning of virtual copies of applications managed by Actifio VDP.

You will need to have a Jenkins instance running on Linux installed. By default, bash will be available and we will be using bash to trigger the jobs on the remote server. Install git on the Jenkins server to allow the job to clone source code from GitHub repository. Also, check under Plugin Manager to ensure that 
- Blue Ocean plugin: This plugin provides you an intuitive and visual view of the build

In this example, we will be using the public/private key to connect from the Jenkins server to the Oracle server. We will be ssh-ing to the Oracle server as oracle from the jenkins user on the Jenkins server. 

The following is how we login to the Oracle server from the Jenkins server.
```
jenkins@dev-ubuntu:~$ ls -la .ssh
total 20
drwx------  2 jenkins jenkins 4096 Dec  3 11:54 .
drwxr-xr-x 19 jenkins jenkins 4096 Dec  6 14:26 ..
-rw-------  1 jenkins jenkins 1679 Dec  3 11:41 id_rsa
-rw-r--r--  1 jenkins jenkins  400 Dec  3 11:41 id_rsa.pub
-rw-r--r--  1 jenkins jenkins  666 Dec  6 14:32 known_hosts
jenkins@dev-ubuntu:~$ ssh-copy-id -i .ssh/id_rsa.pub oracle@10.65.5.193
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: ".ssh/id_rsa.pub"
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
oracle@10.65.5.193's password: 

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh 'oracle@10.65.5.193'"
and check to make sure that only the key(s) you wanted were added.

jenkins@dev-ubuntu:~$ ssh oracle@10.65.5.193
Last login: Fri Dec  6 14:33:08 2019 from 10.65.5.138
[oracle@syd-ora12-1 ~]$ exit
logout
Connection to 10.65.5.193 closed.
```

In Jenkins, we will be storing the credential in Jenkins store. In addition, we will also be storing the system Oracle user along with the password. 

![image](https://user-images.githubusercontent.com/17056169/70307398-2df0c380-185d-11ea-89f0-c44121584065.png)

Following is how we store
a) ssh keys

Get the SSH key that we used earlier:
```
jenkins@dev-ubuntu:~$ cat .ssh/id_rsa.pub 
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDAvWyT4XhqXkZIDoThVWndHpzd2JxAqdt4m5HPTGYYvIFcA/XdvOgK9p+4OxonyFUpIJduNzALuQOUlvHrHA6iagbFbRChWD5Dq09bYclV6E/9AJrCODn+mZi6oLUu6N1cCDegDgvYJeLBZkOK/ZYNM9IqzjSgJR4fuL5HoUGjbSyUg2n/w+5Ft0pwEiP94erNWdO9Wn7NuAuYtv3GLiPtkNrhqd3Ctd2FE1ZUSE6Bly9B5/y1NYAyZfPFgVmTw6AmG8HIJMy58rmiI2EY/2Xv+/NNzUJFk//RBUpJtxvbUBwgllxHYlCIFG1lqd9Sp/AcEwLd/H6RDINPndugfMOB jenkins@dev-ubuntu
```

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
![image](https://user-images.githubusercontent.com/17056169/70308363-31854a00-185f-11ea-831a-2d545676dde7.png)


### Step 5:
Click on the Blue Ocean link to have a better view of job.
![image](https://user-images.githubusercontent.com/17056169/70308468-6ee9d780-185f-11ea-9c2b-6954c6328c4b.png)

Click on one of the many stages, and view the output.
![image](https://user-images.githubusercontent.com/17056169/70308486-7b6e3000-185f-11ea-971f-b9883aa8cc55.png)
