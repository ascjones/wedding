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
    sed -i -e "/{{ $name }}/ r $file" -e "s/{{ $name }}//" $town.html
  done
}

generate "london"
generate "capetown"
