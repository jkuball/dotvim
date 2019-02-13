#!/usr/bin/env bash

if [[ ! -z "`dirname $1`" ]]; then
  cd `dirname $1`
fi

latexmk -interaction=nonstopmode -pdf `basename $1` > /dev/null 2>&1
rubber-info --errors *.tex
rubber-info --warnings *.tex
