# Building a Jenkins freestyle job that refresh an Actifio workflow

The following is an example to build a Jenkins freestyle on Jenkins Windows server. The job uses a referenced parameter that dynamically queries an Actifio VDP appliance for the application types (Oracle, SQLServer, Sybase, etc). Based on the application type, it will dynamically populate the list of applications, ad lastly the list of workflows available.

Ensure that the PowerShell plugin is installed on the Jenkins server running Windows OS. This will allow write PowerShell script for the build.

The high-level steps is as follow:

## Step 1
Create a new freestyle job

## Step 2
Copy the supporting scripts in https://github.com/Actifio/ActJenkins/tree/master/jnks-params project and run_wflow.ps1 in https://github.com/Actifio/ActJenkins/tree/master/act-job-runworkflow to C:\SQL directory on Jenkins server on Windows

## Step 3
Define Jenkins parameters at the start of the build. We will be using Groovy script that reference other parameters. For more information on the setup, please refer to https://github.com/Actifio/ActJenkins/tree/master/jnks-params under the **Jenkins parameterised build using Active Choices Reactive parameter** section.

## Step 4
Trigger PowerShell script by calling the PowerShell script that refresh the database/application using a workflow
