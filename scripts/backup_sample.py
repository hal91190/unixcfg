#!/usr/bin/env python3.6

import logging
import rsync


def print_header():
    print('''\
<table style="border: 1px solid black; border-collapse: collapse;">\
<thead>\
<tr style="border: 1px solid black;">\
<th style="border: 1px solid black;">Name</th>\
<th style="border: 1px solid black;">Number of files (created, deleted, transferred)</th>\
<th style="border: 1px solid black;">File size (transferred)</th></tr>\
</thead>\
<tbody>\
''')


def print_footer():
    print('</tbody></table>')


def print_stats(title, stats):
    if stats:
        print(f'''\
<tr style="border: 1px solid black;">\
<th style="border: 1px solid black;">{title}</th>\
<td style="border: 1px solid black; text-align: right;">{stats[0]} ({stats[1]}, {stats[2]}, {stats[3]})</td>\
<td style="border: 1px solid black; text-align: right;">{stats[4]} ({stats[5]})</td></tr>\
''')
    else:
        print(f'''\
<tr style="border: 1px solid black; color: yellow; background: red;">\
<th style="border: 1px solid black;">{title}</th>\
<td colspan="2" style="border: 1px solid black;">ERROR (see log)</td>\
</tr>\
''')


if __name__ == '__main__':
    logging.basicConfig(filename='/home/hal/Téléchargements/00testbackup/backup.log', format='%(asctime)s (%(levelname)s):%(message)s', level=logging.DEBUG)
    logging.debug('Backup started')

    print_header()
    stats = rsync.sync('/home/hal/Téléchargements/00testbackup/configs/',
                       '/home/hal/Téléchargements/00testbackup/configs.sync')
    print_stats('Test1', stats)
    stats = rsync.sync('/home/hal/Téléchargements/00testbackup/configs/',
                       '/home/hal/Téléchargements/00testbackup/configs.sync_ex',
                       to_exclude=['.git', 'README.md'])
    print_stats('Test2', stats)
    stats = rsync.sync('/home/hal/Téléchargements/00testbackup/configs/',
                       '/home/hal/Téléchargements/00testbackup/configs.bak',
                       backup_mode=True)
    print_stats('Test3', stats)
    print_footer()

    logging.debug('Backup ended')
