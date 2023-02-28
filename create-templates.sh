#!/bin/bash

set -e

# Determine which base directories contain locale files for which templates must be created.
BASEDIRS=`git ls-files | grep -e "\/en\(_US\)\?\/[a-zA-Z]\+.po$" | xargs dirname | xargs dirname | sort | uniq`
for BASEDIR in $BASEDIRS; do
	mkdir -p $BASEDIR/templates
	for FILE in $BASEDIR/en*/*.po; do
		FILENAME=`basename $FILE`
		msgfilter -i $FILE -o $BASEDIR/templates/${FILENAME}t true
	done
done
