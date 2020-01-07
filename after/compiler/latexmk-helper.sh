#!/usr/bin/env bash

# Build the tex file(s) quietly
if [[ -f "Makefile" ]]; then
  make > /dev/null 2>&1
else
  latexmk -cd -interaction=nonstopmode -pdf "$1" > /dev/null 2>&1
fi

# Find whether a file has a tex root specified and use it
TEX_ROOT=`head -n 1 $1 | grep '%!TEX root' | cut -d= -f2 | tr -d ' '`
if [ -z "$TEX_ROOT" ]; then
  cd `dirname $1`
  rubber-info --check `basename $1`
  # rubber-info --errors `basename $1`
  # rubber-info --warnings `basename $1`
else
  rubber-info --check `basename $TEX_ROOT`
  # rubber-info --errors `basename $TEX_ROOT`
  # rubber-info --warnings `basename $TEX_ROOT`
fi

