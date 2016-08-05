#! /bin/bash

DEST=./photos/original/CapeTown

while read photo; do
  cp "/home/andrew/Pictures/Wedding/CapeTown/$photo" $DEST
done <capetownimagelist

# for f in $DEST/*; do mv "$f" "${f#Michelle}"; done
# rename -v 's/Michelle\ &\ Andrew\ _//' photos/original/CapeTown/*.jpg
