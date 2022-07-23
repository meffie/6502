#!/bin/bash
# proof of concept assembler.
sed 's/;.*//' |
sed 's/  *$//' |
grep -v '^$' |
while read op arg; do
    case $op in
    lda) echo -n "a9${arg}" ;;
    sta) echo -n "8d${arg:2:2}${arg:0:2}" ;;
    nop) echo -n "ea" ;;
    jmp) echo -n "4c????" ;;
    *) ;;
    esac
done
echo ""
