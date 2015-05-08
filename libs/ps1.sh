# Purpose: Provide Bash PS1
# Author : Anh K. Huynh
# Date   : 2010 (v1), 2014 (v2)
# Usage  : source $0

ps1_icy() {
  export PS1='\[\e[0;32m\]:: \[\e[0;37m\]You are \[\e[0;31m\]\u\[\e[0;37m\]@\[\e[0;31m\]\h\[\e[0;37m\] \[\e[0;37m\]\w\n\[\e[0;32m\]\$\[\e[0m\] '
}
