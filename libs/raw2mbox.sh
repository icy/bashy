#!/bin/bash

# Purpose: Convert raw message (e.g, from Google Group) to mbox file
# Author : Anh K. Huynh
# Date   : 2014
# License: MIT

# Received: from icy.bar (l00s3r.theslinux.org [199.180.254.75]) by mx.zohomail.com
# 	with SMTPS id 1379761151703804.5943683273185; Sat, 21 Sep 2013 03:59:11 -0700 (PDT)
# Date: Sat, 21 Sep 2013 17:59:07 +0700
# From: "Anh K. Huynh" <ky...@archlinuxvn.org>
# To: archlinuxvn@googlegroups.com
#
raw2mbox() {
  awk '
    BEGIN {
      _headers[0] = ""
      _count = 0
      _ship = 0

      _date=""
      _from=""
    }

    {
      if ( match($0, /^Date: (.*)$/, gs) ) {
        _ship ++;
        _date = gs[1];
        _headers[++_count] = $0;
      }
      else if ( match($0, /^From:.*<([^<>]+)>$/, gs) ) {
        _ship ++;
        _from = gs[1];
        _headers[++_count] = $0;
      }
      else if (_ship < 2) {
        _headers[++_count] = $0;
      }
      else if (_ship == 2) {
        _ship ++;
        _headers[++_count] = $0;

        printf("From %s %s\n", _from, _date);
        for (i = 1; i <= _count; i ++) {
          printf("%s\n", _headers[i]);
        }
      }
      else if (_ship > 2) {
        print $0;
      }
    }

    END {
      if (_ship == 2) {
        printf(":: Possibly bad format.\n") > "/dev/stderr";
      }
    }
  '
}
