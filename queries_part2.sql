```looking at top defense Buffalo for 2022 who ended the season with least allowed yards```
SELECT t.nflId, p.position, p.displayName, 
       SUM(t.tackle) AS total_tackle, 
       SUM(t.true_assist) AS tot_assist, 
       SUM(t.forcedFumble) AS tot_force, 
       SUM(t.pff_missedTackle) AS tot_wif,
       SUM(t.tackle) +
       (SUM(t.true_assist) * 0.5) +
       (SUM(t.forcedFumble) * 1.32) -
       (SUM(t.pff_missedTackle) * 4.4) AS true_total
FROM tackles AS t
JOIN plays AS pl ON pl.playId = t.playId AND pl.defensiveTeam = 'BUF'
JOIN players AS p ON p.nflId = t.nflId
GROUP BY t.nflId, p.position, p.displayName
ORDER BY true_total DESC;


``` top 3 tacklers ```


```Tremaine Edmunds (nflId = 46085), Taron Johnson (nflId = 46190), Damar Hamlin (nflId = 53641)```
SELECT gameId, playId, AVG(s) as avg_speed, AVG(a) as avg_accel, SUM(dis) as tot_distance
FROM (
  SELECT * FROM tracking_1
  UNION ALL
  SELECT * FROM tracking_2
  UNION ALL
  SELECT * FROM tracking_3
  UNION ALL
  SELECT * FROM tracking_4
  UNION ALL
  SELECT * FROM tracking_5
  UNION ALL
  SELECT * FROM tracking_6
  UNION ALL
  SELECT * FROM tracking_7
  UNION ALL
  SELECT * FROM tracking_8
  UNION ALL
  SELECT * FROM tracking_9
) AS combine_tracking
WHERE nflId = 46085 
  AND playId IN (SELECT playId FROM tackles WHERE nflId = 46085 AND tackle = 1)
GROUP BY gameID, playID
ORDER BY gameID asc;




``` Nick Bolton 53487 apparantley the most productive tackler according to new metric```



``` Total team tackle one game```
SELECT
       SUM(t.tackle) AS total_tackle, 
       SUM(t.true_assist) AS tot_assist, 
       SUM(t.forcedFumble) AS tot_force, 
       SUM(t.pff_missedTackle) AS tot_wif,
       (SUM(t.tackle) +
       (SUM(t.true_assist) * 0.5) +
       (SUM(t.forcedFumble) * 1.32) -
       (SUM(t.pff_missedTackle) * 4.4)) /
	   (SELECT COUNT(*) FROM plays WHERE defensiveTeam = 'KC' AND gameId = 2022091500) AS true_total
FROM tackles AS t
WHERE gameId = 2022091500
	AND playId IN (SELECT playId FROM plays WHERE defensiveTeam = 'KC')
ORDER BY true_total DESC;




SELECT
    SUM(t.tackle) AS total_tackle,
    SUM(t.true_assist) AS tot_assist,
    SUM(t.forcedFumble) AS tot_force,
    SUM(t.pff_missedTackle) AS tot_wif,
    (SUM(t.tackle) + (SUM(t.true_assist) * 0.5) + (SUM(t.forcedFumble) * 1.32) - (SUM(t.pff_missedTackle) * 4.4)) / (SUM(t.tackle) + SUM(t.true_assist)) * 100 AS true_total
FROM tackles AS t
JOIN plays AS p ON t.gameId = p.gameId AND t.playId = p.playId
WHERE p.defensiveTeam = 'buf'
ORDER BY true_total DESC;