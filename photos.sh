#!/bin/bash

PHOTOS_DIR=photos/london
THUMBS_DIR=${PHOTOS_DIR}/thumbs
MEDIUM_DIR=${PHOTOS_DIR}/medium

case "$1" in
  resize)
    mkdir -p ${THUMBS_DIR}
    mkdir -p ${MEDIUM_DIR}

    for file in ${PHOTOS_DIR}/*
    do
      # next line checks the mime-type of the file
      IMAGE_TYPE=`file --mime-type -b "$file" | awk -F'/' '{print $1}'`
      if [ x$IMAGE_TYPE = "ximage" ]; then
          WIDTH=`identify -format "%w" "$file"`
          HEIGHT=`identify -format "%h" "$file"`
          # If the image width is greater that 200 or the height is greater that 150 a thumb is created
         if [ $WIDTH -ge  201 ] || [ $HEIGHT -ge 151 ]; then
            filename=$(basename "$file")
            extension="${filename##*.}"
            filename="${filename%.*}"

            convert -sample 200x150 -strip "$file" "${THUMBS_DIR}//${filename}_thumb.png"
            convert -resize 50% "$file" "${MEDIUM_DIR}//${filename}_medium.${extension}"
         fi
      fi
    done
    ;;
  html)
    for file in ${PHOTOS_DIR}/*.jpg
    do
      WIDTH=`identify -format "%w" "$file"`
      HEIGHT=`identify -format "%h" "$file"`
      name=${file##*/}
      thumb_img=$THUMBS_DIR/

      sed -e "s/{{ main-img }}/$name/g" photo-template.html
    done
    ;;
esac
