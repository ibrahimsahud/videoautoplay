# Digital Signage Setup Guide - Ubuntu 24.04

## Overview
This solution creates a production-safe digital signage player that:
- Auto-plays all videos from a directory on boot in fullscreen
- Plays videos sequentially and loops infinitely
- Can be exited with ESC to access the desktop
- Is fully controllable via systemd

## Installation Steps

### 1. Install mpv (if not already installed)
```bash
sudo apt update
sudo apt install -y mpv
```

### 2. Prepare your videos directory
```bash
# The script is configured to use:
# /home/oktant/Videos/Screencasts

# Make sure it exists (usually already exists)
mkdir -p /home/oktant/Videos/Screencasts

# Copy all your video files to this directory
# Example:
cp /path/to/video1.mp4 /home/oktant/Videos/Screencasts/
cp /path/to/video2.webm /home/oktant/Videos/Screencasts/
```

### 3. Copy the player script
```bash
sudo cp autoplay-video.sh /home/oktant/autoplay-video.sh
sudo chown oktant:oktant /home/oktant/autoplay-video.sh
sudo chmod +x /home/oktant/autoplay-video.sh
```

### 4. Install the systemd user service
```bash
# Create user systemd directory
mkdir -p ~/.config/systemd/user

# Copy the service file
cp autoplay.service ~/.config/systemd/user/autoplay.service
```

### 5. Enable and start the user service
```bash
# Reload user systemd to recognize the new service
systemctl --user daemon-reload

# Enable the service to start on login
systemctl --user enable autoplay.service

# Start the service now (or logout/login to test)
systemctl --user start autoplay.service
```

## Management Commands

### Check service status
```bash
systemctl --user status autoplay.service
```

### View service logs
```bash
journalctl --user -u autoplay.service -f
```

### Stop the video (temporarily)
```bash
systemctl --user stop autoplay.service
```
This stops the video but keeps autoplay enabled for next login.

### Disable autoplay permanently
```bash
systemctl --user disable autoplay.service
```
This prevents the video from starting on future logins.

### Re-enable autoplay
```bash
systemctl --user enable autoplay.service
```

### Restart the service
```bash
systemctl --user restart autoplay.service
```

## User Controls

### Exit the video
- Press **ESC** while the video is playing
- This will close mpv and return you to the desktop
- The systemd service will NOT restart it (Restart=no)
- To start it again, run: `systemctl --user start autoplay.service`

## How It Works

### The Script (autoplay-video.sh)
- Waits 3 seconds for display initialization
- Sets DISPLAY=:0 environment variable
- Uses `shopt -s nullglob` to prevent errors if directory is empty
- Plays all videos in `/home/oktant/Videos/Screencasts/` directory
- Launches mpv with optimal settings:
  - `--fullscreen`: Full screen playback
  - `--loop-playlist=inf`: Loop all videos infinitely
  - `--no-osc`: No on-screen controls
  - `--hwdec=auto`: Hardware acceleration for smooth playback
  - ESC key is still functional for exiting

### The Service (autoplay.service)
- Runs as user service (in ~/.config/systemd/user/)
- Automatically inherits user environment (DISPLAY, XAUTHORITY)
- Waits for `graphical-session.target` (user session ready)
- Starts 5 seconds after login for display stability
- Does NOT restart on exit (Restart=no) - prevents loops
- Logs to user systemd journal for debugging

## Testing

### Test the script manually
```bash
/home/oktant/autoplay-video.sh
```
Press ESC to exit.

### Test with systemd
```bash
systemctl --user start autoplay.service
```
Press ESC to exit.

### Test autostart on login
```bash
# Logout and login again
# Or reboot:
sudo reboot
```
After login, video should play automatically (after 5 seconds).

## Troubleshooting

### Video doesn't start on login
```bash
# Check service status
systemctl --user status autoplay.service

# Check logs
journalctl --user -u autoplay.service -n 50
```

### Common issues:
1. **Video file not found**: Ensure videos exist in `/home/oktant/Videos/Screencasts/`
2. **Display not available**: Check DISPLAY=:0 is correct for your setup
3. **Permission denied**: Ensure script is executable and owned by oktant user
4. **mpv not installed**: Run `sudo apt install mpv`

### Check X display number
```bash
echo $DISPLAY
```
If it's not `:0`, update the DISPLAY variable in the service file.

### Verify X authority
```bash
ls -la /home/oktant/.Xauthority
```
Should be owned by oktant:oktant.

## Production Notes

### Video Format Recommendations
- Format: MP4 (H.264)
- Resolution: Match your display (e.g., 1920x1080)
- Bitrate: 5-10 Mbps for good quality
- Audio: AAC

### Performance Tips
- Use hardware-accelerated video encoding
- Keep video bitrate reasonable for smooth playback
- Raspberry Pi 4 can handle 1080p60 with H.264

### Security Considerations
- Service runs as user "oktant" (not root)
- NoNewPrivileges=true prevents privilege escalation
- PrivateTmp=true isolates temporary files
- Restart=no prevents auto-restart loops

### Adding or Updating Videos
```bash
# Stop the service
systemctl --user stop autoplay.service

# Add new videos to the directory
cp /path/to/new/video1.mp4 /home/oktant/Videos/Screencasts/
cp /path/to/new/video2.webm /home/oktant/Videos/Screencasts/

# Remove old videos if needed
rm /home/oktant/Videos/Screencasts/old_video.mp4

# Start the service again
systemctl --user start autoplay.service
```

## Complete Removal

### To completely remove the autoplay system:
```bash
# Stop and disable the service
systemctl --user stop autoplay.service
systemctl --user disable autoplay.service

# Remove the service file
rm ~/.config/systemd/user/autoplay.service

# Remove the script
rm /home/oktant/autoplay-video.sh

# Reload systemd
systemctl --user daemon-reload
```

## Alternative: Using VLC Instead

If you prefer VLC over mpv, replace the ExecStart line in autoplay-video.sh:

```bash
vlc --fullscreen \
    --loop \
    --no-video-title-show \
    --no-osd \
    --no-qt-privacy-ask \
    "$VIDEO_PATH" \
    vlc://quit
```

Note: mpv is recommended for Raspberry Pi due to better performance and lower resource usage.
