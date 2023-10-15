```
# Query to Get Total tackles and avg distance per tackle by position (in one game and one team)
```

SELECT p.position, SUM(t.total_tackle) AS total_tackle, AVG(tc.avg_distance) AS avg_distance
FROM (
  SELECT nflId, SUM(tackle + 0.5 * assist) AS total_tackle
  FROM tackles
  WHERE gameId = 2022090800
    AND playId IN (SELECT playId FROM plays_cleaned WHERE defensiveTeam = 'BUF')
  GROUP BY nflId
) AS t
JOIN (
  SELECT nflId, AVG(dis) AS avg_distance
  FROM tracking_1_clean
  WHERE playId IN (SELECT playId FROM plays_cleaned WHERE defensiveTeam = 'BUF')
  GROUP BY nflId
) AS tc ON t.nflId = tc.nflId
JOIN players p ON t.nflId = p.nflId
GROUP BY p.position
ORDER BY total_tackle DESC;


```
# Query to Get Total tackles and avg distance per tackle by player (in one game and one team)
```

SELECT t.nflId, p.position, t.total_tackle, tc.avg_distance
FROM (
  SELECT nflId, SUM(tackle + 0.5 * assist) AS total_tackle
  FROM tackles
  WHERE gameId = 2022090800
    AND playId IN (SELECT playId FROM plays_cleaned WHERE defensiveTeam = 'BUF')
  GROUP BY nflId
) AS t
JOIN (
  SELECT nflId, AVG(dis) AS avg_distance
  FROM tracking_1_clean
  WHERE playId IN (SELECT playId FROM plays_cleaned WHERE defensiveTeam = 'BUF')
  GROUP BY nflId
) AS tc ON t.nflId = tc.nflId
JOIN players p ON t.nflId = p.nflId
ORDER BY t.total_tackle DESC;


```
# Query to Get Total tackles, forced fumbles, missed tackles and avg distance per tackle by team defense
```

SELECT SUM(total_tackle) AS tot_tackle, SUM(t.pff_missedTackle) AS total_missed, SUM(t.forcedFumble) AS total_forced, AVG(avg_distance) AS avg_avg_distance
FROM (
  SELECT nflId, SUM(tackle + 0.5 * assist) AS total_tackle, pff_missedTackle, forcedFumble
  FROM tackles
  WHERE gameId = 2022090800
    AND playId IN (SELECT playId FROM plays_cleaned WHERE defensiveTeam = 'BUF')
  GROUP BY nflId, pff_missedTackle, forcedFumble
) AS t
JOIN (
  SELECT nflId, AVG(dis) AS avg_distance
  FROM tracking_1_clean
  WHERE playId IN (SELECT playId FROM plays_cleaned WHERE defensiveTeam = 'BUF')
  GROUP BY nflId
) AS tc ON t.nflId = tc.nflId
JOIN players p ON t.nflId = p.nflId;


(tot_tackle - weighted_missed_tackle + weighted_forced_fumble) * avg_distance


weighted_missed_tackle: to get the weight of missed tackles find the avg yards given up for a missed tackle (every 10 yards means 4 missed tackles)

    - Example: if avg yards given up per missed tackle is 15 then thats 6 tackles lost for every one missed tackle. So you'd multiply your total missed by 6 tackles.


weighted_forced_fumble: to get the weight of a forced fumble find the average amount of turnovers it creates and multiply that by 4 and multiply that by the amount of forced fumbles. (turnover = 4 made tackles)
    - Example: if a forced fumble results in an avg of .5 turnovers that's 2 extra tackles per forced fumble. So for every forced fumble that's two extra tackles.