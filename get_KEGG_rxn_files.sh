#!/bin/bash

## Script to retrieve the KEGG reaction pages for later parsing
## Reactions labelled Rxxxxx; xxxxx is padded number 00001, ... 

rxns=10

for ((i=1; i<=rxns; i++))
do
    # Create padded numbers and wget the KEGG rxn page
    r=`printf "%05d\n" $i`
    wget -q -O R$r.rxn http://www.kegg.jp/dbget-bin/www_bget?rn:R$r

    # Not all of these R numbers exist, e.g. 00003 does not.
    # All of these files will contain a line where it says "No such data."
    # Check for this and remove those files.
 
    ss=`grep "No such data." R$r.rxn`
    if [ -n "$ss" ]; then
    # the quotations around $ss are essential
    # -n operator checks if the string is "null"
        rm R$r.rxn
    fi

done


