import logging
import os
import re
import subprocess
import tempfile
from datetime import datetime
from pathlib import Path


def sync(source, destination, to_exclude=None, backup_mode=False):
    """Sync two directories.

    Args:
        source: source directory.
            If source ends with a '/', the content is synced (not the directory itself).
        destination: destination directory. It will be created if it does not exist.
        to_exclude: list of files to exclude from sync
        backup_mode: True to sync, False to backup
    """
    with RsyncRunner(source, destination, to_exclude, backup_mode) as rsync_runner:
        stats = rsync_runner.invoke_rsync()
    return stats


class RsyncRunner(object):
    """A context manager class to run rsync.
    """

    def __init__(self, source, destination, to_exclude=None, backup_mode=False):
        """Initialize an rsync object.

        Args:
            source: source directory.
                If source ends with a '/', the content is synced (not the directory itself).
            destination: destination directory. It will be created if it does not exist.
            to_exclude: list of files to exclude from sync
            backup_mode: True to sync, False to backup
        Raises:
            ValueError: if source does not exist.
            OSError: a subclass of OSError can be raised during the creation of the destination path.
        """
        self.source_path = Path(source)
        if not self.source_path.exists():
            raise ValueError("Source path does not exist")
        self.source_content = (source[-1] == '/')

        self.original_destination_path = Path(destination)
        self.current_destination_path = self.original_destination_path
        self.current_destination_path.mkdir(parents=True, exist_ok=True)

        self.to_exclude = [] if to_exclude is None else to_exclude
        self.excluded_files = None
        self.backup_mode = backup_mode
        self.rsync_command = ['rsync', '-ah', '--stats', '--delete']
        logging.info('%s %s %s to %s excluding %s',
                     'Backup' if backup_mode else 'Syncing',
                     'content of' if self.source_content else 'directory',
                     self.source_path,
                     self.current_destination_path,
                     self.to_exclude)

    def __enter__(self):
        self.process_excluded_files()
        self.process_backup_mode()
        self.process_source_and_destination()
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        if self.to_exclude:
            os.remove(self.excluded_files)
        if self.backup_mode:
            previous_backup_path = self.original_destination_path / 'current'
            if previous_backup_path.exists():
                os.remove(previous_backup_path)
            os.symlink(self.current_destination_path, previous_backup_path)

    def process_excluded_files(self):
        """Define rsync arguments to exclude files.

        Raises:
            OSError: a subclass of OSError can be raised during the creation of the temporary file.
        """
        if self.to_exclude:
            with tempfile.NamedTemporaryFile(mode='w', delete=False) as excluded_files:
                excluded_files.write('\n'.join(self.to_exclude))
                self.rsync_command += ['--delete-excluded', '--exclude-from=' + excluded_files.name]
                self.excluded_files = excluded_files.name
            logging.debug('Writing excluded filenames in %s', self.excluded_files)

    def process_backup_mode(self):
        """Define rsync argument for backup"""
        if self.backup_mode:
            previous_backup_path = self.original_destination_path / 'current'
            self.current_destination_path /= datetime.today().isoformat()
            if previous_backup_path.is_dir():
                self.rsync_command.append('--link-dest=' + str(previous_backup_path))
            logging.debug('Destination directory for backup: %s', self.current_destination_path)

    def process_source_and_destination(self):
        """Define rsync options for source and destination directories."""
        self.rsync_command += [str(self.source_path) + '/' if self.source_content else '',
                               str(self.current_destination_path)]
        logging.debug('Directories: %s -> %s',
                      str(self.source_path) + '/' if self.source_content else '',
                      str(self.current_destination_path))

    def invoke_rsync(self):
        """Invoke rsync and parse stats."""
        completed_process = subprocess.run(self.rsync_command,
                                           stdout=subprocess.PIPE,
                                           stderr=subprocess.PIPE)
        logging.debug(completed_process)
        stats = None
        if completed_process.returncode:
            logging.error(completed_process.stderr)
        else:
            stats = parse_rsync_stats(str(completed_process.stdout, 'utf-8'))
            logging.info(stats)
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
        nof: a number of files as displayed by rsync
    """
    return int(nof.replace(',', ''))


def tfs2int(tfs):
    """Convert a "total file size" to an int.

    Args:
        tfs: a total file size as displayed by rsync
    """
    scales = {'K': 1024, 'M': 1024 * 1024, 'G': 1024 * 1024 * 1024}
    multiplier = 1
    if tfs[-1] in scales:
        multiplier = scales[tfs[-1]]
        tfs = tfs[:-1]
    float_value = float(tfs.replace(',', '')) * multiplier
    return int(float_value)
