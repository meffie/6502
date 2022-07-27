#!/bin/bash
# Proof of concept assembler.
a=0
loop=0
sed 's/;.*//' |
sed 's/  *$//' |
grep -v '^$' |
while read op arg; do
    s=0;
    case $op in
    loop:) loop=$a ;;
    lda) echo -n "a9${arg}"; s=2 ;;
    sta) echo -n "8d${arg:2:2}${arg:0:2}"; s=3 ;;
    nop) echo -n "ea"; s=1 ;;
    jmp) echo -n "4c$(printf "%02x" $loop)80"; s=3 ;;
    *) ;;
    esac
    a=$(expr $a + $s)
done
echo ""
