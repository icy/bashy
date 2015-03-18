#!/bin/bash

# Purpose: URL processing
# Author : Anh K. Huynh
# Date   : 2015
# License: MIT

# Usage
#   echo -n "http://example.com/" | url_encode
url_encode() {
  perl -e '
    use URI::Escape;
    while (<>) {
      printf("%s", uri_escape($_));
    }
  '
}
