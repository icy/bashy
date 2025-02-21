#!/bin/bash
#
# Purpose: Push git commits / branches to all remotes (except some...)
# Author : Anh K. Huynh
# Date   : 2013
# License: MIT
# History: This is part of my private Bash library ;)
#          I share this, because I talked about it on #archlinuxvn
# Usage  :
#
#   touch .git/skip.origin.branch1            # skip origin/branch1
#   touch .git/skip.origin.branch2            # skip origin/branch2
#   touch .git/skip.upstream                  # don't push to upstream
#   touch .git/skip._.private                 # skip private branch
#
#   git_push_to_all_remotes : branch3 branch4 # push current branch, branch3 and branch4
#   git_push_to_all_remotes : --force         # for a remote update
#
git_push_to_all_remotes() {
  local _args=
  local _brs=
  local _f_tmp=
  local _d_tmp="$(git rev-parse --show-toplevel)"

  while (( $# )); do
    if [[ "${1:0:1}" == "-" ]]; then
      _args="$_args $1"
      shift
    else
      _brs="$_brs $1"
    fi
    shift
  done

  _brs="${_brs:-:}"
  for _br in $_brs; do
    [[ "$_br" != ":" ]] || _br="$(git rev-parse --abbrev-ref HEAD)"
    git remote \
    | while read _remote; do
        for __file__ in \
          "$_d_tmp/.$_remote" \
          "$_d_tmp/.$_remote.$_br" \
          "$_d_tmp/_.$_br" \
          "$_d_tmp/.git/skip.$_remote" \
          "$_d_tmp/.git/skip.$_remote.$_br" \
          "$_d_tmp/.git/skip._.$_br" \
        ; do
          if [[ -f "$__file__" ]]; then
            echo >&2 ":: .git/${__file__##*/}"
            continue 2
          fi
        done
        git st | grep -q "Your branch is up-to-date with '$_remote/$_br'."
        if [[ $? -eq 0 ]]; then
          echo >&2 ":: '$_remote/$_br' is up-to-date"
        else
          echo >&2 ":: Pushing to '$_remote/$_br'..."
          git push $_args "$_remote" "$_br"
        fi
      done
  done
}

# Use *our* verion of conflict files
git_ours() {
  while (( $# )); do
    [[ -f "$1" ]] \
      && git checkout --ours "$1" \
      && git add "$1"
    shift
  done
}

# Use *their* verion of conflict files
git_theirs() {
  while (( $# )); do
    [[ -f "$1" ]] \
      && git checkout --theirs "$1" \
      && git add "$1"
    shift
  done
}

# Show list of conflict files
git_conflict() {
  git status -s $@ \
    | grep AA
}

# Print number of commits by user
git_count_author() {
  TS="$(date +%s)"
  git log --pretty=format:"%ae $TS %s" | awk -F " $TS " '{a[$0]+=1; if (a[$0]==1) {printf("%s\n", $1);}}' \
  | sort \
  | uniq -c \
  | sort -rn
}
