#!/bin/bash

REPO=$1

for base in `sh list-bases.sh ../${REPO}/main`; do
	BASE=$base REPO=${REPO} posummit summit-config-shared templates gather --create
done
