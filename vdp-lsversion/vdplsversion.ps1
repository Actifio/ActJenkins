$LocalTempDir = "c:\temp\"
If(!(test-path $LocalTempDir)) {
    New-Item -ItemType Directory -Force -Path $LocalTempDir | out-null
    }
    
$TmpPasswdFile = "$LocalTempDir\$env:USERNAME-passwd.key"
"$env:ActPass" | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString | Out-File $TmpPasswdFile

Connect-Act $env:ActIP -actuser $env:ActUser -passwordfile $TmpPasswdFile -ignorecerts
udsinfo lsversion
disconnect-act

rm "$TmpPasswdFile" -ErrorAction SilentlyContinue -Verbose
