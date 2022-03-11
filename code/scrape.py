#!/usr/bin/env python3
import requests
from typing import List
import logging as log


def download_image(filename: str, uri: str) -> str:
    import os.path
    # Build filename with extension
    ext = uri.split('.')[-1]
    with_ext = f'{filename}.{ext}'
    path = '../data/img/' + with_ext
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
    if len(argv) != 2:
        raise RuntimeError("Input file of links required!")
    with open(argv[1], 'r') as f1:
        links = f1.read().splitlines()

    for i, uri in enumerate(links):
        log.info(f'Downloading image {i}...')
        download_image(f'img{i}', uri)
        

if __name__ == "__main__":
    import sys
    # Logging config
    log.basicConfig(stream=sys.stdout, level=log.INFO)
    status = main(sys.argv)
    sys.exit(status)

