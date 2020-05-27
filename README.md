# How to integrate Actifio with Jenkins

![image](https://user-images.githubusercontent.com/17056169/70358217-f1f54700-18cc-11ea-864f-2abecadaf539.png)

### Why do I want integrate with Jenkins?

As you probably aware, Actifio comes with the HTML5 GUI called Actifio Global Manager (AGM). There are times customer will like to use a DevOps CI tool such as Jenkins because:

* Jenkins is more user centric, and easily customise to support self-service
* AGM is more Actifio centric where Jenkins can incorporate other tasks in the jobs
* Jenkins jobs can be integrated with source code repository, scripting languages ((bash, Ruby, Python, Powershell, Java, Gradle, Groovy, etc) and other DevOps tools
* Jenkins provide built in automation and scheduling (e-mail notifications, Slack integration), highly extensible and rich plug-ins ecosystem. 

I have put together a [blog post](https://github.com/Actifio/ActJenkins/blob/master/Blog_Integrating_VDP_with_Jenkins.MD "Infrastructure as Code") on leveraging Jenkins to deploy virtual databases - **Infrastructure as Code**. This approach allows you to place all the SQL and Actifio related scripts in SCM such as GitHub. User will just need to commit the changes, and the database build/provision will be fully automated. 

---

### How do I integrate with Jenkins?

Here is where we share with you how you can easily integrate Actifio related tasks with Jenkins.

The following are some of the project folders demonstrating the integration:

* [**act-job-lsversion**](https://github.com/Actifio/ActJenkins/tree/master/act-job-lsversion) : Jenkins freestyle job to run a single Actifio related commands via ActPowerCLI for Jenkins running on a Windows OS. It also demonstrates simple parameterized build. 

* [**act-pipeline-runcommands**](https://github.com/Actifio/ActJenkins/tree/master/act-pipeline-runcommands) : Jenkins declarative pipeline job to run multiple Actifio related commands in stages using ActPowerCLI for Jenkins running on a Windows OS. Also, integrate with GitHub repository.  

* **act-pipeline-runworkflow** WIP : Jenkins declarative pipeline job to run multiple Actifio related commands in stages using bash, Oracle SQL scripts and ssh for Jenkins running on a Linux OS.  Also, integrate with GitHub repository and credentials are stored in Jenkins datastore.  

* [**act-job-runworkflow**](https://github.com/Actifio/ActJenkins/tree/master/act-job-runworkflow) : Jenkins freestyle job to refresh an Actifio workflow via ActPowerCLI for Jenkins running on a Windows OS. It also demonstrates advanced parameterized build using Groovy script. 

* [**vdp-job-lsversion**](https://github.com/Actifio/ActJenkins/tree/master/vdp-job-lsversion) : Jenkins freestyle job to run a single IBM VDP related commands via ActPowerCLI for Jenkins running on a Windows OS.  It also demonstrates simple parameterized build. 

---

### Interesting topics on Jenkins

The following are some of the project folders demonstrating advanced Jenkins features:

* [**jnks-params**](https://github.com/Actifio/ActJenkins/tree/master/jnks-params) : Different parameterised supported in a Jenkins job
* [**jnks-customised**](https://github.com/Actifio/ActJenkins/tree/master/jnks-customised) : Customising a Jenkins login page
* **jnks-plugins** : List of useful and handy plugins
* **jnks-cli** : List of useful Jenkins CLI commands
* [**jnks-scheduler**](https://github.com/Actifio/ActJenkins/tree/master/jnks-scheduler) : Using Jenkins as a job scheduler
* [**jnks-authentication**](https://github.com/Actifio/ActJenkins/tree/master/jnks-authentication) : Integrating Jenkins with Active Directory
* [**jnks-inst-setup**](https://github.com/Actifio/ActJenkins/tree/master/jnks-inst-setup) : Installing and setting up Jenkins

---
