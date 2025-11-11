#!/bin/bash

~/scripts/log.sh 'starting backup'
notify-send 'Starting Backup'
INFO=$(/usr/bin/time -f '%E' \
            rsync -vaPtu                                                                                \
                ~/{documents,sync,stuff,.ssh,.config,personal-config,videos,pictures,log,dev,downloads} \
                /mount/nas/bu/home/$(date --rfc-3339=date)                                              \
                --exclude=node_modules                                                                  \
                --exclude=.next                                                                         \
                --exclude=dist/                                                                         \
                --exclude=.svelte-kit                                                                   \
                --exclude=.vercel                                                                       \
                --exclude target/                                                                       \
            2>&1 | tail -n3)

readarray -t foo <<<"$INFO"
stats=${foo[0]}
time=${foo[2]}

notify-send "Backup Finished" "Time: $time\n$stats"
~/scripts/log.sh "finished backup ($time): $stats"

