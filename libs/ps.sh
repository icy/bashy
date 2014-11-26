#!/bin/bash

# Purpose: Collection of `ps` commands
# Author : Anh K. Huynh
# Date   : 2014
# License: MIT

# See more at http://www.cyberciti.biz/tips/top-linux-monitoring-tools.html

# simple listing
ps_processes() {
  ps -A "$@"
}

# long listing
ps_processes_long() {
  ps -Al "$@"
}

# extra full listing
ps_processes_extra_long() {
  ps -AlF "$@"
}

# see all threads: LWP and NLWP
ps_threads() {
  ps -AlFH "$@"
}

ps_threads_after_processes() {
  ps -AlLm "$@"
}

ps_my_processes() {
  ps -U $(whoami) -u $(whoami) u "$@"
}

ps_top_memory_consumers() {
  echo "USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND"
  ps auxf | sort -nr -k 4 | head -10
}

ps_top_cpu_consumers() {
  ps auxf | sort -nr -k 3 | head -10
}
