#!/usr/bin/env python3
import os, sys
if len(sys.argv) < 2:
	path = '.'
else:
	path = sys.argv[1]

# TODO: Check if path exists
print(os.path.realpath(path))

