#!/usr/bin/env python3.6
"""This script aims at organizing files in directories wrt their type."""

import logging
from pathlib import Path

def organize_file(path):
    logging.debug('Organizing file %s', path)

def organize_directory(path):
    logging.debug('Organizing directory %s', path.resolve())
    for file in path.iterdir():
        if file.is_file():
            organize_file(file)

if __name__ == '__main__':
    logging.basicConfig(filename='/home/hal/Téléchargements/organize.log', format='%(asctime)s (%(levelname)s):%(message)s', level=logging.DEBUG)
    logging.debug('Organize started')
    origin_path = Path('.')
    organize_directory(origin_path)
    logging.debug('Organize ended')
