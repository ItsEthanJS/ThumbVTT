# ThumbVTT
A simple thumbnail spritesheet and VTT file genereator for video thumbnail scrubbing.

## Welcome to ThumbVTT
This is a simple shell script I made for a video project that I was working on. The script allows for quick generation of thumbnail spritesheets, which are often required for modern video players with thumbnail scrubbing/previews (such as when using [VideoJS](https://videojs.org/)).

# Requirements
You will need to install `ffmpeg` prior to using this tool.  You can find installation info here: https://ffmpeg.org/.

This script was written on Ubuntu, so I cannot confirm whether or not it will work as intended on other Operating Systems. 

# Use
To use this tool, download the script and navigate to the directory containing the script. Then, run the following command: 
> bash ThumbVTT.sh

Next, fill in the prompts. Example:

> Enter the path to your Video file.

> ./Videos/vid.mp4


> Enter the path to your Output Folder.

> ./Videos/Thumbanils


> How many Seconds in Between each frame?

> 60


> Select a Tile Size for your sprite sheets (recommended: 5).

> 5

Then sit back and watch the magic happen. If you have any issues, feel free to post them on the issues of this repo. 

# NOTE
I am not all that experienced with writing shell scripts, so this script could probably be cleaned up. That said, it works how I needed it to, and I hope it's helpful for you as well. 
