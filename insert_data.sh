#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# Clear previously entered data
echo $($PSQL "TRUNCATE games,teams;")

# Insert full games data
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  # Check if first line is not header titles
  if [[ $YEAR != year ]] 
  then

  # Teams data
      # Insert winner
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")

      # If winner doesn't exist
      if [[ -z $WINNER_ID ]]
      then
        INSERT_WINNER=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER');")

        # Get newly inserted winner team_id
        WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
      fi
      
      # Insert opponent
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")
      
      # If opponent doesn't exist
      if [[ -z $OPPONENT_ID ]]
      then
        INSERT_OPPONENT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT');")

        # Get newly inserted opponent team_id
        OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")
      fi
      
  # Games data
      
      # Insert game data
      INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', '$WINNER_ID', '$OPPONENT_ID', $WINNER_GOALS, $OPPONENT_GOALS);")

  fi

done
