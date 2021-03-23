#!/bin/bash

if [ -r /proc/version ]; then
    [[ $(grep -oE 'gcc version ([0-9]+)' /proc/version | awk '{print $3}') > 5 ]] && echo "2" || echo "1"
fi
