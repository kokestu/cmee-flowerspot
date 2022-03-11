# cmee-flowerspot
Model to identify mature flowers from immature and other plant foliage

## How to use the scraper

```
python3 scrape.py <category-url> <label>
```

This will recursively fetch all the image thumbnails from the category (all pages) and store them in
`data/img/label`.
