#!/bin/sh

PAPERDIR=papers/

PAPER=$(find $PAPERDIR -name \*.pdf | sort -R | head -n 1)

echo "$PAPER"

zathura "$PAPER" -P 1
