#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# if arg is empty
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
    # if arg is a number
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ELEMENT_ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $1")
    
  # if arg is string
  else
    ELEMENT_ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$1' OR name = '$1'")

  fi

  # if arg element is not in database
  if [[ -z $ELEMENT_ATOMIC_NUMBER ]]
  then
    echo "I could not find that element in the database."

  # get matching qualities
  else
    # symbol
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $ELEMENT_ATOMIC_NUMBER")
    
    # name
    ELEMENT_NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $ELEMENT_ATOMIC_NUMBER")
    
    # type
    ELEMENT_TYPE=$($PSQL "SELECT type FROM properties LEFT JOIN types USING(type_id) WHERE atomic_number = $ELEMENT_ATOMIC_NUMBER")
    
    # atomic mass
    ELEMENT_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $ELEMENT_ATOMIC_NUMBER")
    
    # melting point
    ELEMENT_MELTING=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $ELEMENT_ATOMIC_NUMBER")
    
    # boiling point
    ELEMENT_BOILING=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $ELEMENT_ATOMIC_NUMBER")
    
    #formatting message
    #The element with atomic number 1 is Hydrogen (H). It's a nonmetal, with a mass of 1.008 amu. Hydrogen has a melting point of -259.1 celsius and a boiling point of -252.9 celsius.
    echo "The element with atomic number $ELEMENT_ATOMIC_NUMBER is $ELEMENT_NAME ($SYMBOL). It's a $ELEMENT_TYPE, with a mass of $ELEMENT_MASS amu. $ELEMENT_NAME has a melting point of $ELEMENT_MELTING celsius and a boiling point of $ELEMENT_BOILING celsius."
  fi
  
fi
