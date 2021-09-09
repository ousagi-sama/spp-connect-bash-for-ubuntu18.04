#!/bin/bash
#
#使い方:#
#    spp-connect <[id] [address] [baudrate]>#

if [ $# -eq 3 ];then
    id=$1; address=$2; baudrate=$3
    echo "$id $address $baudrate" > .spp-connect-config
elif [ $# -eq 0 ];then
    if [ ! -e ".spp-connect-config" ];then 
        echo ".spp-connect-config is not found."
        exit 1
    fi
    set $(cat .spp-connect-config)
    id=${1}; address=${2}; baudrate=${3}
else
    text=$(cat $0 | grep "^#.*#$")
    echo -e "\033[33m${text//#}\033[32m"
    exit 1
fi

# 仮想ポートの作成
sudo rfcomm bind $id $address
sudo chmod 777 /dev/rfcomm$id
sudo stty -F /dev/rfcomm$id $baudrate cs8

read -p "Press [Enter] key to resume."

# 仮想ポートでの解除
sudo rfcomm release $id