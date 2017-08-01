import logging
import re
import subprocess
import tempfile
import os
from datetime import datetime
from pathlib import Path


def sync(source, destination, to_exclude=None, backup_mode=False):
    """Sync two directories.

    Args:
        source: source directory.
            If source ends with a '/', the content is synced (not the directory itself).
        destination: destination directory. It will be created if it does not exist.
        to_exclude: list of files to excluse from sync
    """
    if to_exclude is None:
        to_exclude = []
    backup_string = 'Syncing'
    if backup_mode:
        backup_string = 'Backup'
    logging.info('%s from %s to %s excluding %s', backup_string, source, destination, to_exclude)
    destination_path = Path(destination)
    if backup_mode:
        destination_path /= datetime.today().isoformat()
        logging.debug('Backup destination: %s', destination_path)
    destination_path.mkdir(parents=True, exist_ok=True)
    excluded_files = None
    try:
        excluded_files = tempfile.NamedTemporaryFile(mode='w', delete=False)
        excluded_files.write('\n'.join(to_exclude))
        excluded_files.close()
        rsync_command = ['rsync', '-ah', '--stats', '--delete']
        if backup_mode:
            previous_backup_path = Path(destination) / 'current'
            if previous_backup_path.is_dir():
                rsync_command.append('--link-dest=' + str(previous_backup_path))
        rsync_command += ['--delete-excluded', '--exclude-from=' + excluded_files.name,
                         source, destination_path]
        completed_process = subprocess.run(rsync_command, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        logging.debug(completed_process)
        stats = None
        if completed_process.returncode:
            logging.error(completed_process.stderr)
        else:
            stats = parse_rsync_stats(str(completed_process.stdout, 'utf-8'))
            logging.info(stats)
    finally:
        if excluded_files:
            os.remove(excluded_files.name)
        if backup_mode:
            previous_backup_path = Path(destination) / 'current'
            if previous_backup_path.exists():
                os.remove(Path(destination) / 'current')
            os.symlink(destination_path, Path(destination) / 'current')
    logging.debug('%s ended', backup_string)
    return stats


def parse_rsync_stats(rsync_stdout):
    """Parse the stats displayed by rsync on standard output.

    Args:
        rsync_stdout: the output of rsync.

    Rsync output has to respect the following example:
    \n
    Number of files: 1, 468 (reg: 1, 069, dir: 399)\n
    Number of created files: 0\n
    Number of deleted files: 1 (reg: 1)\n
    Number of regular files transferred: 1\n
    Total file size: 22.68M bytes\n
    Total transferred file size: 14.78K bytes\n
    Literal data: 14.78K bytes\n
    Matched data: 0 bytes\n
    File list size: 0\n
    File list generation time: 0.001 seconds\n
    File list transfer time: 0.000 seconds\n
    Total bytes sent: 58.88K\n
    Total bytes received: 480\n
    \n
    sent 58.88K bytes received 480 bytes 39.57K bytes / sec\n
    total size is 22.68M speedup is 382.19\n

    """
    pattern = re.compile(r"""
    \n
    Number.of.files:.([0-9,]+)(?:.\(.*\))?\n
    Number.of.created.files:.([0-9,]+)(?:.\(.*\))?\n
    Number.of.deleted.files:.([0-9,]+)(?:.\(.*\))?\n
    Number.of.regular.files.transferred:.([0-9,]+)\n
    Total.file.size:.([0-9,.]+[KMG]?).bytes\n
    Total.transferred.file.size:.([0-9,.]+[KMG]?).bytes\n
    """, re.VERBOSE | re.MULTILINE)
    match = pattern.match(rsync_stdout)
    number_of_files = nof2int(match.group(1))
    number_of_created_files = nof2int(match.group(2))
    number_of_deleted_files = nof2int(match.group(3))
    number_of_regular_files_transferred = nof2int(match.group(4))
    total_file_size = tfs2int(match.group(5))
    total_transferred_file_size = tfs2int(match.group(6))
    return number_of_files, \
        number_of_created_files, \
        number_of_deleted_files, \
        number_of_regular_files_transferred, \
        total_file_size, \
        total_transferred_file_size


def nof2int(nof):
    """Convert a "number of files" to an int.

    Args:
        nof a number of files as displayed by rsync
    """
    return int(nof.replace(',', ''))


def tfs2int(tfs):
    """Convert a "total file size" to an int.

    Args:
        tfs a total file size as displayed by rsync
    """
    scales = {'K': 1024, 'M': 1024 * 1024, 'G': 1024 * 1024 * 1024}
    multiplier = 1
    if tfs[-1] in scales:
        multiplier = scales[tfs[-1]]
        tfs = tfs[:-1]
    float_value = float(tfs.replace(',', '')) * multiplier
    return int(float_value)
