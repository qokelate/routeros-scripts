
/interface wireguard add listen-port=13231 mtu=1280 name=warp private-key="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
/ip address add address=172.16.0.2 interface=warp network=172.16.0.2
/interface wireguard peers add allowed-address=0.0.0.0/0 endpoint-address=162.159.195.84 endpoint-port=4500 interface=warp public-key="bmXOC+F1FxEMF9dyiK2H5/1SUtzH0JuVo51h2wPfgyo="


/routing table add disabled=no fib name=warp
/routing rule add action=lookup-only-in-table disabled=no routing-mark=warp table=warp
/ip route add disabled=no dst-address=0.0.0.0/0 gateway=warp routing-table=warp

/ip firewall mangle add action=jump chain=prerouting jump-target=from-lan src-address-list=IANA disabled=yes
/ip firewall mangle add action=mark-connection chain=from-lan connection-mark=no-mark dst-address-list=IANA new-connection-mark=lan-conn passthrough=yes disabled=yes
/ip firewall mangle add action=mark-connection chain=from-lan connection-mark=no-mark dst-address-list=cloudflare new-connection-mark=cloudflare-conn passthrough=yes disabled=yes
/ip firewall mangle add action=mark-connection chain=from-lan connection-mark=no-mark dst-address-list=google new-connection-mark=google-conn passthrough=yes disabled=yes
/ip firewall mangle add action=mark-connection chain=from-lan connection-mark=no-mark dst-address-list=china new-connection-mark=china-conn passthrough=yes disabled=yes
/ip firewall mangle add action=mark-connection chain=from-lan connection-mark=no-mark new-connection-mark=other-conn passthrough=yes disabled=yes
/ip firewall mangle add action=mark-routing chain=from-lan connection-mark=other-conn new-routing-mark=warp passthrough=no disabled=yes



/system script add dont-require-permissions=no name=update-warp owner=admin policy=read,write,policy,test source="/log/info \"[WARP] fetching warp list ....\"\r\
    \n:local body ([/tool fetch output=user url=\"https://raw.githubusercontent.com/qokelate/cloudflare-speedcheck/master/warp-top1.txt\" as-value ]->\"data\")\r\
    \n#/log/info \"\$body\"\r\
    \n\r\
    \n:local server [:pick \"\$body\" 0 [:find \"\$body\" \",\"]]\r\
    \n#/log/info \"\$server\"\r\
    \n\r\
    \n:local host [:pick \"\$server\" 0 [:find \"\$server\" \":\"]]\r\
    \n#/log/info \"\$host\"\r\
    \n\r\
    \n:local port [:pick \"\$server\" ([:len \"\$host\"]+1) [:len \"\$server\"]]\r\
    \n#/log/info \"\$port\"\r\
    \n\r\
    \n/log/info \"[WARP] updated to \$host:\$port\"\r\
    \n/interface/wireguard/peers/set [find interface=warp endpoint-address!=\$host] endpoint-address=\$host endpoint-port=\$port"

/system scheduler add interval=1h name=update-warp on-event="/system/script/run update-warp" policy=read,write,policy,test start-time=00:00:00

