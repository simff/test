#!/bin/bash
echo -------------------- Start -----------------------------

ssh esxi "mkdir /vmfs/volumes/ds-01/test-nginx"
ssh esxi "vmkfstools -i /vmfs/volumes/ds-01/ubuntu-20.04/ubuntu-20.04.vmdk /vmfs/volumes/ds-01/test-nginx/test-nginx.vmdk"
ssh esxi "sed 's/ubuntu-20.04/test-nginx/g' /vmfs/volumes/ds-01/ubuntu-20.04/ubuntu-20.04.vmx > /vmfs/volumes/ds-01/test-nginx/test-nginx.vmx"
idnewvm=`ssh esxi "vim-cmd solo/registervm /vmfs/volumes/ds-01/test-nginx/test-nginx.vmx"`
echo New VM ID: $idnewvm
ssh esxi "vim-cmd vmsvc/power.on $idnewvm &" &
echo Power ON VM
sleep 10
ssh esxi "vim-cmd vmsvc/message $idnewvm" > message.vm
idmes=`sed -n '1s/Virtual machine message//; s/://p' message.vm`
ssh esxi "vim-cmd vmsvc/message $idnewvm $idmes 2"
echo Answer the question and wait 1 minute
sec=60
                         while [ $sec -ge 0 ]; do
                                 echo -ne "$sec\033[0K\r"
                                 let "sec=sec-1"
                                 sleep 1
                         done
rm message.vm
echo Change IP address
ssh 192.168.1.250 "ip addr add 192.168.1.155/255.255.255.0 dev ens33"
sleep 5
ssh 192.168.1.250 "ip addr del 192.168.1.250/255.255.255.0 dev ens33 &" &
sleep 5
echo Change host name
ssh 192.168.1.155 "hostnamectl set-hostname nginx155"
sleep 5
echo Install Nginx
ssh 192.168.1.155 "apt -y install nginx"

echo ------------------- Finish -----------------------------
