#!/bin/bash

## Script to read all KEGG reaction pages (pre-downloaded)
## and to extract relevant data:  
## Reaction number, name, definition, equation, EC class


for filename in *.rxn
do


  ## "Entry" field is just the filename without extension
  ##  Note: This requires that the filename does not contain a "."
  Entry=${filename%.*}


  ##  -------------------- "Name" field --------------------------------
  ##  NB: This will retrieve the first "Name" entry only (SOMETIMES THERE
  ##      ARE MULTIPLE ALTERNATIVES)
  ##  Get the line following the one that contains "<nobr>Name"
  Name=`sed -n '/<nobr>Name/{n;p;}' $filename  |  
  # get rid of the html tags
  sed 's/<[^<>]*>//g' `
  ##  -----------------------------------------------------------------


  ##  -------------------- "Definition" field --------------------------------
  ## Get the line following the one that contains "<nobr>Definition"
  Definition=`sed -n '/<nobr>Definition/{n;p;}' $filename  |  
  # get rid of the html tags
  sed 's/<[^<>]*>//g'  |  
  # get rid of html characters
  sed 's/&lt;/</g'`
  ##  -----------------------------------------------------------------


  ##  -------------------- "Equation" field --------------------------------
  # Get the line following the one that contains "<nobr>Equation"
  Equation=`sed -n '/<nobr>Equation/{n;p;}' $filename  |  
  # get rid of the html tags
  sed 's/<[^<>]*>//g'  |  
  # get rid of html characters
  sed 's/&lt;/</g'`
  ##  -----------------------------------------------------------------



  ###  --------  Get EC classes in "Enzyme" field  ------------------------ 
  string=""
  boolean="false"
  while IFS= read -r line
  do 
    # If in desired block, concactenate next line
    if [[ $boolean == true ]]; then
      string=$string$line
    fi

    # If end of block found, break process
    if [[ $line =~ \<\/tr\>  ]]; then
      boolean="false"
    fi

    # From this line on is the relevant block 
    if [[ $line =~ \<tr\>  &&  $line =~ Enzyme  ]]; then
      boolean="true"
    fi

  done <"$filename"

  EC=`echo $string  |  
  # Remove html tags and everything inbetween
  sed 's/<[^<>]*>//g'  |  
  # Remove the multiple html non-breaking spaces:  &nbsp;
  sed -r 's/(&nbsp;)+/, /g'`
  ## NB:
  ##   The (abc)+ matches any number of repeated occurrences of "abc"
  ##   and replaces it with a single instance of what you specify.
  ##   For this to work, MUST use -r option for extended regular expressions.
  ### ----------------------------------------------------------------


  ##   ---------  Get Comments -------------------------------------   
  ##
  ## NB: Comment can span multiple lines too ( => modify as above for EC)
  ##
  ## Get the line following the one that contains "<nobr>Comment"
  ## Comment=`sed -n '/<nobr>Comment/{n;p;}' $filename  |  
  ## get rid of the html tags
  ## sed 's/<[^<>]*>//g'`


  ## Print to file
  echo -e $Entry'\t'$Name'\t'$Definition'\t'$Equation'\t'$EC >> a_collate_output.rxns
  ##  (-e means 'enable interpretation of backslash escapes)


done
