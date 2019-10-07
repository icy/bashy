#!/usr/bin/env bash

# Purpose: Dealing with images
# Author : Anh K. Huynh
# Date   : 2018
# License: MIT

export __IMG_WATERMARK_FONT="/home/pi/.fonts/Chococooky.ttf"
export __IMG_WATERMARK_STRING="Ky-Anh Huynh - CC BY-NC-ND 4.0"

add_watermark_with_text() {
  local _f_input="$1"
  local _f_output="${2:-$1}"
  local _f_width=""

  if [[ -z "$_f_output" ]]; then
    warn "Please specify output file name (will be overwritten)"
    return 1
  fi

  if [[ -f "$_f_output" ]]; then
    warn "Output file does exist '$_f_output'. Please use FORCE=1 to continue"
    if [[ ! "$FORCE" == "1" ]]; then
      return 1
    fi
  fi

  local _banner_height=""
  local _banner_text_size=""

  if [ -f "$_f_input" ]; then
    _width="$(image_get_width "$_f_input")"

    if image_is_landscape "$_f_input"; then
      msg "$FUNCNAME: Image in landscape mode, widthxheight = $_width x $(image_get_height "$_f_input")"
      _banner_height="30"
      _banner_text_size="20"
    else
      _banner_height="30"
      _banner_text_size="20"
    fi

    msg "$FUNCNAME: Image width = $_width"
    convert \
      -background "#0004" \
      -fill white -gravity center \
      -size ${_width}x${_banner_height} \
      -font "$__IMG_WATERMARK_FONT" \
      -pointsize ${_banner_text_size} \
      label:"$__IMG_WATERMARK_STRING" \
      +size "$_f_input"  \
      -gravity south \
      +swap -composite \
      "$_f_output"
  else
    msg "$FUNCNAME: File not found '$_f_input'"
  fi
}

# Get width of any image
# FIXME: handle problem with bad exif data
image_get_width() {
  local _f_image="$@"
  if [ ! -f "$_f_image" ]; then
    return 1
  fi
  identify -format %w "$_f_image"
}

image_get_height() {
  local _f_image="$@"
  if [ ! -f "$_f_image" ]; then
    return 1
  fi
  identify -format %h "$_f_image"
}

image_is_landscape() {
  local _f_image="$@"
  if [ ! -f "$_f_image" ]; then
    msg "$FUNCNAME: image doesn't exist $_f_image'"
    return 127
  fi
  local _w="$(image_get_width "$_f_image")"
  local _h="$(image_get_height "$_f_image")"
  [[ $_w -ge $_h ]]
}
