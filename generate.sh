#!/bin/bash

# awk 'BEGIN{getline l < "vars/london/banner-date"}/{{ banner-date }}/{gsub("{{ banner-date }}",l)}1' index-template.html > london.html
for file in vars/london/*
do
  name=${file##*/}
  # awk -v var_file=$file var_name=$name 'BEGIN{getline l < var_file}/{{ var_name }}/{gsub("{{ var_name }}",l)}1' index-template.html
  awk -v var_file=$file -v var_name=$name 'BEGIN{getline l < var_file}/{{ banner-date }}/{gsub("{{ var_name }}",l)}1' index-template.html
  # awk -v name=$file -v age=$name 'BEGIN{print name, age}'
done # > london.html
