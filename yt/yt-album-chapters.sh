#!/bin/sh
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 'ID of youtube video with chapters'" >&2
  exit 1
fi

yt-dlp -x --audio-format mp3 --split-chapters -o "chapter:%(id)s/%(title)s/%(section_number)s - %(section_title)s.%(ext)s" --embed-metadata \
  --embed-thumbnail --convert-thumbnails jpg --parse-metadata "chapter:%(section_number)s:%(track_number)s" \
  --parse-metadata "title:%(album)s" \
  "https://www.youtube.com/watch?v=$1" 

if [ $? -ne 0 ]; then
  exit 1
fi

echo "Adjusting metadata for track title and number"
for FILE in $1/*/*.mp3; do
  FILENAME=$(basename "$FILE")
  TRACK_NO=$(echo "$FILENAME" | awk '{print $1}')
  TRACK=$(echo "$FILENAME" | cut -f 3- -d " ")
  TRACK=${TRACK%.mp3}
  ffmpeg -hide_banner -loglevel error -i "$FILE" -c copy -metadata title="$TRACK" -metadata track="$TRACK_NO" "$FILE".new.mp3 && mv "$FILE".new.mp3 "$FILE"
done

mv $1/* . && rmdir $1 && rm *$1*.mp3
