
/ip firewall address-list add address=127.0.0.0/8 list=IANA
/ip firewall address-list add address=169.254.0.0/16 list=IANA disabled=yes

/ip firewall address-list add address=10.0.0.0/8 list=IANA
/ip firewall address-list add address=172.16.0.0/12 list=IANA
/ip firewall address-list add address=192.168.0.0/16 list=IANA

/ip firewall address-list add address=100.64.0.0/10 list=IANA disabled=yes

/ip firewall address-list add address=224.0.0.0/3 list=IANA disabled=yes
/ip firewall address-list add address=240.0.0.0/4 list=IANA disabled=yes
