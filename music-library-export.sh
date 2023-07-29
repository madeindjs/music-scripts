#!/bin/bash

function help() {
  cat << EOL
music-library-export.sh - Audio library syncing and conversion utility

The intended use is syncing an audio library with many lossless files to a mobile device with limited storage.

Usage:
  music-library-export.sh <EXPORT_DIR> [FORMAT=ogg]
EOL
}

EXPORT_DIR="$1"
FORMAT="$2"

if [ -z "$EXPORT_DIR" ]; then
  help
  echo "You must provide the export directory" 1>&2
  exit 1
fi

if [ -z "$FORMAT" ]; then
  FORMAT="ogg"
fi

mkdir -p "$EXPORT_DIR" 2> /dev/null

function has() {
  command -v "$1" >/dev/null 2>&1
}

# test dependencies
if ! has ffmpeg
then
  echo "you need to install ffmpeg"
  exit 1
fi

if has parallel
then
  JOBS_FILE=$(mktemp "$EXPORT_DIR/music-library-export.XXXXX")
  echo "tasks created in $JOBS_FILE"
else
  echo "parallel is not installed. I'll convert your files one by one. Consider installing parallel"
fi

function get_out_directory() {
  music_directory=$(dirname "$1")
  path="$EXPORT_DIR/${music_directory/.}"
  mkdir -p "$path"
  echo "$path"
}

function convert_file() {
  path=$(get_out_directory "$1")
  filename="$(basename "$1")"
  new_file="$path/${filename%.*}.$2"

  if [ -f "$new_file" ]; then  return 0; fi

  if has parallel
  then
    echo "ffmpeg -i '$1' '$new_file'" >> "$JOBS_FILE"
  else
    ffmpeg -i "$1" "$new_file"
  fi
}

function copy_file() {
  path=$(get_out_directory "$1")
  new_file="$path/$(basename "$1")"

  if [ -f "$new_file" ]; then  return 0; fi
  
  if has parallel
  then
    echo "cp '$1' '$new_file'" >> "$JOBS_FILE"
  else
    cp "$1" "$new_file"
  fi
}

find . -type f -print0 | while read -r -d $'\0' FILE
do
  if [[ $FILE == *.wav ]] || [[ $FILE == *.flac ]] || [[ $FILE == *.alac ]]
  then
    convert_file "$FILE" "$FORMAT"
  else
    copy_file "$FILE"
  fi
done

if has parallel
then
  parallel --bar < "$JOBS_FILE"
fi
