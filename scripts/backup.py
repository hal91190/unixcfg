#!/usr/bin/env python3

import logging
import rsync

if __name__ == '__main__':
    logging.basicConfig(format='%(asctime)s (%(levelname)s):%(message)s', level=logging.DEBUG)
    logging.debug('Backup started')
    rsync.sync('/home/hal/Téléchargements/00testbackup/configs/',
               '/home/hal/Téléchargements/00testbackup/configs.sync')
    rsync.sync('/home/hal/Téléchargements/00testbackup/configs/',
               '/home/hal/Téléchargements/00testbackup/configs.sync_ex',
               to_exclude=['.git', 'README.md'])
    rsync.sync('/home/hal/Téléchargements/00testbackup/configs/',
               '/home/hal/Téléchargements/00testbackup/configs.bak',
               backup_mode=True)
    logging.debug('Backup ended')
