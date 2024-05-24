property_match() {
  $PSQL "SELECT E.*, P.*, T.* FROM elements E INNER JOIN properties P ON E.atomic_number = P.atomic_number INNER JOIN types T ON T.type_id = P.type_id WHERE P.atomic_number = '$1' LIMIT 1" | while read -a Property ; do
    if [[ ${Property} ]]; then
      echo "The element with atomic number ${Property[0]} is ${Property[4]} (${Property[2]}). It's a ${Property[18]}, with a mass of ${Property[8]} amu. ${Property[4]} has a melting point of ${Property[10]} celsius and a boiling point of ${Property[12]} celsius."
    else
     echo "I could not find that element in the database."
    fi
    break
  done
}

symbol_match() {
  $PSQL "SELECT E.*, P.*, T.* FROM elements E INNER JOIN properties P ON E.atomic_number = P.atomic_number INNER JOIN types T ON T.type_id = P.type_id WHERE E.symbol = '$1' LIMIT 1" | while read -a Property ; do
    if [[ ${Property} ]]; then
      echo "The element with atomic number ${Property[0]} is ${Property[4]} (${Property[2]}). It's a ${Property[18]}, with a mass of ${Property[8]} amu. ${Property[4]} has a melting point of ${Property[10]} celsius and a boiling point of ${Property[12]} celsius."
    else
      echo "I could not find that element in the database."
    fi
    break
  done
}

word_match() {
  $PSQL "SELECT E.*, P.*, T.* FROM elements E INNER JOIN properties P ON E.atomic_number = P.atomic_number INNER JOIN types T ON T.type_id = P.type_id WHERE E.name = '$1' LIMIT 1" | while read -a Property ; do
    if [[ ${Property} ]]; then
      echo "The element with atomic number ${Property[0]} is ${Property[4]} (${Property[2]}). It's a ${Property[18]}, with a mass of ${Property[8]} amu. ${Property[4]} has a melting point of ${Property[10]} celsius and a boiling point of ${Property[12]} celsius."
    else
      echo "I could not find that element in the database."
    fi
    break
  done
}

check_value() {
  atomic_number="^[0-9]+$"
  symbol="^[A-Z]{1}([a-z]{1})?$"
  word="^[a-zA-Z]+$"
  if [[ $1 =~ $atomic_number ]]; then
    # echo "property_match"
    property_match $1
  elif [[ $1 =~ $symbol ]]; then
    # echo "symbol_match"
    symbol_match $1
  elif [[ $1 =~ $word ]]; then
    # echo "word_match"
    word_match $1
  else
    echo "I could not find that element in the database."
  fi
}

if [[ $# -eq 0 ]]; then
  echo "Please provide an element as an argument."
else
  PSQL="psql --username=postgres --dbname=periodic_table -tc"
  check_value $1
fi