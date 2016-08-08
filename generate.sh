#!/bin/bash

echo CURRENT DIR: $(pwd)

generate () {
  echo GENERATING $1
  town=$1
  dest=$town/index.html
  rm -f $dest
  cp index-template.html $dest

  for file in ./vars/$town/*
  do
    name=${file##*/}
    sed -i.bak -e "/{{ $name }}/ r $file" -e "s/{{ $name }}//" $dest
    rm $dest.bak
  done
}

generate "london"
generate "capetown"
