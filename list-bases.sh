#!/bin/bash

set -e

cd $1
git ls-files | grep -e "\/en_US\/[a-zA-Z]\+.po$" | xargs dirname | xargs dirname | sort | uniq
