#!/usr/bin/env bash

latexmk -interaction=nonstopmode -pdf

p() {
  rubber-info --$2 $3 | while read line; do
    echo $1:$line
  done
}

p CHECK check "*.tex"
p ERROR errors "*.tex"
p WARNING warnings "*.tex"
p BOXES boxes "*.tex"
