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

# Fetch all URLs from STDIN. Example
#   curl -sL duckduckgo.com |url_fetch
url_fetch() {
  ruby -e 'STDIN.read.scan(%r{(https?://[a-z%0-9\-_\./]+)}i) { |m| puts m }' \
  | sort -u
}
