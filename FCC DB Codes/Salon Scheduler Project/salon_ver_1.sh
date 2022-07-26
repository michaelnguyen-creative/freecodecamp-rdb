#!/bin/bash
PSQL='psql -U freecodecamp -d salon'

# Build welcome page
echo -e '\n~~~~~ MY SALON ~~~~~\n'
echo 'Welcome to my salon, how can I help you?'
echo -e '\n1) cut\n2) color\n3) perm\n4) style\n5) trim'

# Build SERVICE_MENU
SERVICE_MENU()
{
  # Ask for user's input
  echo -e '\nWhich service would you like to have?'
  read SERVICE

  # Direct to options
  case $SERVICE in
    1) CUT_MENU ;;
    2) COLOR_MENU ;;
    3) PERM_MENU ;;
    4) STYLE_MENU ;;
    5) TRIM_MENU ;;
    *) SERVICE_MENU "I could not find that service. What would you like today?"
  esac

}  

# Build CUT_MENU
CUT_MENU()
{
  # Ask for customer's phone number
  echo -e "\nWhat's your phone number?"
  read PHONE_NUMBER

  # Get customer_id with their phone number
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$PHONE_NUMBER';")

  # if not found, ask for their name
  if [[ -z $CUSTOMER_ID ]];
  then
    # Get customer's name
    echo -e "\nI don't have a record for that phone number. What's your name?"
    read CUSTOMER_NAME

    # Create a new record for the customer with their provided name & phone number
    INSERT_CUSTOMER=$($PSQL "INSERT INTO customers(phone, name) VALUES('$PHONE_NUMBER', '$CUSTOMER_NAME');")

  else
    # Get customer's name
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE customer_id = '$CUSTOMER_ID';")
    # Ask for appointment time  
    echo -e "\nWhat time would you like your haircut, '$CUSTOMER_NAME'?"
    read TIME

    # Insert appointment info into appointments table (customer_id, time)

  fi
  

}  

# Build COLOR_MENU

# Build PERM_MENU

# Build STYLE_MENU

