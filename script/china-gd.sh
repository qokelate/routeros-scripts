#!/bin/zsh

# http://ips.chacuo.net/view/s_GD
curl -o china-gd.txt -vkL 'http://ips.chacuo.net/down/t_txt=p_GD' \
-A 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:125.0) Gecko/20100101 Firefox/125.0'

echo >china-gd.rsc

while read line; do
    s=`echo "$line" | awk '{printf $1}'`
    e=`echo "$line" | awk '{printf $2}'`
    [ -z "$s" ] && continue
    [ -z "$e" ] && continue
    echo "/ip/firewall/address-list/add list=china-gd address=$s-$e" >>china-gd.rsc
done < china-gd.txt

echo "# updated $(date)" >>china-gd.rsc

exit

