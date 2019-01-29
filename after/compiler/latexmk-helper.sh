#!/usr/bin/env bash

latexmk -interaction=nonstopmode -pdf > /dev/null 2>&1
rubber-info --errors *.tex
