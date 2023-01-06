#!/bin/bash

set -e

# Go through all locale files and apply the templates using msgmerge.
for FILE in `git ls-files | grep -e "\.po$" | cut -d "." -f 1`; do
	FILEDIR=`dirname $FILE`
	FILEBASE=`basename $FILE`
	msgmerge -q -N --previous --update $FILE.po $FILEDIR/../templates/$FILEBASE.pot
done
