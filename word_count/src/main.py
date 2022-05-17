from os.path import (
    dirname,
    realpath
)
from os import environ
from glob import glob
import sys
import re
from time import sleep

PROJECT_ROOT_DIR = dirname(realpath(__file__))
COL_GREEN = "\033[1;32m"


def supports_color():
    """
    Returns True if the running system's terminal supports color, and False
    otherwise.
    """
    plat = sys.platform
    supported_platform = plat != 'Pocket PC' and (plat != 'win32' or
                                                  'ANSICON' in environ)

    is_a_tty = hasattr(sys.stdout, 'isatty') and sys.stdout.isatty()
    return supported_platform and is_a_tty


def msg(text, color=COL_GREEN, replace_line=False):
    COL_RESET = "\u001b[0m"
    end_chr = "\r" if replace_line else "\n"
    if supports_color:
        print(f"{color}{text}{COL_RESET}", end=end_chr)
    else:
        print(text, end=end_chr)


def read_in_chunks(file_obj,
                   chunk_size=20):
    "iterator to read a file with given chunk size"
    while True:
        data = file_obj.read(chunk_size)
        if not data:
            break
        yield data


def read_txt_files(path_to_dir):
    "get all text files in the input files directory"
    return glob(f"{path_to_dir}/**/*.txt", recursive=True)


def main():
    text_files = read_txt_files(f"{PROJECT_ROOT_DIR}/input_files")
    for text_file in text_files:
        word_count = 0
        with open(text_file) as file_obj:
            for line in file_obj:
                # split by using spaces,tabs,newlines and remove empty elements
                splitted_line = list(filter(
                    None,
                    re.split('[ \t\n]', line))
                )
                word_count += len(splitted_line)
                msg(f"found: {word_count}", replace_line=True)
        msg(f"{text_file.replace(PROJECT_ROOT_DIR+'/','')} => {word_count}")
        sleep(1)


if __name__ == '__main__':
    main()
