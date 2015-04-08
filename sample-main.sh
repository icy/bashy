#!/bin/bash

for _ in libs/*.sh; do
  source "${_}" : \
  || exit 1
done

[[ -z "$@" ]] || $@
