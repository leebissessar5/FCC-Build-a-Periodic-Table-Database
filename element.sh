#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"

if [[ $1 ]]
then
  if [[ ! $1 =~ ^[0-9]+$ ]]
  then
  ELEMENT_RESULT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, 
  melting_point_celsius, boiling_point_celsius 
  FROM elements 
    INNER JOIN properties USING (atomic_number)
    INNER JOIN types USING (type_id)
  WHERE name='$1' OR symbol='$1'")
  else
    ELEMENT_RESULT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, 
  melting_point_celsius, boiling_point_celsius 
    FROM elements 
      INNER JOIN properties USING (atomic_number)
      INNER JOIN types USING (type_id)
    WHERE atomic_number=$1")
  fi
  
  if [[ -z $ELEMENT_RESULT ]]
    then
      echo "I could not find that element in the database."
    else
      echo $ELEMENT_RESULT | while IFS=\| read NUM NAME SYM TYPE MASS MELT BOIL
      do
        echo "The element with atomic number $NUM is $NAME ($SYM). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius." 
      done
  fi
else
  echo "Please provide an element as an argument."
fi