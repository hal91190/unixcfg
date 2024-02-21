#!/usr/bin/env bash

rotate-backups -n -p -r -d7 -w4 -m6 -yalways \
    "/mnt/backup/Calibre Library/" \
    "/mnt/backup/Images/" \
    "/mnt/backup/sal9000/etc/" \
    "/mnt/backup/sal9000/root/" \
    "/mnt/backup/sal9000/var/" \
    "/mnt/backup/sal9000/hal/"
