#!/bin/bash
#DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

sed -i 's/^set[[:space:]]\|^set1[[:space:]]\|^[[:blank:]]*//g' para.mos #去除以set和set1为首到第二列字符串前的所有空字符

sed -e 's/\(\^\|\=[0-9]\$\|\$\|\=\.\*\|\-[[0-9]*]\|\)//g' -e 's/^\s*//;s/\r$//g'  para.mos | awk '{sub(/.*,/,"",$1);print}' | awk '{sub(/=[^C].*/,"",$1);print}' > up_para.mos


#s/.*,//g;
#awk '{sub(/.*,/,"",$1);print}' 
#s/=[^C].*//;
#awk '{sub([^C].*,"",$1);print}'

sed 's/\r//g' up_para.mos | awk '{ printf("%s %s%s%s\n",$1,$2,($NF!~/[[:digit:]]|false|true|FALSE|TRUE/? ".":" "),$3) }' > up_para.mos

#根据MO和pameter匹配MO_ID，将逐行匹配的MO_ID存入 up_mid.txt
awk 'NR==FNR{a[$1,$2]=$3;next}{print $1,$2,$3,a[$1,$2]}' MO_ID.txt up_para.mos | awk '{printf("%s\n",($NF~/E2[0-9]*$/? $NF : NULL))}' > up_mid.txt

#将MO_ID粘贴在匹配行后一列，将所有空字符替换为";"
sed 's/ /;/;s/ /;/;s/\r//g;s/$/;/;s/\n//g' para.mos > tem.mos

#删除掉paste后出现在尾行的\t
paste tem.mos up_mid.txt | sed 's/\t//g' 
