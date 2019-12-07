### Using the periodic build in Jenkins

Jenkins allow you to run a job on-demand or at a specific time. If you would like to schedule the job, select the **Build periodically** option under the **Build Triggers** section.
  
The box next to **Schedule** label accepts a crontab like syntax.  

For instance, @hourly runs it every hour and * * * * * runs it every minute. If you set it to 0 */3 * * *, the job will run every 3 hours, and perform 8 build everyday. Once you saved the job, the scheduler will start the job at its designated times.  
  
See below for an example:  
  
![image](https://user-images.githubusercontent.com/17056169/70363737-b8790780-18dd-11ea-8782-35643a9896a2.png)

Reference:
```
* * * * * command to be executed
– – – – –
| | | | |
| | | | +—– day of week (0 – 6) (Sunday=0)
| | | +——- month (1 – 12)
| | +——— day of month (1 – 31)
| +———– hour (0 – 23)
+————- min (0 – 59)
```
---
```
* * * * * #Runs every minute
30 * * * * #Runs at 30 minutes past the hour
45 6 * * * #Runs at 6:45 am every day
45 18 * * * #Runs at 6:45 pm every day
00 1 * * 0 #Runs at 1:00 am every Sunday
00 1 * * 7 #Runs at 1:00 am every Sunday
00 1 * * Sun #Runs at 1:00 am every Sunday
30 8 1 * * #Runs at 8:30 am on the first day of every month
00 0-23/2 02 07 * #Runs every other hour on the 2nd of July
```
---
```
@reboot #Runs at boot
@yearly #Runs once a year [0 0 1 1 *]
@annually #Runs once a year [0 0 1 1 *]
@monthly #Runs once a month [0 0 1 * *]
@weekly #Runs once a week [0 0 * * 0]
@daily #Runs once a day [0 0 * * *]
@midnight #Runs once a day [0 0 * * *]
@hourly #Runs once an hour [0 * * * *]
```
