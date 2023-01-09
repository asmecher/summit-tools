#!/bin/bash

set -e

cd $1
git ls-files locale/*/*.po | xargs dirname | xargs -n 1 basename | sort | uniq
