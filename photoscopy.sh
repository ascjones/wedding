#! /bin/bash

DEST=./photos/capetown
mkdir -p $DEST

# while read photo; do
#   cp "/home/andrew/Pictures/Wedding/CapeTown/$photo" $DEST
# done <photoscapetownlist
# cp /home/andrew/Pictures/Wedding/CapeTown/*.jpg $DEST

# for f in $DEST/*; do mv "$f" "${f#Michelle}"; done
rename -v 's/Michelle\ &\ Andrew\ _//' /home/andrew/Pictures/Wedding/CapeTown/*.jpg
