## Integrating Actifio with Jenkins

Date: 28-Apr-2020		
Category: DevOps 

### Introduction

Jenkins is considered by many commentators to be one of the most popular continuous integration (CI) tool in DevOps. Customers implement Jenkins in their organisations so they can build software more efficiently because Jenkins makes it easy to integrate code changes made by software developers and allows the build process to be automated. In some cases, this tool can also be used to provision test systems and environments required by different teams and projects.
</br></br>
Actifio Virtual Data Pipeline (VDP) software platform is a data virtualisation tool that allows users in different environments to access data and databases instantly in a highly efficient manner. Typically, customers will face major challenges when provisioning large datasets (data and databases) to test environments. The challenges are not having enough storage resources to hold the datasets, demands on backup administrator and DBA time, and a time consuming restore process. Actifio addresses these challenges by provisioning virtual near real time copies of databases in minutes regardless of the size of those databases, whilst consuming only MBs of storage.
</br>

### Similar Benefits

There are many benefits of Jenkins as compared with other CI tools. Actifio in a similar way also provides tremendous value its customers. The following are some similarities and key benefits for both:


| Features | Jenkins | Actifio | 
| -------- | ------- | ------- |
| Simplicity | Easy to install, very simple to get started using the easy-to-use UI | Easy to deploy and UI is designed based on use case i.e. TDM/DevOps, Resiliency, and DR. |
| Extensible | Available on many different platforms & OS, third-party plugins extend it further | Actifio can be used with many different platforms, Operating Systems and all of the major/popular databases.  |
| Integration | Supports integration with CLI, PowerShell, python, RESTful API build | Easily integrate with any platform using CLI, PowerShell, python, RESTful API.  |
| Scalable | Master-slave architecture allows distributed builds | Actifio software supports scale-out architecture as increase number of users & database environments. | 
| Support | Available on-premise, public cloud and SaaS (CloudBees) | VDP is available on-premise, public cloud (marketplace) and SaaS. |
</br>

### Why Integrate Actifio with Jenkins

In a music orchestra concert, a conductor provides instructions to the musicians on the interpretation of the music piece. Each musician must be equipped with the best musical equipment to ensure the performance is phenomenal.  Similarly, in DevOps, Jenkins is analogous to that conductor.  It orchestrates or assigns the different work to the different tools during the build process. Actifio is the best database provisioning tool and it can easily integrate into Jenkins. This will ensure the databases are successfully deployed and working properly before notifying the users of the provisioned environment.
</br>

The following are some of the reasons for integrating Actifio with Jenkins:

1.	Historical build data: Jenkins stores a log of every deployment. This information will be very useful for troubleshooting and audit purposes. Every database, along with the settings and version, that was provisioned for testing are stored.

2.	Self-service: Users can refresh databases from Jenkins portal, enabling self-service capability. There is no need for them to login to servers and restarting applications & database services. Of course, we can ensure role-based access control by integrating with directory services such as Microsoft Active Directory or LDAP.

3.	Automated: By integrating with Source Code Management (SCM), developers can commit the code, and the entire automated build process is automatically triggered resulting in code build and databases provisioned using the latest data.

 

4.	Governance: Actifio can ensure that sensitive data is masked using the automated workflow features, and users are only allowed access to the masked data. It also provides visibility of which target hosts have access to which database.

5.	Agnostics: By decoupling the databases from compute, Jenkins can easily refresh the Actifio managed databases without impacting the host during the refresh process. Actifio is also agnostic to any storage or compute platforms and is available on-premise and in any of the public cloud.


### Summary

To summarize, if you are currently using Jenkins, Actifio will offers tremendous benefits to the entire CI process. Actifio helps with:

- Speeding up the entire data provisioning process
- Seamlessly integration with the Jenkins environment
- Dramatically reducing the amount of storage consumed by large databases
- Improving software quality by providing a full copy of data to the users
- Ensuring data is masked and serves as a data governance tool in the CI process

If you want to learn more about how Actifio works to integrate with your Jenkins environment, please register here to talk to a DevOps expert and also see a live demo.
