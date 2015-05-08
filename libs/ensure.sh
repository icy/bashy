#!/bin/bash

# Purpose: Ensure something wrong or right
# Author : Anh K. Huynh
# Date   : 2015
# License: MIT

__is_user() {
  local _die="true"
  local _this_user="$(id -un)"
  local _allowed="$*"

  while [[  "$#" -ge 1 ]]; do
    if [[ "$_this_user" == "$1" ]]; then
      _die="false"
      break;
    fi
    shift
  done
  [[ "$_die" == "false" ]]
}

__is_node() {
  local _die="true"
  local _this_node="$(hostname -s)"
  local _allowed="$*"

  while [[  "$#" -ge 1 ]]; do
    if [[ "$_this_node" == "$1" ]]; then
      _die="false"
      break;
    fi
    shift
  done
  [[ "$_die" == "false" ]]
}

# Ensure if current user is in the list of user
ensure_user() {
  __is_user $* \
  || {
    echo >&2 ":: $FUNCNAME: This script must be executed under user '$*'"
    exit
  }
}

# Ensure hostname (simple name) matching
ensure_node() {
  __is_node $* \
  || {
    echo >&2 ":: $FUNCNAME: This script must be executed under node '$*'"
    exit
  }
}
