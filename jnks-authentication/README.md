### How to configure AD authentication

Jenkins allow you to log in using the Active Directory credentials instead of the local credentials. Follow the below steps on how to set it up:

1. Install the Active Directory Plugin
Jenkins Main Page -> Manage Jenkins -> Manage Plugins -> Available tab and enter "active d" next to Filter search. Select Active Directory and click **Download now and install after restart** button.

![image](https://user-images.githubusercontent.com/17056169/70422410-d00fe600-1abf-11ea-8210-de97e94d53ef.png)

This will lead to the installation page and select **Restart Jenkins when installation is complete and no jobs are running** .

![image](https://user-images.githubusercontent.com/17056169/70422739-4f051e80-1ac0-11ea-89d1-8e0b10512cc1.png)

2. Configure the new security settings
Jenkins Main Page  -> Manage Jenkins -> Configure Global Security

![image](https://user-images.githubusercontent.com/17056169/70422779-66dca280-1ac0-11ea-954b-5c1e81ccecb5.png)

3. Check on Enable security, and select Active Directory. Click Add Domain.

![image](https://user-images.githubusercontent.com/17056169/70365293-d39b4580-18e4-11ea-8558-e3196b907b83.png)

4. Fill up each field and when ready, click on the Test Domain Button. If everything is working fine, you will see the **Success** message displayed after the TLS Configuration field.

![image](https://user-images.githubusercontent.com/17056169/70423052-e4a0ae00-1ac0-11ea-8a19-aa11f281a905.png)

5. To configure the authorized users, you can either use:

a) Any logged-in users can do anything under **Authorization**
![image](https://user-images.githubusercontent.com/17056169/70423431-9213c180-1ac1-11ea-9d9d-02097bedc481.png)

b) **Matrix-based security** where you add the desired users and groups to controll the role-based access control
![image](https://user-images.githubusercontent.com/17056169/70423458-a061dd80-1ac1-11ea-8122-6efc14f58af8.png)

6. Now you can login Jenkins with the Active Directory credentials
