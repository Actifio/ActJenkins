### Using the periodic build in Jenkins

Jenkins allow you to run a job on-demand or at a specific time. If you would like to schedule the job, select the **Build periodically** option under the **Build Triggers** section.
  
The box next to **Schedule** label accepts a crontab like syntax.  

For instance, @hourly runs it every hour and * * * * * runs it every minute. If you set it to 0 */3 * * *, the job will run every 3 hours, and perform 8 build everyday. Once you saved the job, the scheduler will start the job at its designated times.  
  
See below for an example:  
  
![image](https://user-images.githubusercontent.com/17056169/70363737-b8790780-18dd-11ea-8782-35643a9896a2.png)
