#!/bin/bash

# Fetch appropriate webpage
wget -O http://www.genome.jp/kegg/catalog/org_list.html |

## Remove lines with empty entry (22/10/14 only one such case for organism "pstu")
sed "/&nbsp/d" org_list.txt | 

## Get relevant lines (containing organism 3/4-letter ID or full name)
sed -n -e '/show_organism?org=/p' -e '/<td align=left>/p' |

## Subtract unwanted text
sed -e "s/<td align=center><a href='\/kegg-bin\/show_organism?org=//g" -e "s/'>[a-z]*<\/a><\/td>//g" | 
sed -e "s/<td align=left><a href='\/dbget-bin\/www_bfind?T[0-9]*'>//g" -e "s/<\/a><\/td>//g" |
sed -e "s/<td align=left>//g" -e "s/<\/td>//g" |

## Remove leading spaces
sed "s/^ *//g" | 

## Now odd lines have organism IDs, even lines have full organism name
##   -- put these into single line for each organism:
paste - - -d"\t" > _output_.txt

