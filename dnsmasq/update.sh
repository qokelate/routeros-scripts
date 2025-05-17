#!/bin/bash

set -ex

cd "$(dirname "$0")"

curl -LORk 'https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/refs/heads/master/accelerated-domains.china.conf'

sed -e 's|114.114.114.114|223.5.5.5|g' accelerated-domains.china.conf >new.tmp

mv -fv new.tmp custom/accelerated-domains.china.conf

rm -f accelerated-domains.china.conf

exit
