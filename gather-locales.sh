#!/bin/bash

if [ -z "$1" ]; then
	echo "Usage: $0 [REPO]"
	echo "	Gather the locale files into the summit from the repository REPO."
	echo ""
	echo "  REPO is expected to be in one directory above this toolset in the directory tree."
	echo "  See https://github.com/asmecher/summit-tools for more information."
	exit 1
fi

REPO=$1

for base in `sh list-bases.sh ../${REPO}/main`; do
	for locale in `sh list-locales.sh ../${REPO}/main`; do
		BASE=$base REPO=${REPO} posummit summit-config-shared ${locale} gather --create --force
	done
done
