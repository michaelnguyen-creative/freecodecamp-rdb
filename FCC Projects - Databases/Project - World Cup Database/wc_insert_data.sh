#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# remove all data from teams and games
echo $($PSQL "TRUNCATE teams, games")

# insert data into teams table
cat games.csv | while IFS=',' read year round winner opponent winner_goals opponent_goals
do
   # check if the value entered is just a title
   if [[ $winner != "winner" ]];
   then
      # get team_id
      TEAM_ID=$($PSQL "SELECT team_id from teams WHERE name='$winner' AND name='$opponent'")
      # if not found
      if [[ -z $TEAM_ID ]];
      then
         # insert WINNER into name
         INSERT_WINNER=$($PSQL "INSERT INTO teams(name) VALUES('$winner') ON CONFLICT DO NOTHING")
         if [[ $INSERT_WINNER == "INSERT 0 1" ]]
         then
            echo Inserted into teams, $winner
         fi
         # insert opponent
         INSERT_OPPONENT=$($PSQL "INSERT INTO teams(name) VALUES('$opponent') ON CONFLICT DO NOTHING")
         if [[ $INSERT_OPPONENT == "INSERT 0 1" ]]
         then
            echo Inserted into teams, $opponent
         fi
         # get new team_id   
         TEAM_ID=$($PSQL "SELECT team_id from teams WHERE name='$winner' AND name='$opponent'")
      fi
   fi
done


# insert data from games.csv into games table
cat games.csv | while IFS=',' read year round winner opponent winner_goals opponent_goals
do
   if [[ $year != "year" ]];
   then
      # get winner_id
      TEAM_ID_WINNER=$($PSQL "SELECT team_id FROM teams WHERE name='$winner'")
      # get opponent_id
      TEAM_ID_OPPONENT=$($PSQL "SELECT team_id FROM teams WHERE name='$opponent'")
      # insert into games
      INSERT_GAMES=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES('$year', '$round', '$TEAM_ID_WINNER', '$TEAM_ID_OPPONENT', '$winner_goals', '$opponent_goals')")
      if [[ $INSERT_GAMES == "INSERT 0 1" ]];
      then
         echo Inserted into games, $year : $round : $TEAM_ID_WINNER : $TEAM_ID_OPPONENT : $winner_goals : $opponent_goals
      fi
   fi   
done