# How to integrate Actifio with Jenkins

Here is where we share with you how you can easily integrate Actifio related tasks with Jenkins.

The following are some of the project folders:

* **act-lsversion** : Jenkins freestyle job to run a single Actifio related commands via ActPowerCLI for Jenkins running on a Windows OS. It also demonstrates parameterized build. 

* **vdp-lsversion** : Jenkins freestyle job to run a single IBM VDP related commands via ActPowerCLI for Jenkins running on a Windows OS.  It also demonstrates parameterized build. 

* **actpipe** : Jenkins declarative pipeline job to run multiple Actifio related commands in stages using ActPowerCLI for Jenkins running on a Windows OS. Also, integrate with GitHub repository.

* **act-runwflow** : Jenkins declarative pipeline job to run multiple Actifio related commands in stages using bash, Oracle SQL scripts and ssh for Jenkins running on a Linux OS.  Also, integrate with GitHub repository and credentials are stored in Jenkins datastore.
