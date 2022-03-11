
def download_image(filename: str, uri: str) -> str:
    import os.path
    # Build filename with extension
    ext = uri.split('.')[-1]
    with_ext = f'{filename}.{ext}'
    path = '../data/' + with_ext
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
