#!/bin/bash

CITY=$2
PHOTOS_DIR=$CITY/photos
AUTHOR=todo

THUMB_SIZE=300x200
MEDIUM_SIZE=960x540
FULL_SIZE=1920x1080

case "$1" in
  resize)
    SOURCE_DIR=original/CapeTown
    THUMBS_DIR=$PHOTOS_DIR/thumbs
    MEDIUM_DIR=$PHOTOS_DIR/medium

    mkdir -p ${THUMBS_DIR}
    mkdir -p ${MEDIUM_DIR}

    for file in ${SOURCE_DIR}/*.jpg
      do
        echo "$file "
        WIDTH=`identify -format "%w" "$file"`
        HEIGHT=`identify -format "%h" "$file"`
        filename=$(basename "$file")
        extension="${filename##*.}"
        filename="${filename%.*}"

        dest_full="${PHOTOS_DIR}//${filename}.${extension}"
        dest_med="${MEDIUM_DIR}//${filename}_medium.${extension}"
        dest_thumb="${THUMBS_DIR}//${filename}_thumb.png"

        convert -resize $FULL_SIZE "$file" "$dest_full"
        convert -resize $MEDIUM_SIZE "$file"  "$dest_med"
        convert -sample $THUMB_SIZE -strip "$file" "$dest_thumb"
      done
    ;;
  html)
    # images=$(
      for file in ${CITY}/photos/*.jpg
        do
          name=${file##*/}

          filename=$(basename "$file")
          extension="${filename##*.}"
          filename="${filename%.*}"

          thumb_img=thumbs/${filename}_thumb.png
          med_img=medium/${filename}_medium.jpg

          main_img_dim=`identify -format "%wx%h" "$file"`
          med_img_dim=`identify -format "%wx%h" "$PHOTOS_DIR/$med_img"`

          sed \
            -e "s~{{ main-img }}~$filename.$extension~g" \
            -e "s~{{ main-img-size }}~$main_img_dim~g"  \
            -e "s~{{ med-img }}~$med_img~g" \
            -e "s~{{ med-img-size }}~$med_img_dim~g" \
            -e "s~{{ img-author }}~$AUTHOR~g" \
            -e "s~{{ thumb-img }}~$thumb_img~g" photo-template.html
        done
    ;;
esac
