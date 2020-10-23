/*in work*/
WITH award_winners AS (SELECT DISTINCT(a1.playerid), a1.awardid, a1. yearid AS yearid, a1.lgid, a2.lgid
					FROM awardsmanagers as a1 INNER JOIN awardsmanagers as a2
					USING(playerid)
					WHERE a1.awardid LIKE '%TSN%'
					AND a1.lgid LIKE 'NL'
					AND a2.lgid LIKE 'AL'),
	managers_info AS (SELECT CONCAT(people.namefirst ,' ', people.namelast)as managers_names, playerid
					FROM people) 
SELECT DISTINCT(managers_info.managers_names), teams.name AS team_name
					FROM managers_info 
					JOIN award_winners 
					ON managers_info.playerid = award_winners.playerid
					JOIN appearances
					ON award_winners.playerid = appearances.playerid
					JOIN teams
					ON teams.teamid = appearances.teamid
					WHERE teams.yearid = award_winners.yearid;

					   
