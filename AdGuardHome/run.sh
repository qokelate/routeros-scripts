#!/bin/sh

if [ ! -f "/AdGuardHome/AdGuardHome" ]; then
  apk update
  apk add rsync
fi

rsync -a "/data1/AdGuardHome" /
chmod 777 /AdGuardHome/AdGuardHome

cd /data1/AdGuardHome
"/AdGuardHome/AdGuardHome"

exit

# https://github.com/AdguardTeam/AdGuardHome/releases

/container envs add key=TZ name=TZ value=Asia/Shanghai
/container mounts add dst=/data1 name=udisk src=/usb1-part1

/interface veth add address=192.168.0.203/24 gateway=192.168.0.1 gateway6="" name=veth3
/interface bridge port add bridge=LAN interface=veth3

/container/add mounts=udisk remote-image=alpine:latest \
dns=223.5.5.5 envlist=TZ hostname=AdGuardHome.local \
entrypoint="/bin/sh" cmd="-c 'cp -fv /data1/AdGuardHome/run.sh /;chmod 777 /run.sh;/run.sh'" \
interface=veth3 root-dir=usb1-part1/container/AdGuardHome logging=yes

