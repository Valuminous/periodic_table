#!/bin/bash
#Retrieve periodic table information from db
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"
# get argument
  INPUT=$1
  #if no argument provided
  if [[ -z $1 ]]
  then
    echo "Please provide an element as an argument."
  #if argument provided  
  else
  # argument is made up of letters 
  if [[ ! $INPUT =~ ^[0-9]+$ ]]
  then
    ELEMENT=$(echo $($PSQL "SELECT atomic_number FROM elements WHERE symbol='$INPUT' OR name='$INPUT';") | sed 's/ //g')
    # argument is made up of numbers 
  else
    ELEMENT=$(echo $($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$INPUT;") | sed 's/ //g')
  fi
  # argument does not exist
  if [[ -z $ELEMENT ]]
  then
    echo "I could not find that element in the database."
  # argument exists  
  else
    TYPE_ID=$(echo $($PSQL "SELECT type_id FROM properties WHERE atomic_number=$ELEMENT;") | sed 's/ //g')
    NAME=$(echo $($PSQL "SELECT name FROM elements WHERE atomic_number=$ELEMENT;") | sed 's/ //g')
    SYMBOL=$(echo $($PSQL "SELECT symbol FROM elements WHERE atomic_number=$ELEMENT;") | sed 's/ //g')
    ATOMIC_MASS=$(echo $($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ELEMENT;") | sed 's/ //g')
    MELTING_POINT_CELSIUS=$(echo $($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ELEMENT;") | sed 's/ //g')
    BOILING_POINT_CELSIUS=$(echo $($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ELEMENT;") | sed 's/ //g')
    TYPE=$(echo $($PSQL "SELECT type FROM elements LEFT JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE atomic_number=$ELEMENT;") | sed 's/ //g')

    echo "The element with atomic number $ELEMENT is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
  fi
fi



