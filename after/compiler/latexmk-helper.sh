#!/usr/bin/env bash

latexmk -interaction=nonstopmode -pdf $1

p() {
  rubber-info --$2 $3 | while read line; do
    echo $1:$line
  done
}

p CHECK check $1
p ERROR errors $1
p WARNING warnings $1
p BOXES boxes $1
