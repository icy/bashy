#!/bin/bash

source libs/*.sh

[[ -z "$@" ]] || $@
