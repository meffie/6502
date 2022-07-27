#!/bin/bash
# Proof of concept assembler.
sed 's/;.*//' |
sed 's/  *$//' |
grep -v '^$' |
while read op arg; do
    echo "$op  $arg"
done
