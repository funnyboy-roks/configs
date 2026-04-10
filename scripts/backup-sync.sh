#!/bin/bash

/home/fbr/scripts/log.sh 'starting /home/fbr/sync backup'
notify-send 'Starting Sync Backup'
INFO=$(/usr/bin/time -f '%E' \
            rsync -vaPtu                                 \
                /home/fbr/sync/                          \
                /mnt/nas/bu/sync/$(date --rfc-3339=date) \
                --exclude=node_modules                   \
                --exclude=.next                          \
                --exclude=dist/                          \
                --exclude=.svelte-kit                    \
                --exclude=.vercel                        \
                --exclude target/                        \
            2>&1 | tail -n3)

readarray -t foo <<<"$INFO"
stats=${foo[0]}
time=${foo[2]}

notify-send "Sync Backup Finished" "Time: $time\n$stats"
/home/fbr/scripts/log.sh "finished /home/fbr/sync backup ($time): $stats"

