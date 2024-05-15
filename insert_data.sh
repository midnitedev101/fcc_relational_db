#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE TABLE games, teams;")
echo $($PSQL "ALTER SEQUENCE games_game_id_seq RESTART;")
echo $($PSQL "ALTER SEQUENCE teams_team_id_seq RESTART;")
echo $($PSQL "INSERT INTO teams (name) VALUES
('Algeria'),
('Argentina'),
('Belgium'),
('Brazil'),
('Chile'),
('Colombia'),
('Costa Rica'),
('Croatia'),
('Denmark'),
('England'),
('France'),
('Germany'),
('Greece'),
('Japan'),
('Mexico'),
('Netherlands'),
('Nigeria'),
('Portugal'),
('Russia'),
('Spain'),
('Sweden'),
('Switzerland'),
('United States'),
('Uruguay')")
echo $($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES
(2018,'Final',11,8,4,2),
(2018,'Third Place',3,10,2,0),
(2018,'Semi-Final',8,10,2,1),
(2018,'Semi-Final',11,3,1,0),
(2018,'Quarter-Final',8,19,3,2),
(2018,'Quarter-Final',10,21,2,0),
(2018,'Quarter-Final',3,4,2,1),
(2018,'Quarter-Final',11,24,2,0),
(2018,'Eighth-Final',10,6,2,1),
(2018,'Eighth-Final',21,22,1,0),
(2018,'Eighth-Final',3,14,3,2),
(2018,'Eighth-Final',4,15,2,0),
(2018,'Eighth-Final',8,9,2,1),
(2018,'Eighth-Final',19,20,2,1),
(2018,'Eighth-Final',24,18,2,1),
(2018,'Eighth-Final',11,2,4,3),
(2014,'Final',12,2,1,0),
(2014,'Third Place',16,4,3,0),
(2014,'Semi-Final',2,16,1,0),
(2014,'Semi-Final',12,4,7,1),
(2014,'Quarter-Final',16,7,1,0),
(2014,'Quarter-Final',2,3,1,0),
(2014,'Quarter-Final',4,6,2,1),
(2014,'Quarter-Final',12,11,1,0),
(2014,'Eighth-Final',4,5,2,1),
(2014,'Eighth-Final',6,24,2,0),
(2014,'Eighth-Final',11,17,2,0),
(2014,'Eighth-Final',12,1,2,1),
(2014,'Eighth-Final',16,15,2,1),
(2014,'Eighth-Final',7,13,2,1),
(2014,'Eighth-Final',2,22,1,0),
(2014,'Eighth-Final',3,23,2,1)
")

echo "Total number of goals in all games from winning teams:"
echo $($PSQL "SELECT SUM(winner_goals) FROM games;")

echo "Total number of goals in all games from both teams combined:"
echo $($PSQL "SELECT SUM(winner_goals + opponent_goals) FROM games;")

echo "Average number of goals in all games from the winning teams:"
echo $($PSQL "SELECT AVG(winner_goals) FROM games;")

echo "Average number of goals in all games from the winning teams rounded to two decimal places:"
echo $($PSQL "SELECT ROUND(AVG(winner_goals),2) FROM games;")

echo "Average number of goals in all games from both teams:"
echo $($PSQL "SELECT AVG(winner_goals + opponent_goals) FROM games;")

echo "Most goals scored in a single game by one team:"
echo $($PSQL "SELECT MAX(winner_goals) FROM games;")

echo "Number of games where the winning team scored more than two goals:"
echo $($PSQL "SELECT COUNT(winner_goals) FROM games WHERE winner_goals > 2;")

echo "Winner of the 2018 tournament team name:"
echo $($PSQL "SELECT t.name FROM teams t INNER JOIN games g ON g.winner_id = t.team_id WHERE g.year = 2018 AND g.round='Final';")

echo "List of teams who played in the 2014 'Eighth-Final' round:"
echo $($PSQL "SELECT DISTINCT(t.name) FROM teams t INNER JOIN games g ON g.winner_id = t.team_id OR g.opponent_id = t.team_id WHERE g.year = 2014 AND g.round='Eighth-Final' ORDER BY t.name ASC;")

echo "List of unique winning team names in the whole data set:"
echo $($PSQL "SELECT DISTINCT(t.name) FROM teams t INNER JOIN games g ON g.winner_id = t.team_id ORDER BY t.name ASC;")

echo "Year and team name of all the champions:"
echo $($PSQL "SELECT g.year, t.name FROM teams t INNER JOIN games g ON g.winner_id = t.team_id WHERE g.round='Final' ORDER BY t.name DESC;")

echo "List of teams that start with 'Co':"
echo $($PSQL "SELECT * FROM teams WHERE name LIKE 'Co%';")