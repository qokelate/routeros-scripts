
/container envs add key=TZ name=TZ value=Asia/Shanghai
/container mounts add dst=/data1 name=udisk src=/usb1-part1/data1
/container config set registry-url=https://registry.hub.docker.com tmpdir=usb1-part1/container
