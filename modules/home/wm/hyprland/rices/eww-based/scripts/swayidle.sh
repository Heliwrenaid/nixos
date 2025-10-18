#!/usr/bin/env bash

lock_cmd=$1
lock_timeout=$2
screen_off_interval=$3
screen_off_timeout=$((lock_timeout + screen_off_interval))

swayidle -w timeout $lock_timeout \ 
    "$lock_cmd" \
    timeout $screen_off_timeout 'hyprctl dispatch dpms off' \
    resume 'hyprctl dispatch dpms on' \ 
    before-sleep "$lock_cmd"