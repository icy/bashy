#!/bin/bash

# Purpose: Deal with exif data
# Author : Anh K. Huynh
# Date   : 2014
# License: MIT

# Clear all exif data from input files
exif_clear() {
  local _f

  exiftool -ver >/dev/null 2>&1 \
  || {
    echo >&2 ":: exiftoool not found"
    return 127
  }

  while [[ -n "$@" ]]; do
    _f="$1"
    [[ -f "$_f" ]] || { shift; continue; }
    exiftool -all= "$_f" >/dev/null \
      && rm -f "${_f}_original" \
      && echo "Clear all exif data for $_f"
    shift
  done
}
