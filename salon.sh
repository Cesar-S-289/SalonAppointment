#! /bin/bash


PSQL="psql --username=freecodecamp --dbname=salon -t --no-align  -c"

MAIN_MENU()
{
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
  SERVICES=$($PSQL "SELECT * FROM services") ;
  # Reescribir esto para saltarme unos registros al pedo
  echo "$SERVICES" |  sed 's/|/ /g' | while read SERVICE_ID SERVICE
  do 
    echo "$SERVICE_ID) $SERVICE"
  done

  read SERVICE_ID_SELECTED
  if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
  then
  MAIN_MENU "That isn't a number, please try again."
  else

    case $SERVICE_ID_SELECTED in
      1)DATE_MENU "1" "cut";;
      2)DATE_MENU "2" "color";;
      3)DATE_MENU "3" "trim";;
      *) MAIN_MENU "I could not find that service. What would you like today?"
    esac  
  fi

}

DATE_MENU()
{
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE

  EXIST_PHONE=$($PSQL "SELECT phone FROM customers WHERE phone='$CUSTOMER_PHONE'")
  if [[ -z $EXIST_PHONE ]]
  then
    echo -e "\nWhat's your name?"
    read CUSTOMER_NAME

    ADDING_CUSTOMER=$($PSQL "INSERT INTO customers(phone,name) VALUES('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  else 
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  fi

  echo -e "\nWhat time would you like your $2, $CUSTOMER_NAME?"
  read SERVICE_TIME
  ADD_TO_APPOINTMENT=$($PSQL "INSERT INTO appointments(service_id,time,customer_id) VALUES('$1','$SERVICE_TIME','$CUSTOMER_ID')")

  echo -e "\nI have put you down for a $2 at $SERVICE_TIME, $CUSTOMER_NAME."
}

echo -e "\n~~ My Salon ~~\n"
MAIN_MENU "Welcome to my salon, how can i help you?"
