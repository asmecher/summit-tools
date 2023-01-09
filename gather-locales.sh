#!/bin/bash

REPO=$1

for base in `sh list-bases.sh ../${REPO}/main`; do
	for locale in `sh list-locales.sh ../${REPO}/main`; do
		BASE=$base REPO=${REPO} posummit summit-config-shared ${locale} gather --create --force
	done
done
