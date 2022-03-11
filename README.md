# cmee-flowerspot
Model to identify mature flowers from immature and other plant foliage

## How to use the scraper

```
python3 scrape.py <category-url> <label>
```

This will recursively fetch all the image thumbnails from the category (all pages) and store them in
`data/img/label`.

To get the data we're using, run (from code directory):

```
python3 scrape.py https://commons.wikimedia.org/wiki/Category:Close-up_photographs_of_flowers pos
python3 scrape.py https://commons.wikimedia.org/wiki/Category:Close-up_photographs_of_flower_buds neg
python3 scrape.py https://commons.wikimedia.org/wiki/Category:Close-up_photographs_of_leaves leaves
mv ../data/img/leaves/* ../data/img/pos
```
