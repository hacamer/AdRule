#!/bin/sh
time=$(TZ=UTC-8 date +'%Y-%m-%d %H:%M') 
date=$(TZ=UTC-8 date +'%Y-%m-%d %H:%M:%S')（北京时间）
sed -i "s/! Version:.*/! Version: $time /g" rules-admin.txt url-filter.txt
sed -i "s/! Last Update:.*/! Last Update: $date /g" rules-admin.txt url-filter.txt

easylist=(
  "https://raw.githubusercontent.com/hoshsadiq/adblock-nocoin-list/master/nocoin.txt"
  "https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/hosts/spy.txt"
  #"https://raw.githubusercontent.com/banbendalao/ADgk/master/ADgk.txt"
  #"https://easylist.to/easylist/easyprivacy.txt"
  "https://filters.adtidy.org/windows/filters/224.txt"
  "https://raw.githubusercontent.com/damengzhu/banad/main/jiekouAD.txt"
  "https://github.com/Cats-Team/AdRules/raw/main/mod/rules/dns-rules.txt"
  "https://raw.githubusercontent.com/Cats-Team/AdRules/main/mod/rules/dns-rules.txt"
  "https://raw.githubusercontent.com/Cats-Team/AdRules/main/mod/rules/thrid-part-rules.txt"
  "https://raw.githubusercontent.com/Cats-Team/AdRules/main/mod/rules/adblock-rules.txt"
  "https://raw.githubusercontent.com/xinggsf/Adblock-Plus-Rule/master/mv.txt"
  "https://raw.githubusercontent.com/xinggsf/Adblock-Plus-Rule/master/rule.txt"
)
for i in "${!easylist[@]}"
do
  echo "开始下载 easylist${i}..."
  curl -k -o "./easylist${i}.txt" --connect-timeout 60 -s "${easylist[$i]}" &
  # shellcheck disable=SC2181
  if [ $? -ne 0 ];then
    echo '下载失败，请重试'
    exit 1
  fi
done
wait

cat rules-admin.txt | grep -E "^[(\@\@)|(\|\|)][^\/\^]+\^" | grep -Fv "$" |sort | uniq > dns.txt
counting=`cat easy* dns.txt | grep -E "^[(\@\@)|(\|\|)][^\/\^]+\^$" |sort | uniq |wc -l`
tittle="! Title: Quickly List \n! Version: $time \n! Last Update: $date \n! Total count: $counting"
echo -e "$tittle" > dns-list.txt
cat easy* dns.txt | grep -E "^[(\@\@)|(\|\|)][^\/\^]+\^$" |sort | uniq >> dns-list.txt
rm -f easy*
exit
