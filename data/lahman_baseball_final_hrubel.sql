/*1*/

Select Max(yearid), min(yearid)
From teams;

/*2*/

SELECT people.namegiven, people.height, teams.name AS team, appearances.g_all AS games_played
FROM people
JOIN appearances
ON people.playerid = appearances.playerid
JOIN teams
ON teams.teamid = appearances.teamid
ORDER BY height
LIMIT 1;

/*3*/

SELECT distinct concat(p.namefirst, ' ', p.namelast) as name, sc.schoolname,
  sum(sa.salary)
  OVER (partition by concat(p.namefirst, ' ', p.namelast))::numeric::money as total_salary
  FROM (people p JOIN collegeplaying cp ON p.playerid = cp.playerid)
  JOIN schools sc ON cp.schoolid = sc.schoolid
  JOIN salaries sa ON p.playerid = sa.playerid
  where cp.schoolid = 'vandy'
  group by name, schoolname, sa.salary, sa.yearid
  ORDER BY total_salary desc;
  
/*4*/

 SELECT
	CASE WHEN pos LIKE 'OF' THEN 'Outfield'
		WHEN pos LIKE 'C' THEN 'Battery'
		WHEN pos LIKE 'P' THEN 'Battery'
		ELSE 'Infield' END AS fielding_group,
	SUM(po) AS putouts
FROM fielding
WHERE yearid = 2016
GROUP BY fielding_group;

/*5*/

SELECT yearid/10 * 10 AS decade, 
	ROUND(((SUM(so)::float/SUM(g))::numeric), 2) AS avg_so_per_game,
	ROUND(((SUM(so)::float/SUM(ghome))::numeric), 2) AS avg_so_per_ghome
FROM teams
WHERE yearid >= 1920 
GROUP BY decade

/*mary's*/

WITH decades as (	
	SELECT 	generate_series(1920,2010,10) as low_b,
			generate_series(1929,2019,10) as high_b)
			
SELECT 	low_b as decade,
		--SUM(so) as strikeouts,
		--SUM(g)/2 as games,  -- used last 2 lines to check that each step adds correctly
		ROUND(SUM(so::numeric)/(sum(g::numeric)/2),2) as SO_per_game,  -- note divide by 2, since games are played by 2 teams
		ROUND(SUM(hr::numeric)/(sum(g::numeric)/2),2) as hr_per_game
FROM decades LEFT JOIN teams
	ON yearid BETWEEN low_b AND high_b
GROUP BY decade
ORDER BY decade;

/*6*/
 
 SELECT Concat(namefirst,' ',namelast), batting.yearid, ROUND(MAX(sb::decimal/(cs::decimal+sb::decimal))*100,2) as sb_success_percentage
FROM batting
INNER JOIN people on batting.playerid = people.playerid
WHERE yearid = '2016'
AND (sb+cs) >= 20
GROUP BY namefirst, namelast, batting.yearid
ORDER BY sb_success_percentage DESC
LIMIT 1;
 
/*7*/

SELECT DISTINCT p.park_name, h.team,
	(h.attendance/h.games) as avg_attendance, t.name		
FROM homegames as h JOIN parks as p ON h.park = p.park
LEFT JOIN teams as t on h.team = t.teamid AND t.yearid = h.year
WHERE year = 2016
AND games >= 10
ORDER BY avg_attendance DESC
LIMIT 5;

/*8*/



/*9*/
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
					
/*Mahesh*/
WITH mngr_list AS (SELECT playerid, awardid, COUNT(DISTINCT lgid) AS lg_count
				   FROM awardsmanagers
				   WHERE awardid = ‘TSN Manager of the Year’
				   		 AND lgid IN (‘NL’, ‘AL’)
				   GROUP BY playerid, awardid
				   HAVING COUNT(DISTINCT lgid) = 2),
	 mngr_full AS (SELECT playerid, awardid, lg_count, yearid, lgid
				   FROM mngr_list INNER JOIN awardsmanagers USING(playerid, awardid))
SELECT namegiven, namelast, name AS team_name
FROM mngr_full INNER JOIN people USING(playerid)
	 INNER JOIN managers USING(playerid, yearid, lgid)
	 INNER JOIN teams ON mngr_full.yearid = teams.yearid AND mngr_full.lgid = teams.lgid AND managers.teamid = teams.teamid
GROUP BY namegiven, namelast, name;

/*open-ended*/

