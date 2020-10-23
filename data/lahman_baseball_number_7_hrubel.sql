SELECT teamid,
	w,
	yearid
FROM teams
WHERE yearid BETWEEN 1970 AND 2016
AND wswin = 'N'
GROUP BY teamid, yearid, w
ORDER BY w DESC
LIMIT 1;

SELECT teamid,
	w,
	yearid
FROM teams
WHERE yearid BETWEEN 1970 AND 2016
AND wswin = 'Y'
GROUP BY teamid, yearid, w
ORDER BY w DESC
LIMIT 1;

SELECT yearid,
	MAX(w)
FROM teams
WHERE yearid BETWEEN 1970 and 2016
AND wswin = 'Y'
GROUP BY yearid
INTERSECT
SELECT yearid,
	MAX(w)
FROM teams
WHERE yearid BETWEEN 1970 and 2016
GROUP BY yearid
ORDER BY yearid;

WITH ws_winners AS (SELECT yearid,
						MAX(w)
					FROM teams
					WHERE yearid BETWEEN 1970 and 2016
					AND wswin = 'Y'
					GROUP BY yearid
					INTERSECT
					SELECT yearid,
						MAX(w)
					FROM teams
					WHERE yearid BETWEEN 1970 and 2016
					GROUP BY yearid
					ORDER BY yearid)
SELECT (COUNT(ws.yearid)/COUNT(t.yearid)::float)*100 AS percentage
FROM teams as t LEFT JOIN ws_winners AS ws ON t.yearid = ws.yearid
WHERE t.wswin IS NOT NULL
AND t.yearid BETWEEN 1970 AND 2016;