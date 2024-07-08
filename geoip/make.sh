#!/bin/zsh

set -x

cd "$(dirname "$0")"
cd "$(realpath "$PWD")"

mkdir -pv cache
mkdir -pv output

clean_invalid(){
    find "output" -type f | while read line; do
        grep -osq html "$line" || continue
        rm -fv "$line"
    done

    find "output" -type f | while read line; do
        grep -osq back "$line" || continue
        rm -fv "$line"
    done
}
clean_invalid

while read tmp1; do
    echo "$tmp1"|grep -sqo '://' || continue

    suffix=`echo "$tmp1"|grep -oE '/view/.+$'`
    suffix="${suffix:6}"
    [ -z "$suffix" ] && continue

    [ -f "output/$suffix.txt" ] && continue

    # http://ips.chacuo.net/view/s_GD
    curl --connect-timeout 5 -4 -o "cache/$suffix.txt" -vkL "$tmp1" \
    -A 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:125.0) Gecko/20100101 Firefox/125.0' || continue
    sleep 1

    q='"'"'"
    txturl=`grep -oE "[^$q]+/down/t_txt[^$q]+" "cache/$suffix.txt"`
    [ -z "$txturl" ] && continue

    curl --connect-timeout 5 -4 -o "output/$suffix.txt" -vkL "$txturl" \
    -A 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:125.0) Gecko/20100101 Firefox/125.0' || continue
    grep -osq back "output/$suffix.txt" && continue
    sleep 1

    echo >"output/$suffix.rsc"
    while read tmp2; do
        s=`echo "$tmp2" | awk '{printf $1}'`
        e=`echo "$tmp2" | awk '{printf $2}'`
        [ -z "$s" ] && continue
        [ -z "$e" ] && continue
        echo "/ip/firewall/address-list/add list=$geo address=$s-$e" >>"output/$suffix.rsc"
    done < "output/$suffix.txt"
    echo "# updated $(date '+%Y-%m-%d %H:%M:%S %Z')" >>"output/$suffix.rsc"
done < list.txt

clean_invalid

exit
