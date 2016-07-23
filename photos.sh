#!/bin/bash

PHOTOS_DIR=photos/london
THUMBS_DIR=${PHOTOS_DIR}/thumbs
MEDIUM_DIR=${PHOTOS_DIR}/medium

case "$1" in
  resize)
    mkdir -p ${THUMBS_DIR}
    mkdir -p ${MEDIUM_DIR}

    for file in ${PHOTOS_DIR}/*.jpg
    do
      WIDTH=`identify -format "%w" "$file"`
      HEIGHT=`identify -format "%h" "$file"`
      filename=$(basename "$file")
      extension="${filename##*.}"
      filename="${filename%.*}"

      convert -sample 200x150 -strip "$file" "${THUMBS_DIR}//${filename}_thumb.png"
      convert -resize 50% "$file" "${MEDIUM_DIR}//${filename}_medium.${extension}"
    done
    ;;
  html)
    for file in ${PHOTOS_DIR}/*.jpg
    do
      WIDTH=`identify -format "%w" "$file"`
      HEIGHT=`identify -format "%h" "$file"`
      name=${file##*/}

      filename=$(basename "$file")
      extension="${filename##*.}"
      filename="${filename%.*}"

      thumb_img=${THUMBS_DIR}/${filename}_thumb.png

      sed \
        -e "s/{{ main-img }}/photos\/london\/$name/g" \
        -e "s/{{ main-img-size }}/${WIDTH}x${HEIGHT}/g" photo-template.html
    done
    ;;
esac
