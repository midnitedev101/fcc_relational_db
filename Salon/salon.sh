#! /bin/bash
echo -e "~~~~~ MY SALON ~~~~~\n"
echo -e "Welcome to My Salon, how can I help you?\n"
# PSQL="psql --username=freecodecamp --dbname=salon -c"
# services=$($PSQL "SELECT * FROM services")
# PSQL="psql --username=freecodecamp --dbname=salon -AXqtc"
# services=$($PSQL "SELECT service_id, name FROM services")
# services=$(echo "$services" | sed -e '/---+---+/d')
# for service in $services; do
#   echo "${service}"
#   # echo -e ${service[service_id]}\) ${service[name]}
# done

# echo 'select * from services;' | psql -t --username=freecodecamp --dbname=salon
# services=`psql -t --username=freecodecamp --dbname=salon -AXqtc "select * from services;"`
# for service in $services; do
#   echo ${service}
#   # echo -e ${service[service_id]}\) ${service[name]}
# done

present_service() {
psql --username=freecodecamp --dbname=salon -tc "select * from services;" | while read -a Record ; do
    if [ "$Record" ]; then  # check if not newline (statement returns last part of returned results as empty line)
      echo ${Record[0]}\) ${Record[2]}
    fi
done
}

choose_service() {
  read SERVICE_ID_SELECTED;
  count=$(psql --username=freecodecamp --dbname=salon -tc "SELECT COUNT(*) FROM services;")
  # echo "$SERVICE_ID_SELECTED > $count"
  if [[ $SERVICE_ID_SELECTED -gt $count || $SERVICE_ID_SELECTED -lt 1 ]]; then
    echo "I could not find that service. What would you like today?"
    instructions
  else 
    service=$(psql --username=freecodecamp --dbname=salon -tc "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED;")
    get_info $service $SERVICE_ID_SELECTED
  fi
  # psql -t --username=freecodecamp --dbname=salon -tc "select service_id from services GROUP BY service_id;" | while read -a Record ; do
  #   if [[ $service == ${Record[0]} ]]; then  # check if not newline (statement returns last part of returned results as empty line)
  #     echo $service is matched.
  #   fi
  # done
}

get_info() {
  echo "What's your phone number?"
  read CUSTOMER_PHONE
  customer_exists=$(psql --username=freecodecamp --dbname=salon -tc "select DISTINCT customer_id, name from customers WHERE phone='$CUSTOMER_PHONE' LIMIT 1;")
  if [[ ${customer_exists} ]] ; then

    IFS=', ' read -r -a cu <<< "${customer_exists}" # store customer_exists string result into cu (array of separated values)

    echo "What time would you like your $1, ${cu[2]}?"
    read SERVICE_TIME
    psql --username=freecodecamp --dbname=salon -tc "INSERT INTO appointments (customer_id, service_id, time) VALUES ('${cu[0]}', '$2','$SERVICE_TIME');"
    echo "I have put you down for a $1 at $SERVICE_TIME, ${cu[2]}."
  else
    echo "I don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    psql --username=freecodecamp --dbname=salon -tc "INSERT INTO customers (name, phone) VALUES ('$CUSTOMER_NAME','$CUSTOMER_PHONE');"
    customer_info=$(psql --username=freecodecamp --dbname=salon -tc "select DISTINCT customer_id, name from customers WHERE phone='$CUSTOMER_PHONE' LIMIT 1;")
    IFS=', ' read -r -a cu <<< "${customer_info}" # store customer_info string result into cu (array of separated values)
    echo "What time would you like your $1, ${cu[2]}?"
    read SERVICE_TIME
    psql --username=freecodecamp --dbname=salon -tc "INSERT INTO appointments (customer_id, service_id, time) VALUES ('${cu[0]}','$2','$SERVICE_TIME');"
    echo "I have put you down for a $1 at $SERVICE_TIME, ${cu[2]}."
  fi
}

instructions() {
  present_service
  choose_service
}

instructions