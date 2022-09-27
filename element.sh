#!/bin/bash
PSQL="psql --username=freecodecamp dbname=periodic_table --tuples-only -c";
  
  if [[ $# -eq 0 ]]
  then 
    echo  "Please provide an element as an argument."
  else
    ELEMENT_INPUT="$1"
    #checck if input is a number
    if [[ $ELEMENT_INPUT =~ ^[0-9]+$ ]]
    then
      #chceck if input is an existing atomic number
      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$ELEMENT_INPUT;")          
      ELEMENT_DATA=$($PSQL "SELECT atomic_number, name, symbol, atomic_mass, melting_point_celsius, boiling_point_celsius, type  FROM properties INNER JOIN elements USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number=$ELEMENT_INPUT;")      
      #echo "$ELEMENT_DATA"
    else
      #check for existing atomic_number related to ELEMENT_INPUT
      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name='$ELEMENT_INPUT' OR symbol='$ELEMENT_INPUT';")          
      ELEMENT_DATA=$($PSQL "SELECT atomic_number, name, symbol, atomic_mass, melting_point_celsius, boiling_point_celsius, type  FROM properties INNER JOIN elements USING(atomic_number) INNER JOIN types USING(type_id) WHERE name='$ELEMENT_INPUT' OR symbol='$ELEMENT_INPUT'")     
      #echo "$ELEMENT_DATA"
    fi
    #check if ATOMIC_NUMBER is empty
    if [[ -z $ATOMIC_NUMBER ]]
    then echo  "I could not find that element in the database."
    else
      echo "$ELEMENT_DATA" | while IFS="\|" read ATOMIC_N NAME SYMBOL AT_MASS M_P_C B_P_C TYPE   
      do
        #echo $ATOMIC_N $NAME $SYMBOL $AT_MASS $M_P_C $B_P_C $TYPE
        echo "The element with atomic number $(echo $ATOMIC_N | sed -r 's/^ *| *$//g' ) is $(echo $NAME | sed -r 's/^ *| *$//g' ) ($(echo $SYMBOL | sed -r 's/^ *| *$//g' )). It's a $(echo $TYPE | sed -r 's/^ *| *$//g' ), with a mass of $(echo $AT_MASS | sed -r 's/^ *| *$//g' ) amu. $(echo $NAME | sed -r 's/^ *| *$//g' ) has a melting point of $(echo $M_P_C | sed -r 's/^ *| *$//g' ) celsius and a boiling point of $(echo $B_P_C | sed -r 's/^ *| *$//g' ) celsius."
      done
    fi
  fi    
  
 





