# Music scripts

My music scripts to handle my big local library.

## `music-library-export.sh`

Audio library syncing and conversion utility.

The intended use is syncing an audio library with many lossless files to a mobile device with limited storage.

Just move in you music library folder and run the script to copy you audio file eleswhere.

- the loseless files will be converted to your desired format
- the lossy files will be copied as is

## `music-generate-m3u-from-genre.sh`

I used to manage my playlist with a really simple system: I add `#tag` inside the genre inside the music metadata.

This script will simply loop on every MP3 and FLAC files inside the current folder and generate `tag.m3u` curresponding playlist.
