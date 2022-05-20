#!/bin/sh
time=$(TZ=UTC-8 date +'%Y-%m-%d %H:%M') 
date=$(TZ=UTC-8 date +'%Y-%m-%d %H:%M:%S')（北京时间）
sed -i "s/! Version:.*/! Version: $time /g" rules-admin.txt url-filter.txt
sed -i "s/! Last Update:.*/! Last Update: $date /g" rules-admin.txt url-filter.txt

easylist=(
  "https://raw.githubusercontent.com/hoshsadiq/adblock-nocoin-list/master/nocoin.txt"
  "https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/hosts/spy.txt"
  #"https://raw.githubusercontent.com/banbendalao/ADgk/master/ADgk.txt"
  "https://easylist.to/easylist/easylistchina.txt"
  "https://filters.adtidy.org/windows/filters/224.txt"
  "https://raw.githubusercontent.com/damengzhu/banad/main/jiekouAD.txt"
  "https://github.com/Cats-Team/AdRules/raw/main/mod/rules/dns-rules.txt"
  "https://raw.githubusercontent.com/Cats-Team/AdRules/main/mod/rules/dns-rules.txt"
  "https://raw.githubusercontent.com/Cats-Team/AdRules/main/mod/rules/thrid-part-rules.txt"
  "https://raw.githubusercontent.com/Cats-Team/AdRules/main/mod/rules/adblock-rules.txt"
  "https://raw.githubusercontent.com/xinggsf/Adblock-Plus-Rule/master/mv.txt"
  "https://raw.githubusercontent.com/xinggsf/Adblock-Plus-Rule/master/rule.txt"
  "https://easylist-downloads.adblockplus.org/abp-filters-anti-cv.txt"
  "https://raw.githubusercontent.com/reek/anti-adblock-killer/master/anti-adblock-killer-filters.txt"
  "https://raw.githubusercontent.com/cjx82630/cjxlist/master/cjx-annoyance.txt"
  "https://raw.githubusercontent.com/cjx82630/cjxlist/master/cjxlist.txt"
  "https://easylist-downloads.adblockplus.org/antiadblockfilters.txt"
  "https://raw.githubusercontent.com/jdlingyu/ad-wars/master/hosts"
)
hosts=(
  "https://raw.githubusercontent.com/jdlingyu/ad-wars/master/hosts"
  "https://raw.githubusercontent.com/DandelionSprout/adfilt/master/Alternate%20versions%20Anti-Malware%20List/AntiMalwareHosts.txt"
  "https://raw.githubusercontent.com/hacamer/Adblist/master/filter/hosts/fanboy-annoyance.txt"
  "https://raw.githubusercontent.com/hacamer/Adblist/master/filter/hosts/AdguardMobileAds.txt"
)
for i in "${!easylist[@]}" "${!hosts[@]}"
do
  echo "开始下载 easylist${i}..."
  curl -k -o "./easylist${i}.txt" --connect-timeout 60 -s "${easylist[$i]}" &
  curl -k -o "./hosts${i}.txt" --connect-timeout 60 -s "${hosts[$i]}" &
  # shellcheck disable=SC2181
  if [ $? -ne 0 ];then
    echo '下载失败，请重试'
    exit 1
  fi
done
wait

cat hosts*.txt | grep -Ev '#|\$|@|!|/|\\|\*'\
 | grep -v -E "^((#.*)|(\s*))$" \
 | grep -v -E "^[0-9f\.:]+\s+(ip6\-)|(localhost|loopback)$" \
 | sed 's/127.0.0.1 //' | sed 's/0.0.0.0 //' \
 | sed "s/^/||&/g" |sed "s/$/&^/g"| sed '/^$/d' \
 | grep -v '^#' \
 | sort -n | uniq | awk '!a[$0]++' \
 | grep -E "^((\|\|)\S+\^)" > abp-hosts.txt

cat rules-admin.txt | grep -E "^[(\@\@)|(\|\|)][^\/\^]+\^" | grep -Fv "$" |sort | uniq > dns.txt
counting=`cat easy* dns.txt abp-hosts.txt| grep -E "^[(\@\@)|(\|\|)][^\/\^]+\^$" |sort | uniq |wc -l`
tittle="! Title: Quickly List \n! Version: $time \n! Last Update: $date \n! Total count: $counting"
echo -e "$tittle" > dns-list.txt
cat easy* dns.txt abp-hosts.txt| grep -E "^[(\@\@)|(\|\|)][^\/\^]+\^$" |sort | uniq >> dns-list.txt
rm -f easy* hosts*
exit
