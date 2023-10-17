
/interface wireguard add listen-port=13231 mtu=1280 name=warp private-key="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
/ip address add address=172.16.0.2 interface=warp network=172.16.0.2
/interface wireguard peers add allowed-address=0.0.0.0/0 endpoint-address=162.159.195.84 endpoint-port=4500 interface=warp public-key="bmXOC+F1FxEMF9dyiK2H5/1SUtzH0JuVo51h2wPfgyo="


/routing table add disabled=no fib name=warp
/routing rule add action=lookup-only-in-table disabled=no routing-mark=warp table=warp
/ip route add disabled=no dst-address=0.0.0.0/0 gateway=warp routing-table=warp

/ip firewall mangle add action=jump chain=prerouting jump-target=from-lan src-address-list=IANA
/ip firewall mangle add action=mark-connection chain=from-lan connection-mark=no-mark dst-address-list=IANA new-connection-mark=lan-conn passthrough=yes
/ip firewall mangle add action=mark-connection chain=from-lan connection-mark=no-mark dst-address-list=cloudflare new-connection-mark=cloudflare-conn passthrough=yes
/ip firewall mangle add action=mark-connection chain=from-lan connection-mark=no-mark dst-address-list=google new-connection-mark=google-conn passthrough=yes disabled=yes
/ip firewall mangle add action=mark-connection chain=from-lan connection-mark=no-mark dst-address-list=china new-connection-mark=china-conn passthrough=yes
/ip firewall mangle add action=mark-connection chain=from-lan connection-mark=no-mark new-connection-mark=other-conn passthrough=yes
/ip firewall mangle add action=mark-routing chain=from-lan connection-mark=other-conn disabled=yes new-routing-mark=warp passthrough=no

