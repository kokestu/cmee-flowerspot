#!/bin/bash

url=$1

# Remove existing links file
[ -f ../data/links.txt ] && rm ../data/links.txt

# Recursively get the links for each page
while [[ "$url" =~ ^https://.*$ ]]; do
  echo "Get ${url}"
  # Fetch the index
  wget ${url} -O ../data/index.html -q

  # Grab image links
  cat ../data/index.html | grep 'src="https://upload.wikimedia.org/wikipedia/commons/thumb' | sed 's/.*src="\([^"]*\)".*/\1/' | tail -n +2 >> ../data/links.txt

  # Get next page
  url=$(cat ../data/index.html | grep 'next page' | head -1 |sed 's/.*previous page//' | sed 's/.*href="\([^"]*\)".*/https:\/\/commons.wikimedia.org\1/' | sed 's/amp;//')
done

# Remove the html
rm ../data/index.html

