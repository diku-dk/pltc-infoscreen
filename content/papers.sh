#!/bin/sh

PAPERDIR=$(dirname $0)/../papers/

PAPER=$(find $PAPERDIR -name \*.pdf | sort -R | head -n 1)

echo "$PAPER"

zathura "$PAPER" -P 1
