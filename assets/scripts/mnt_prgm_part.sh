#!/bin/sh

# the S11init and S30ambrwfs scripts gave us these commands
mkdir -p /dev/shm
mkdir -p /dev/pts
mount -a

/sbin/mdev -s

MtdNum=$(cat /proc/mtd | grep "program" | awk '{print $1}' | sed -e s/mtd// | sed -e s/\://)
UbiNum=0
BabReserved=16

ubiattach /dev/ubi_ctrl -m $MtdNum -d $UbiNum -b $BabReserved

mkdir /program
mount -t ubifs ubi0:program -o sync /program
