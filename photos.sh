#!/bin/bash

SOURCE_DIR=photos/original/CapeTown
PHOTOS_DIR=photos/$2
AUTHOR=todo

THUMBS_DIR=${PHOTOS_DIR}/thumbs
MEDIUM_DIR=${PHOTOS_DIR}/medium

THUMB_SIZE=300x200
MEDIUM_SIZE=960x540
FULL_SIZE=1920x1080

case "$1" in
  resize)
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
      for file in ${PHOTOS_DIR}/*.jpg
        do
          name=${file##*/}

          filename=$(basename "$file")
          filename="${filename%.*}"

          thumb_img=${THUMBS_DIR}/${filename}_thumb.png
          med_img=${MEDIUM_DIR}/${filename}_medium.jpg

          main_img_dim=`identify -format "%wx%h" "$file"`
          med_img_dim=`identify -format "%wx%h" "$med_img"`

          sed \
            -e "s~{{ main-img }}~$file~g" \
            -e "s~{{ main-img-size }}~$main_img_dim~g"  \
            -e "s~{{ med-img }}~$med_img~g" \
            -e "s~{{ med-img-size }}~$med_img_dim~g" \
            -e "s~{{ img-author }}~$AUTHOR~g" \
            -e "s~{{ thumb-img }}~$thumb_img~g" photo-template.html
        done
      # )
      # sed -e 's~{{ images }}~'$images'~g' <gallery-template.html >gallery.html
    ;;
esac
