#!/usr/bin/env bash

if [[ -f "Makefile" ]]; then
  make > /dev/null 2>&1 # Use a Makefile if present
else
  latexmk -cd -interaction=nonstopmode -pdf `basename $1` > /dev/null 2>&1
fi
rubber-info --errors *.tex
rubber-info --warnings *.tex
