#!/bin/bash

CITY=$2
PHOTOS_DIR=$CITY/photos
AUTHOR=todo

THUMB_SIZE=450x450
MEDIUM_SIZE=960x540
FULL_SIZE=1920x1080

case "$1" in
  resize)
    SOURCE_DIR=$3
    THUMBS_DIR=$PHOTOS_DIR/thumbs
    MEDIUM_DIR=$PHOTOS_DIR/medium

    mkdir -p ${THUMBS_DIR}
    mkdir -p ${MEDIUM_DIR}

    for file in ${SOURCE_DIR}/*.*
      do
        echo "$file "
        filename=$(basename "$file")
        extension="${filename##*.}"
        filename="${filename%.*}"

        dest_full="${PHOTOS_DIR}//${filename}.${extension}"
        dest_med="${MEDIUM_DIR}//${filename}_medium.${extension}"
        dest_thumb="${THUMBS_DIR}//${filename}_thumb.png"

        convert -resize $FULL_SIZE "$file" "$dest_full"
        convert -resize $MEDIUM_SIZE "$file"  "$dest_med"
        convert -resize $THUMB_SIZE "$file"  "$dest_thumb"
        # convert -define jpeg:size=300x300 "$file" -thumbnail $THUMB_SIZE^ -gravity center -extent $THUMB_SIZE $dest_thumb
      done
  ;;
  html)
    temp_photos_html=$CITY/photos/photos.html
    gallery_index=$CITY/photos/index.html

    for file in ${CITY}/photos/*.JPG
      do
        name=${file##*/}

        filename=$(basename "$file")
        extension="${filename##*.}"
        filename="${filename%.*}"

        thumb_img=thumbs/${filename}_thumb.png
        med_img=medium/${filename}_medium.JPG

        main_img_dim=`identify -format "%wx%h" "$file"`
        med_img_dim=`identify -format "%wx%h" "$PHOTOS_DIR/$med_img"`

        thumb_width=`identify -format "%w" "$file"`
        thumb_height=`identify -format "%h" "$file"`

        if (( $thumb_width < $thumb_height ))
        then
          thumb_class="portrait"
        else
          thumb_class="landscape"
        fi

        sed \
          -e "s~{{ main-img }}~$filename.$extension~g" \
          -e "s~{{ main-img-size }}~$main_img_dim~g"  \
          -e "s~{{ med-img }}~$med_img~g" \
          -e "s~{{ med-img-size }}~$med_img_dim~g" \
          -e "s~{{ img-author }}~$AUTHOR~g" \
          -e "s~{{ thumb-img }}~$thumb_img~g" \
          -e "s~{{ thumb-class }}~$thumb_class~g" photo-template.html

    done > $temp_photos_html
    sed -e "/{{ photos }}/{ r $temp_photos_html" -e "d}" gallery-template.html > $gallery_index
    rm $temp_photos_html

    # replace other vars
    while IFS="=" read key value; do
      sed -i.bak -e "s~{{ $key }}~$value~g" $gallery_index
      rm $gallery_index.bak
    done < vars-$CITY

    echo "Generated gallery $gallery_index"
  ;;
esac
