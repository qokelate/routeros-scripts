#!/bin/zsh

# https://ispip.clang.cn/

cat <<EOF > list.txt
https://ispip.clang.cn/all_cn.txt
https://ispip.clang.cn/all_cn_cidr.txt
https://ispip.clang.cn/all_cn_ipv6.txt
https://ispip.clang.cn/cernet.txt
https://ispip.clang.cn/cernet_cidr.txt
https://ispip.clang.cn/cernet_ipv6.txt
https://ispip.clang.cn/chinatelecom.txt
https://ispip.clang.cn/chinatelecom_cidr.txt
https://ispip.clang.cn/chinatelecom_ipv6.txt
https://ispip.clang.cn/cmcc.txt
https://ispip.clang.cn/cmcc_cidr.txt
https://ispip.clang.cn/cmcc_ipv6.txt
https://ispip.clang.cn/crtc.txt
https://ispip.clang.cn/crtc_cidr.txt
https://ispip.clang.cn/crtc_ipv6.txt
https://ispip.clang.cn/gwbn.txt
https://ispip.clang.cn/gwbn_cidr.txt
https://ispip.clang.cn/gwbn_ipv6.txt
https://ispip.clang.cn/hk.txt
https://ispip.clang.cn/hk_cidr.txt
https://ispip.clang.cn/hk_ipv6.txt
https://ispip.clang.cn/mo.txt
https://ispip.clang.cn/mo_cidr.txt
https://ispip.clang.cn/mo_ipv6.txt
https://ispip.clang.cn/othernet.txt
https://ispip.clang.cn/othernet_cidr.txt
https://ispip.clang.cn/othernet_ipv6.txt
https://ispip.clang.cn/tw.txt
https://ispip.clang.cn/tw_cidr.txt
https://ispip.clang.cn/tw_ipv6.txt
https://ispip.clang.cn/unicom_cnc.txt
https://ispip.clang.cn/unicom_cnc_cidr.txt
https://ispip.clang.cn/unicom_cnc_ipv6.txt
EOF

make_rsc(){
    echo "[INFO] file $1"
    n1=`basename "$1" .txt`
    echo >"$n1.rsc"
    while read line; do
        echo "/ip/firewall/address-list/add list=$n1 address=$line" >>$n1.rsc
    done < "$1"
}

while read line; do
    curl -LORk "$line"
    n1=`basename "$line"`
    make_rsc "$n1"
done < list.txt


exit

