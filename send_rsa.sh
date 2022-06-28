#!/bin/bash
port="$1"
host="$2"
if [ -z "$host" ]
then
        echo "host is empty.Usage: ./send_rsa.sh [port] usename@10.XXX.XX.XX"
else
        ssh-copy-id -i ~/.ssh/id_rsa.pub -p $port $host
fi