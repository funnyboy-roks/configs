#!/bin/bash

unison -auto -batch ~/sync ssh://server/sync
~/scripts/log.sh "Unison Sync"
