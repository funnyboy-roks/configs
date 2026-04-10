#!/bin/sh
# Write a message to my custom "system log" (~/log)
# Usage: log.sh <message>

time="$(date -uI'seconds' | cut -d'+' -f1)"
echo "[$time] $*" >> /home/fbr/log
