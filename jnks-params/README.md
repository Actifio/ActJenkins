## Jenkins parameterised build

The following are the different parameterized build supported:

* **STRING** : String  
![image](https://user-images.githubusercontent.com/17056169/70323042-e62f6380-187f-11ea-82a4-3554dbffc6bb.png)

* **PASSWORD** : Password (Hidden)  
![image](https://user-images.githubusercontent.com/17056169/70323072-f6474300-187f-11ea-9726-e3770e1868a6.png)

* **DATE** : Date  
```
Date Format: yyyy-MM-dd  |  dd/MM/yyyy

LocalDate.now();
LocalDate.now().plusDays(1).plusMinutes(5);
LocalDate.now().plusDays(1).plusMinutes(5).plusYears(1);
LocalDate.now().minusDays(5);
Default Value: LocalDate.now().minusDays(1);  |  01/05/2017
```
![image](https://user-images.githubusercontent.com/17056169/70323111-0e1ec700-1880-11ea-9b47-828bb5559331.png)

* **BOOLEAN** : Boolean   

* **CHOICE** : Choice  
![image](https://user-images.githubusercontent.com/17056169/70323130-1b3bb600-1880-11ea-8112-268dbca63951.png)

* **CHOICE** : Active Choices  
![image](https://user-images.githubusercontent.com/17056169/70323144-28f13b80-1880-11ea-8c6b-ba34574de2e1.png)

Using Groovy Script:   
![image](https://user-images.githubusercontent.com/17056169/70323177-41f9ec80-1880-11ea-89c9-40e91b7ea9e9.png)

----

How to reference the vaule in Jenkins running on Linux?

bash:
Built-in:
```
$hostname
```
Reference:
```
echo "The current state in Australia is ${CurrState}"
```
----

How to reference the vaule in Jenkins running on Windows?

Windows PowerShell:
Built-in:
```
$env:hostname
```
Reference:
```
LoginServer -User $UserID -Password $UserPass
```
