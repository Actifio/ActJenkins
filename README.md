# How to integrate Actifio with Jenkins

### Why do I want integrate with Jenkins?

As you probably aware, Actifio comes with the HTML5 GUI called Actifio Global Manager (AGM). There are times customer will like to use a DevOps CI tool such as Jenkins because:

* Jenkins is more user centric, and easily customise to support self-service
* AGM is more Actifio centric where Jenkins can incorporate other tasks in the jobs
* Jenkins jobs can be integrated with source code repository, scripting languages and other DevOps tools
* Jenkins provide built in automation and scheduling (e-mail notifications, Slack integration)

---

### How do I integrate with Jenkins?

Here is where we share with you how you can easily integrate Actifio related tasks with Jenkins.

The following are some of the project folders demonstrating the integration:

* **act-lsversion** : Jenkins freestyle job to run a single Actifio related commands via ActPowerCLI for Jenkins running on a Windows OS. It also demonstrates parameterized build. 

* **vdp-lsversion** : Jenkins freestyle job to run a single IBM VDP related commands via ActPowerCLI for Jenkins running on a Windows OS.  It also demonstrates parameterized build. 

* **actpipe** : Jenkins declarative pipeline job to run multiple Actifio related commands in stages using ActPowerCLI for Jenkins running on a Windows OS. Also, integrate with GitHub repository.

* **act-runwflow** : Jenkins declarative pipeline job to run multiple Actifio related commands in stages using bash, Oracle SQL scripts and ssh for Jenkins running on a Linux OS.  Also, integrate with GitHub repository and credentials are stored in Jenkins datastore.

---

### Interesting topics on Jenkins

The following are some of the project folders demonstrating advanced Jenkins features:

* **jnks-params** : Different parameterised supported in a Jenkins job
* **jnks-customised** : Customising a Jenkins login page
* **jnks-plugins** : List of useful and handy plugins
* **jnks-cli** : List of useful Jenkins CLI commands
* **jnks-scheduler** : Using Jenkins as a job scheduler
* **jnks-authentication** : Integrating Jenkins with Active Directory
* **jnks-setup** : Setting up Jenkins
---