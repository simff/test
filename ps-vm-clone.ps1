Get-Module -ListAvailable PowerCLI* | Import-Module
Set-PowerCLIConfiguration -InvalidCertificateAction ignore -confirm:$false

$esxi = "192.168.1.100"
$sourceVM = "Ubuntu-20.04"
$newVM = "nginx-test"

Connect-VIServer -Server $esxi -User admin -Password Passw0rd#

$datastore = Get-Datastore
New-PSDrive -Location $datastore -Name ds -PSProvider VimDatastore -Root "\"

$st=Get-VM $sourceVM | Where-Object{$_.PowerState -eq "PoweredOn"}
if ( $null -ne $st ) { Stop-VM $sourceVM -Confirm:$false; sleep 30}

#New-VM -Name $newVM -VM $sourceVM -VMHost $esxi

New-VM -Name $newVM -VMHost $esxi -ResourcePool $esxi -DiskGB 15 -MemoryGB 2 -NumCpu 2 -GuestId ubuntu64Guest
Copy-DatastoreItem -Item ds:\ubuntu-20.04\ubuntu-20.04-flat.vmdk -Destination ds:\nginx-test\nginx-test-flat.vmdk
Start-VM $newVM
sleep 60

Invoke-VMScript -VM $newVM –ScriptText “ifconfig ens33 192.168.1.155 netmask 255.255.255.0 broadcast 192.168.1.255” –ScriptType Bash –guestuser root –GuestPassword Passw0rd#
Invoke-VMScript -VM $newVM –ScriptText “hostnamectl set-hostname nginx155” –ScriptType Bash –guestuser root –GuestPassword Passw0rd#
Invoke-VMScript -VM $newVM –ScriptText “apt -y install nginx” –ScriptType Bash –guestuser root –GuestPassword Passw0rd#

DisConnect-VIServer -Server $esxi -Confirm:$false
