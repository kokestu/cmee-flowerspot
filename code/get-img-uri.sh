#!/bin/bash

category=$1

# Remove existing links file
[ -f ../data/links.txt ] && rm ../data/links.txt

# Fetch the index
wget ${category} -O ../data/index.html

# Grab image links
cat ../data/index.html | grep 'src="https://upload.wikimedia.org/wikipedia/commons/thumb' | sed 's/.*src="\([^"]*\)".*/\1/' | tail -n +2 >> ../data/links.txt

# Remove the html
rm ../data/index.html

