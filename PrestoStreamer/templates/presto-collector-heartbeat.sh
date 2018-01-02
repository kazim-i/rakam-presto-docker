#!/bin/sh

while true
do 
if ! pgrep rakam-collector; then
    /var/app/presto-streamer/bin/launcher start
fi
 sleep 5
done