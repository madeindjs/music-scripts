#!/bin/bash

# I used to manage my playlist with a really simple system: I add `#tag` inside the genre inside the music metadata.
#
# This script will simply loop on every MP3 and FLAC files inside the current folder and generate `tag.m3u` curresponding playlist.

set -e

function get_music_genres() {
  if [[ -n "$cache" ]]
  then
    echo -n "$cache"
  elif [[ $1 = *.flac ]]
  then
    genre=$(metaflac --show-tag=GENRE "$1" | sed 's/GENRE=//')
    echo -n "$genre"
  elif [[ $1 = *.mp3 ]]
  then
    genre=$(id3v2 -l "$1" | grep "TCON (Content type):" | sed "s/TCON (Content type): //" | sed -r 's/\([0-9]+\)//' | xargs)
    echo -n "$genre"
  fi
}

function file_to_m3u_record() {
  TITLE=$(basename "$1")
  echo "#EXTINF:0,$TITLE"
  echo "$1"
}

function generate_playlist() {
  find . -type f -name "*.flac" -o -type f -name "*.mp3" -print0 | while read -d $'\0' file
  do
    for genre in $(get_music_genres "$file"); do
      if [[ $genre =~ ^"#" ]]
      then
        playlist_file="__${genre:1}.m3u"

        # initializing the playlist if not exists
        if [ ! -f "$playlist_file" ]
        then
          echo "[$playlist_file] initializing playlist"
          {
            echo '#EXTM3U'
            echo "#PLAYLIST:$genre (auto-generated)"
            echo ''
          } >> "$playlist_file"
        fi

        echo "[$playlist_file] adding $file"
        file_to_m3u_record "$file" >> "$playlist_file"
      fi
    done
  done
}

if ! type id3v2 &> /dev/null
then
  echo "You must install id3v2" 1>&2
  exit 1
fi

find .  -name "__*.m3u" -delete

generate_playlist

