#!/bin/bash
PSQL='psql -X -U freecodecamp -d salon --tuples-only -c'

# Build SERVICE_MENU
SERVICE_MENU()
{
  # Print out the error message when user input the wrong number
  if [[ $1 ]];
  then
    echo -e "\n$1"
  else
    echo -e '\n~~~~~ MY SALON ~~~~~\n'
    echo 'Welcome to my salon, how can I help you?'
  fi

  # Ask for user's input
  echo -e '\n1) cut\n2) color\n3) perm\n4) style\n5) trim'
  read SERVICE_ID_SELECTED

  # Get service name
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED;")
  echo $SERVICE_NAME

  # Direct to options
  case $SERVICE_ID_SELECTED in
    1) CUT_MENU ;;
    2) COLOR_MENU ;;
    3) PERM_MENU ;;
    4) STYLE_MENU ;;
    5) TRIM_MENU ;;
    *) SERVICE_MENU "I could not find that service. What would you like today?" ;;
  esac
}

# Build GET_customer_info function
GET_CUSTOMER_INFO() 
{
  local CUSTOMER_PHONE customer_id CUSTOMER_NAME
  # Ask for customer's phone number
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  echo $CUSTOMER_PHONE

  # Get customer id with their phone number
  customer_id=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE';")

  # if not found, ask for their name
  if [[ -z $customer_id ]];
  then
    # Get customer's name
    echo -e "\nI don't have a record for that phone number. What's your name?"
    read CUSTOMER_NAME
    echo $CUSTOMER_NAME

    # Insert into customers
    insert_customer=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME');")
    echo $insert_customer

    # Get new customer_id
    customer_id=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE';")
    echo $customer_id

  else
    # Get customer name
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE customer_id = $customer_id;")
    echo $CUSTOMER_NAME

  fi

  # direct to SET_APPOINTMENT function
  SET_APPOINTMENT
}  


# Build SET_APPOINTMENT function
SET_APPOINTMENT()
{
  local SERVICE_TIME
  # Ask for appointment time  
  echo -e "\nWhat time would you like your $(echo $SERVICE_NAME | sed 's/^ $//'), $(echo $CUSTOMER_NAME | sed 's/^ //')?"
  read SERVICE_TIME
  echo $SERVICE_TIME
  echo $customer_id
  
  # Insert into appointments table
  INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, time, service_id) VALUES($customer_id, '$SERVICE_TIME', $SERVICE_ID_SELECTED);")
  echo $INSERT_APPOINTMENT

  echo -e "\nI have put you down for a $(echo $SERVICE_NAME | sed 's/^ $//') at $SERVICE_TIME, $(echo $CUSTOMER_NAME | sed 's/^ //')"

  # send to SERVICE_MENU
  SERVICE_MENU
}  


# Build CUT_MENU
CUT_MENU()
{
  $(echo GET_CUSTOMER_INFO)
}


# Build COLOR_MENU
COLOR_MENU()
{
  $(echo GET_CUSTOMER_INFO)
}  


# Build PERM_MENU
PERM_MENU()
{
  $(echo GET_CUSTOMER_INFO)
}  


# Build STYLE_MENU
STYLE_MENU()
{
  $(echo GET_CUSTOMER_INFO)
}


# Build TRIM_MENU
TRIM_MENU()
{
  $(echo GET_CUSTOMER_INFO)
}


SERVICE_MENU