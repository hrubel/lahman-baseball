/*2*/
SELECT people.namegiven, people.height, teams.name AS team, teams.g AS games_played
FROM people
JOIN appearances
ON people.playerid = appearances.playerid
JOIN teams
ON teams.teamid = appearances.teamid
ORDER BY height
LIMIT 1;