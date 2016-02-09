#!/bin/bash

rm -f london.html
cp index-template.html london.html

for file in vars/london/*
do
  name=${file##*/}
  sed -i -e "/{{ $name }}/ r $file" -e "s/{{ $name }}//" london.html
done 
