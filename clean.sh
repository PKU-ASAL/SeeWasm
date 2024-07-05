#!/usr/bin/env bash
set -e

OUTPUT_DIR=output

error() {
  command printf '\033[1;31mError: %s\033[0m\n\n' "$1" 1>&2
}

usage() {
    cat >&2 <<END_USAGE
clean: remove output files and directories

USAGE:
    clean [FLAGS]

FLAGS:
    -h, --help                  Prints help information
    -f, --force                 Force remove output files and directories

END_USAGE
}

# parse command line options
while [ $# -gt 0 ]
do
  arg="$1"

  case "$arg" in
    -h|--help)
      usage
      exit 1
      ;;
    -f|--force)
      shift # shift off the argument
      rm -rf $OUTPUT_DIR
      mkdir -p $OUTPUT_DIR/log $OUTPUT_DIR/result
      touch $OUTPUT_DIR/log/.placeholder $OUTPUT_DIR/result/.placeholder
      exit 0
      ;;
    *)
      error "Unknown option: '$arg'"
      usage
      exit 1
      ;;
    esac
done

# normal delete
rm -ri $OUTPUT_DIR