#!/bin/bash

~/scripts/log.sh 'starting ~/sync backup'
notify-send 'Starting Sync Backup'
INFO=$(/usr/bin/time -f '%E' \
            rsync -vaPtu                                    \
                ~/sync/                                     \
                /mount/nas/bu/sync/$(date --rfc-3339=date)  \
                --exclude=node_modules                      \
                --exclude=.next                             \
                --exclude=dist/                             \
                --exclude=.svelte-kit                       \
                --exclude=.vercel                           \
                --exclude target/                           \
            2>&1 | tail -n3)

readarray -t foo <<<"$INFO"
stats=${foo[0]}
time=${foo[2]}

notify-send "Sync Backup Finished" "Time: $time\n$stats"
~/scripts/log.sh "finished ~/sync backup ($time): $stats"

