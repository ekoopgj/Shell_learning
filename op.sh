#!/bin/bash
i=1
while [ 0 ];do
read -p "Enter your MO or attribute name: " name
if [ $name = "q" ];then
i=0
continue
else
grep -q $name *.txt
if [ $? -eq 0 ];then
    echo "Send to file 2"
    echo $name >> 2.txt
else
    echo "Send to file 1"
    echo $name >> 1.txt
fi
fi
done