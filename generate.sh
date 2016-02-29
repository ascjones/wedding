#!/bin/bash

echo CURRENT DIR: $(pwd)

generate () {
  echo GENERATING $1
  town=$1
  rm -f $town.html
  cp index-template.html $town.html

  for file in ./vars/$town/*
  do
    name=${file##*/}
    sed -i.bak -e "/{{ $name }}/ r $file" -e "s/{{ $name }}//" $town.html
    rm $town.html.bak
  done
}

generate "london"
generate "capetown"
