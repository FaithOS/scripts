#! /bin/bash
ZD=`awk  '{print $3}' test/new_new.txt`
array=($ZD)
length=${#array[@]}
for ((i=0; i<$length; i++))
do
	    echo ${array[$i]}
    done


