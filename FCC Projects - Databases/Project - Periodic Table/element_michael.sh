#!/bin/bash
PSQL="psql -U freecodecamp -d periodic_table -t --no-align -c"

# Input number
QUERY_NUMBER() {
  # Use atomic_number to query database
  QUERY_RESULT=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number = $INPUT;")
  if [[ -z $QUERY_RESULT ]];
  then
    echo "I could not find that element in the database."
  else
    # return query result
    echo $QUERY_RESULT | while IFS='|' read ATOMIC_NUMBER SYMBOL NAME TYPE ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
    done
  fi
}

# Input string
QUERY_STRING() {
  # Use symbol or name to query database
  QUERY_RESULT=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE symbol = '$INPUT' OR name = '$INPUT';")
  if [[ -z $QUERY_RESULT ]];
  then
    echo "I could not find that element in the database."
  else
    # return query result
    echo $QUERY_RESULT | while IFS='|' read ATOMIC_NUMBER SYMBOL NAME TYPE ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
    done
  fi
}


# Check if input argument provided is a string
if [[ $1 ]];
then
  INPUT=$1
  # Check if input matches pattern
  if [[ $INPUT =~ ^[0-9]+$ ]];
  then
    QUERY_NUMBER
  else
    QUERY_STRING
  fi
else
  echo "Please provide an element as an argument."
fi
