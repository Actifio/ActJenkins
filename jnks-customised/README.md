### How to customise the Jenkins login page

Jenkins can run on the Windows and Linux server. Once you login, the header on the Jenkins server looks and feel the same. What if you would like to have a different header between the Windows and Linux server.

You can customize the page by replacing the image file in the Jenkins directory.

#### Windows

Replace the **title.png** in ***C:\Program Files (x86)\Jenkins\war\images*** directory with an image such as the follow:   
![title_windows](https://user-images.githubusercontent.com/17056169/70356130-cd4aa080-18c7-11ea-934d-7a5f3a74d7fd.png)

#### Linux

Replace the **title.png** in ***/var/cache/jenkins/war/images*** directory with an image such as the follow:    
![title_linux](https://user-images.githubusercontent.com/17056169/70356090-b60bb300-18c7-11ea-98eb-7d475a547a7b.png)

Restart the Jenkins server for the changes to take effect.
