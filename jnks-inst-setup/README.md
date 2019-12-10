### How to install and setup Jenkins

---
##### Installing Jenkins on Ubuntu
  
Follow the steps below to install Jenkins on Ubuntu:
  
1. Update the Ubuntu operating system with the latest releases: `apt-get update`
2. Jenkins require a web server on the host. We are using nginx on the host. To install: `apt-get install nginx , or apt -y install nginx`
3. Check the status of the nginx web services `service nginx status`
4. Launch a web browser and point to the IP address of this host. You should get a message `Welcome to nginx!`
5. Another package required for Jenkins install is Java. Install it by running: `apt-get install openjdk-7-jdk`
6. To verify if Java is successfully installed, check the version of Java installed: `java -version`
7. Now we are ready to install Jenkins, add the key to apt: `wget -q -O - https://jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -`
8. Next, we will need to add a source list for Jenkins to apt: `sh -c 'echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list'`
9. Update the apt's cache before installing Jenkins: `apt-get update`
10. Install Jenkins on the host: `apt-get install jenkins`
11. Ensure Jenkins is running: `service jenkins status`
12. If you need to restart Jenkins, enter: `service jenkins restart`
  
If you need to find out what Jenkins is doing, check out the Jenkins log file - /var/log/jenkins/jenkins.log .

---

##### Setting Up Jenkins

After we have successfully installed Jenkins, we can now begin setting it up:

1. To setup Jenkins, enter http://IPaddress:8080, you will be prompted for the Administrator's password. Look for it in /var/lib/jenkins/secrets/initialAdminPassword .   
![image](https://user-images.githubusercontent.com/17056169/70364449-c7ad8480-18e0-11ea-961c-066ea07a7748.png)
2. If you need to make modifications to the Jenkins configuration from command line, update the settings in /etc/default/Jenkins file. And, if you need to trouble authentication problems in Jenkins, have a look at /var/log/auth.log .   
3. You can either select Install suggested plugins or select plugins to install. In our case, we choose the former option.   
![image](https://user-images.githubusercontent.com/17056169/70364494-e90e7080-18e0-11ea-8b22-ca5ff192f9d8.png)
4. Click on Continue as admin, or Create First Admin User if required. We will create an admin account named actadmin.   
![image](https://user-images.githubusercontent.com/17056169/70364544-0cd1b680-18e1-11ea-8f25-2f8354799f28.png)
5. Click on Save and Finish.   
![image](https://user-images.githubusercontent.com/17056169/70364592-3a1e6480-18e1-11ea-83e2-b83edb4adc0c.png)

---

On a Windows server running Jenkins, you will need to install Git executable from  https://git-scm.com/download/win . And, be sure to set the following:  

![image](https://user-images.githubusercontent.com/17056169/70527324-c198fb80-1b9f-11ea-95ef-2aa005bb2c38.png)

And, also  

![image](https://user-images.githubusercontent.com/17056169/70527363-df666080-1b9f-11ea-815e-47769ff51a16.png)

---

![image](https://user-images.githubusercontent.com/17056169/70578723-b4612880-1c02-11ea-8a57-9c7f8f4bd071.png)


![image](https://user-images.githubusercontent.com/17056169/70578664-93003c80-1c02-11ea-8eb1-85564e5d42d1.png)

---
  

Click on the Start using Jenkins button to start using Jenkins.
