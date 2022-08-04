#!/bin/bash

PSQL="psql -U freecodecamp -d number_game -t --no-align -c"

# Take username input
echo -e "\nEnter your username:"
read INPUT_USER

# Get user info
GET_USER=$($PSQL "SELECT username, game_played, best_game FROM users WHERE username = '$INPUT_USER';")
# Check if returns result
if [[ $GET_USER ]];
then
    echo $GET_USER | while IFS='|' read USERNAME GAME_PLAYED BEST_GAME
    do
        echo -e "\nWelcome back, $USERNAME! You have played $GAME_PLAYED games, and your best game took $BEST_GAME guesses."
    done
else
    # Display message & insert into database
    echo -e "\nWelcome, $INPUT_USER! It looks like this is your first time here."
    INSERT_USER=$($PSQL "INSERT INTO users(username) VALUES('$INPUT_USER');")

    # test: insert user
    #echo $INSERT_USER
fi



# Generate a random secret number
SECRET_NUMBER=$(( 1 + $RANDOM % 1000))

# test: secret numer output
#echo $SECRET_NUMBER



# Build a function that compares guess number against the secret number
GUESS_VALID() {
    # Increment count for each guess
    (( GUESS_COUNT += 1 ))

    # test: count
    #echo $GUESS_COUNT

    # Check if guess is correct
    if [[ $INPUT_GUESS = $SECRET_NUMBER ]];
    then 
        # Insert game result into database
        INSERT_GAME=$($PSQL "INSERT INTO games(secret_number, number_of_guesses, username) VALUES($SECRET_NUMBER, $GUESS_COUNT, '$INPUT_USER');")

        # return game result message 
        echo -e "\nYou guessed it in $GUESS_COUNT tries. The secret number was $SECRET_NUMBER. Nice job!"

        # Insert into users
        INSERT_USERS

        # Exit the program
        exit
    fi

    # Check if guess is higher
    if [[ $INPUT_GUESS -gt $SECRET_NUMBER ]];
    then
        # Display guess result
        echo -e "\nIt's lower than that, guess again:"

        # Take input for another guess
        read INPUT_GUESS

        # Test if input guess is valid
        TEST_INPUT
    fi

    # Check if guess is lower
    if [[ $INPUT_GUESS -lt $SECRET_NUMBER ]];
    then
        # Display guess result
        echo -e "\nIt's higher than that, guess again:"

        # Take input for another guess
        read INPUT_GUESS

        # Test if input guess is valid
        TEST_INPUT
    fi
}

# Function that turns error message when user inputs the wrong type
GUESS_INVALID() {
  echo -e "\nThat is not an integer, guess again:"
  read INPUT_GUESS
  # Test input
  TEST_INPUT
}

# Test function for user input
TEST_INPUT() {
    if [[ $INPUT_GUESS =~ ^[0-9]+++$ ]];
    then
        GUESS_VALID
    else
        GUESS_INVALID    
    fi
}

# Insert into users
INSERT_USERS() {
    # Get info on game played
    COUNT_GAME=$($PSQL "SELECT COUNT(game_id) FROM games WHERE username = '$INPUT_USER';")
    #echo $COUNT_GAME
    
    # Get info on best games
    MIN_GAME=$($PSQL "SELECT MIN(number_of_guesses) FROM games WHERE username = '$INPUT_USER';")
    #echo $MIN_GAME

    # Update user's info
    UPDATE_USERS=$($PSQL "UPDATE users SET (game_played, best_game) = ($COUNT_GAME, $MIN_GAME) WHERE username = '$INPUT_USER';")
    
    # test: insert users
    #echo $INSERT_USERS
}



# Set count
GUESS_COUNT=0

# Ask user input for guess number
echo -e "\nGuess the secret number between 1 and 1000:"
read INPUT_GUESS

# check if guess number input is valid
TEST_INPUT
