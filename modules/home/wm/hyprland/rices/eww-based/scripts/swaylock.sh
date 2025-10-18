#!/usr/bin/env bash

wallpaper="$1"

swaylock \
    -f \
    -e \
    -i $wallpaper \
    --indicator-radius 60 \
    --indicator-thickness 7 
