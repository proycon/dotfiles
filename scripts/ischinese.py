#!/usr/bin/env python

import sys

"""Tests if a text is in chinese characters"""

line = sys.stdin.readline()
if len(line) <= 6 and all(
    ((c > u'\u4e00' and c < u'\u9fff') or (c > u'\u3000' and c < u'\u303f')) for c in line.strip()
   ):
    exit(0)
else:
    exit(1)


