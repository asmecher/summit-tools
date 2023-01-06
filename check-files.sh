#!/bin/bash

set -e

# Go through all locale files and check them using msgfmt.
for FILE in `git ls-files | grep -e "\.po$"`; do
	pofilter -t blank --progress none $FILE > /dev/null
done

