run_wflow.ps1 ActIP ActUser ActPass WFlowName $Env:WorkflowList

param(
[string] $ActIP,
[string] $ActUser,
[string] $ActPass,
[string] $WFlowName)

$env:IGNOREACTCERTS = $true
 
$LocalTempDir = "c:\temp\"
If(!(test-path $LocalTempDir)) {
    New-Item -ItemType Directory -Force -Path $LocalTempDir | out-null
    }
    
$TmpPasswdFile = "$LocalTempDir\$env:USERNAME-passwd.key"

"$ActPass" | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString | Out-File $TmpPasswdFile

if (! $env:ACTSESSIONID ){
   Connect-Act $ActIP -actuser $ActUser -passwordfile $TmpPasswdFile -ignorecerts | Out-Null
}





if (! $env:ACTSESSIONID ){
   write-warning "Login to CDS $ActIP failed"
   break
   }
 else {

   $workflow_name = $WFlowName -replace "`n", ""
   $workflow_id = $(udsinfo lsworkflow | where-object {$_.name -eq $workflow_name}).id
   write-output "Kicking off workflow $workflow_name ( ID: $workflow_id ) `n"

   udstask runworkflow $workflow_id | out-null   
   $rc = $(reportworkflows -s | where-object { $_.ID -eq  $workflow_id })
   if ($rc.status -ne "RUNNING") { write-output "Unable to trigger workflow - $($rc.steps)" ; exit 1}

   sleep -Seconds 30
   $srchost = $(reportworkflows | where {$_.WorkflowName -eq $workflow_name } ).SourceHostName
   $appname = $(reportworkflows | where {$_.WorkflowName -eq $workflow_name } ).SourceAppName
   $vdb = $(reportworkflows | where {$_.WorkflowName -eq $workflow_name } ).TargetApp
   $appid = $(reportworkflows | where {$_.WorkflowName -eq $workflow_name } ).SourceAppID

   $JobID = $(reportrunningjobs | where { $_.HostName -eq $srchost -And $_.AppName -eq $appname -And ($_.JobClass -eq 'mount(AppAware)' -Or $_.JobClass -eq 'reprovision(AppAware)') }).JobName
   $JobStatus = $(reportrunningjobs | where { $_.JobName -eq $JobID }).status
   $PrevJobPct = "0"
   if ($JobStatus -eq 'running') {
     Write-Host "Job is now running.... "
     while ('running' -eq $JobStatus) {
       $JobPct = $(reportrunningjobs | where { $_.JobName -eq $JobID })."Progress%"
       if ($PrevJobPct -ne $JobPct) {
         $PrevJobPct = $JobPct
         sleep -Seconds 5
         Write-Host "- Progress% : $JobPct ..."
       } 
       $JobStatus = $(reportrunningjobs | where { $_.JobName -eq $JobID }).status
       } 
   } 

   sleep -Seconds 45

   $rc = $(reportworkflows -s | where-object { $_.ID -eq  $workflow_id })
   if ($rc.status -ne 'SUCCESS') { write-output "Refresh job has failed - $rc.steps" ; exit 1}

   $start = $(udsinfo lsjobhistory $JobID).startdate
   $duration = $(udsinfo lsjobhistory $JobID).duration
   $vsize = $(udsinfo lsjobhistory $JobID)."Application size (GB)"
   $tgthost = $(udsinfo lsjobhistory $JobID).targethost

   $usedGB = $(reportmountedimages | where { $_.SourceAppID -eq $appid -And $_.MountedAppName -eq $vdb } )."ConsumedSize(GB)"

   write-output "Refresh job using workflow $workflow_name has completed !!"

   write-output "Job started at $start , and took $duration to complete."
   write-output "The size of $vdb on $tgthost is $vsize GB, actual storage consumed in GB is $usedGB "

   Disconnect-Act | Out-Null
 } 

rm "$TmpPasswdFile" -ErrorAction SilentlyContinue 
