# How to integrate Actifio with Jenkins

![image](https://user-images.githubusercontent.com/17056169/70358217-f1f54700-18cc-11ea-864f-2abecadaf539.png)

### Why do I want integrate with Jenkins?

As you probably aware, Actifio comes with the HTML5 GUI called Actifio Global Manager (AGM). There are times customer will like to use a DevOps CI tool such as Jenkins because:

* Jenkins is more user centric, and easily customise to support self-service
* AGM is more Actifio centric where Jenkins can incorporate other tasks in the jobs
* Jenkins jobs can be integrated with source code repository, scripting languages ((bash, Ruby, Python, Powershell, Java, Gradle, Groovy, etc) and other DevOps tools
* Jenkins provide built in automation and scheduling (e-mail notifications, Slack integration), highly extensible and rich plug-ins ecosystem. 

---

### How do I integrate with Jenkins?

Here is where we share with you how you can easily integrate Actifio related tasks with Jenkins.

The following are some of the project folders demonstrating the integration:

* [**act-lsversion**](https://github.com/Actifio/ActJenkins/tree/master/act-lsversion) : Jenkins freestyle job to run a single Actifio related commands via ActPowerCLI for Jenkins running on a Windows OS. It also demonstrates parameterized build. 

* [**vdp-lsversion**](https://github.com/Actifio/ActJenkins/tree/master/vdp-lsversion) : Jenkins freestyle job to run a single IBM VDP related commands via ActPowerCLI for Jenkins running on a Windows OS.  It also demonstrates parameterized build. 

* [**actpipe**](https://github.com/Actifio/ActJenkins/tree/master/actpipe) : Jenkins declarative pipeline job to run multiple Actifio related commands in stages using ActPowerCLI for Jenkins running on a Windows OS. Also, integrate with GitHub repository.

* **act-runwflow** : Jenkins declarative pipeline job to run multiple Actifio related commands in stages using bash, Oracle SQL scripts and ssh for Jenkins running on a Linux OS.  Also, integrate with GitHub repository and credentials are stored in Jenkins datastore.

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
