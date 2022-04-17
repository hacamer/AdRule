#!/bin/sh
time=$(TZ=UTC-8 date +'%Y-%m-%d %H:%M') 
date=$(TZ=UTC-8 date +'%Y-%m-%d %H:%M:%S')（北京时间）
sed -i "s/! Version:.*/! Version: $time /g" rules-admin.txt url-filter.txt
sed -i "s/! Last Update:.*/! Last Update: $date /g" rules-admin.txt url-filter.txt
exit
