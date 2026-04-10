#!/bin/bash

unison -auto -batch /home/fbr/sync ssh://server/sync
/home/fbr/scripts/log.sh "Unison Sync"
