# cmee-flowerspot
Model to identify mature flowers from immature and other plant foliage

## How to use the scraper

To get the image thumbnail links from a category:

```
cd code
bash get-img-uri.sh <category-url>
```

To fetch the images:

```
[ -d ../data/img ] || mkdir ../data/img   # make sure there is a dir
python3 scrape.py ../data/links.txt
```
