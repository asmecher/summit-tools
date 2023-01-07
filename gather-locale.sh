#!/bin/bash

REPO=$1
LOCALE=$2

for base in `sh list-bases.sh ../${REPO}/main`; do
	BASE=$base REPO=${REPO} posummit summit-config-shared ${LOCALE} gather --create --force
done
