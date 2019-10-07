#!/usr/bin/env bash

# Purpose: Common stuff
# Author : Anh K. Huynh
# Date   : 2018
# License: MIT


warn() {
  msg "$@" 1>&2
}

msg() {
  local _args=""
  if [[ "$1" == "-e" ]]; then
    _args="-e"
    shift
  fi
  echo >&2 $_args ":: $@"
}
