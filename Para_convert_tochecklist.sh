#!/bin/bash

MYTIME=`date +%G%m%d%H%M%S`
FILENAME=Checklist_$MYTIME

sed -i '/\(^s*$\|^\/\/.*$\)/ d' test.txt

sed -i 's/^set[[:space:]]\|^set1[[:space:]]\|^[[:blank:]]*//g' test.txt

cp test.txt tem_para.mos

sed -e 's/\(\^\|\=[0-9]\$\|\$\|\=\.\*\|\-[[0-9]*]\|\)//g' -e 's/^\s*//;s/\r$//g'  tem_para.mos | awk '{sub(/.*,/,"",$1);print}' | awk '{sub(/=[^C].*/,"",$1);print}' > tem_para.mos

gawk -i inplace '$2~/Ref$/{print $1,$2;next}\
{gsub(/=[^,]*/,"",$3);split($3,a,",");\
for(i in a)print $1,$2(a[i]~/[[:digit:]]/&&a[i]!~/[[:alpha:]]/||a[i]~/false|true|FALSE|TRUE/?" ":".")a[i]}' tem_para.mos

sed -i 's/ /;/;s/ /;/;s/\r//g;s/$/;/;s/\n//g' test.txt

gawk -i inplace -F';' '$2~/Ref$/{print $1,$2,$3;next}{split($3,a,",");\
for(i in a)print $1,$2(a[i]~/[[:digit:]]/&&a[i]!~/[[:alpha:]]/||a[i]~/false|true|FALSE|TRUE/?" ":".")a[i]}' test.txt

gawk -i inplace '{gsub(/=/," ",$2);print}' test.txt | sed -i 's/ /;/;s/ /;/;s/\r//g;s/$/;/;s/\n//g' test.txt

awk 'NR==FNR{a[$2,$3]=$4;next}{print $1,$2,$3,a[$1,$2]}' MO_ID.txt tem_para.mos | awk '{printf("%s\n",($NF~/E2[0-9]/? $NF : NULL))}' > tem_mid.txt

paste test.txt tem_mid.txt | sed 's/\t//g' > tem_Checklist.txt

awk 'NR==FNR{a[$2,$3]=$1;next}{print a[$1,$2],$0}' MO_ID.txt tem_para.mos | awk '{printf("%s;\n",($1~/[[:digit:]]/&&$1!~/Feature/? $1 : NULL))}' > tem_FunId.txt

paste tem_FunId.txt tem_Checklist.txt | sed 's/\t//g' > $FILENAME.txt

rm ./tem_*

echo -e "\e[1;31m Checklist file generation completed, Please Check! \e[0m"

