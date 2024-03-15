#!/bin/sh

if [ ! -f "/xray/xray" ]; then
  apk update
  apk add rsync
fi

rsync -a "/data1/xray" /
chmod 777 /xray/xray

cd /data1/xray
"/xray/xray" run -c "/data1/xray/config.json"

exit

# https://github.com/XTLS/Xray-core/releases

/container envs add key=TZ name=TZ value=Asia/Shanghai
/container mounts add dst=/data1 name=udisk src=/usb1-part1

/interface veth add address=192.168.0.201/24 gateway=192.168.0.1 gateway6="" name=veth1
/interface bridge port add bridge=LAN interface=veth1

/container/add mounts=udisk remote-image=alpine:latest \
dns=223.5.5.5 envlist=TZ hostname=xray.local \
entrypoint="/bin/sh" cmd="-c 'cp -fv /data1/xray/run.sh /;chmod 777 /run.sh;/run.sh'" \
interface=veth1 root-dir=usb1-part1/container/xray logging=yes

