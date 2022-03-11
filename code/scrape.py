#!/usr/bin/env python3
import requests
from typing import List
import logging as log
import os.path

def download_image(filename: str, uri: str, location: str) -> str:
    # Build filename with extension
    ext = uri.split('.')[-1]
    with_ext = f'{filename}.{ext}'
    path = location + with_ext
    if not os.path.exists(path):
        # Wikimedia requires descriptive headers
        log.info(f'Downloading image for {filename}...')
        headers = {'user-agent':
            'cmee-flowerspot/0.0.0 (https://github.com/kokestu/cmee-flowerspot)'}
        img_data = requests.get(uri, headers=headers).content
        with open(path, 'wb') as file:
            file.write(img_data)
    else:
        log.info(f'Image for {filename} already present...')
        
    return with_ext 

def main(argv: List[str]):
    import subprocess

    # Get arguments
    if len(argv) != 3:
        raise RuntimeError("Category URL and label type required!")
    category = argv[1]
    label = argv[2]

    # Get image links
    subprocess.Popen(
        f"bash get-img-uri.sh {category}", shell=True
    ).wait()

    # Read image links
    with open('../data/links.txt', 'r') as f1:
        links = f1.read().splitlines()

    # Create appropriate directory
    dirpath = f'../data/img/{label}/'
    if not os.path.isdir(dirpath):
        os.makedirs(dirpath, exist_ok=True)

    # Download images
    for i, uri in enumerate(links):
        log.info(f'Downloading image {i}...')
        download_image(f'img{i}-{label}', uri, dirpath)
        

if __name__ == "__main__":
    import sys
    # Logging config
    log.basicConfig(stream=sys.stdout, level=log.INFO)
    status = main(sys.argv)
    sys.exit(status)

