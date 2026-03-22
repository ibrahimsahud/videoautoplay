# Video Autoplay Digital Signage

A simple and robust digital signage solution for Linux (Ubuntu 24.04+). This project automatically plays all videos from a specified directory in fullscreen mode on system startup, looping them seamlessly. It is designed for kiosks, displays, and public screens where reliable, unattended video playback is required.

## Features
- **Autoplay on Login:** Videos start automatically after user login.
- **Fullscreen Playback:** Uses `mpv` for smooth, hardware-accelerated video.
- **Looping Playlist:** All videos in the folder play sequentially and repeat infinitely.
- **Easy Control:** Exit playback anytime with the ESC key.
- **Systemd Integration:** Managed as a user service for reliability and easy control.
- **No Root Required:** Runs as a regular user for safety.

## Quick Start
1. **Install mpv:**
   ```bash
   sudo apt update
   sudo apt install -y mpv
   ```
2. **Copy your videos** to `~/Videos/Screencasts/` (or your chosen folder).
3. **Install the script and service:**
   - Copy `autoplay-video.sh` to your home directory and make it executable.
   - Copy `autoplay.service` to `~/.config/systemd/user/`.
4. **Enable and start the service:**
   ```bash
   systemctl --user daemon-reload
   systemctl --user enable autoplay.service
   systemctl --user start autoplay.service
   ```

## How It Works
- Waits for the graphical session to be ready.
- Plays all videos in the target directory using `mpv` with optimal settings.
- Service does not restart automatically if exited (prevents unwanted loops).
- All logs are available via the systemd journal for troubleshooting.

## Use Cases
- Digital signage
- Information kiosks
- Waiting room displays
- Conference and event screens

## Customization
- Change the video directory or player options by editing `autoplay-video.sh`.
- Service behavior can be adjusted in `autoplay.service`.

## License
This project is open source and free to use for any purpose.

---

For detailed setup and troubleshooting, see the included `SETUP_GUIDE.md`.
