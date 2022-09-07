#!/bin/bash
echo "starting up "
/usr/sbin/sshd
trap : TERM INT
sleep 2147483647 & wait