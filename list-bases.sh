#!/bin/bash

set -e

cd $1
git ls-files | grep -e "\/en\(_US\)\?\/[a-zA-Z]\+.po$" | xargs dirname | xargs dirname | sort | uniq
