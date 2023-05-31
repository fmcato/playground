#!/bin/sh
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 'ID of youtube video playlist'" >&2
  exit 1
fi

yt-dlp -x --audio-format mp3 -o "%(playlist_title)s/%(playlist_index)s - %(title)s.%(ext)s" \
  --embed-metadata --parse-metadata "playlist_index:%(track_number)s" --embed-thumbnail --convert-thumbnails jpg \
  "https://www.youtube.com/playlist?list=$1"
