#!/bin/bash

awk 'BEGIN{getline l < "vars/london/banner-date"}/{{ banner-date }}/{gsub("{{ banner-date }}",l)}1' index-template.html > london.html
