#! /bin/bash
ETH0=`ip addr  | awk  -F '2:' '{print $2}' |awk  -F ':' '{print $1}'  | awk NF|awk '{sub("^ *","");sub(" *$","");print}'  |sed -n 1p`
ATTR=`ip addr |grep -C 1 "$ETH0": |sed -n 3p |awk -F ' ' '{print $2}'`
echo $ETH0
echo $ATTR
