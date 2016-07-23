#!/bin/bash

PHOTOS_DIR=photos/london
AUTHOR=todo
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
      name=${file##*/}

      filename=$(basename "$file")
      filename="${filename%.*}"

      thumb_img=${THUMBS_DIR}/${filename}_thumb.png
      med_img=${MEDIUM_DIR}/${filename}_medium.jpg

      main_img_dim=`identify -format "%wx%h" "$file"`
      med_img_dim=`identify -format "%wx%h" "$med_img"`

      sed \
        -e "s~{{ main-img }}~photos/london/$name~g" \
        -e "s~{{ main-img-size }}~$main_img_dim~g" photo-template.html \
        -e "s~{{ med-img }}~$med_img~g" photo-template.html \
        -e "s~{{ med-img-size }}~$med_img_dim~g" photo-template.html \
        -e "s~{{ img-author }}~$AUTHOR~g" photo-template.html \
        -e "s~{{ thumb-img }}~$thumb_img~g" photo-template.html
    done
    ;;
esac
