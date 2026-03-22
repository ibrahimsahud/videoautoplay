#!/bin/bash
# Digital Signage Video Player Script
# Plays all videos in a directory in fullscreen with infinite loop

# Wait for display to be fully ready
sleep 3

# Set display (in case it's not set)
export DISPLAY=:0

# Path to the videos directory
# Put all your videos in this folder
VIDEOS_DIR="/home/oktant/Videos/Screencasts"

# Prevent errors if directory is empty
shopt -s nullglob

# Launch mpv with:
# --fullscreen: Full screen mode
# --loop-playlist=inf: Loop the entire playlist infinitely
# --no-osc: Hide on-screen controller
# --no-osd-bar: Hide OSD bar
# --really-quiet: Minimal console output
# --hwdec=auto: Hardware decoding (important for Pi)
# ESC key will still work to exit
# All video files in the directory will be played sequentially and loop
mpv --fullscreen \
    --loop-playlist=inf \
    --no-osc \
    --no-osd-bar \
    --really-quiet \
    --hwdec=auto \
    "$VIDEOS_DIR"/*
