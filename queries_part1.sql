
```
weighted_missed = (1.1 * 4) * total_missed

weighted_forced = (0.333 * 4) * total_forced

tackle_eff = (tot_tackle - weighted_missed + weighted_forced) * avg_distance

true_total = total_tackle + (tot_assist *0.5) + (tot_force * 0.33) - (tot_wif *4.4)
```

```
weighted_missed_tackle: to get the weight of missed tackles find the avg yards given up for a missed tackle (every 10 yards means 4 missed tackles)

    - Example: if avg yards given up per missed tackle is 15 then thats 6 tackles lost for every one missed tackle. So you'd multiply your total missed by 6 tackles.
```
SELECT AVG(p.playResult) AS average_playResult
FROM tackles t
JOIN plays_cleaned p ON t.gameId = p.gameId AND t.playId = p.playId
WHERE t.pff_missedTackle = 1;

``` yards given up for missed tackle = 11 yards```



```
weighted_forced_fumble: to get the weight of a forced fumble find the average amount of turnovers it creates and multiply that by 4 and multiply that by the amount of forced fumbles. (turnover = 4 made tackles)
    - Example: if a forced fumble results in an avg of .5 turnovers that's 2 extra tackles per forced fumble. So for every forced fumble that's two extra tackles.
```

SELECT AVG(CAST(p.fumble_loss AS decimal)) AS average_fumble_loss
FROM tackles t
JOIN plays p ON t.gameId = p.gameId AND t.playId = p.playId
WHERE t.forcedFumble = 1;

``` when there is a forced fumble on the play the ball is turned over an avg of 0.333 times```



```total plays for the defense for one game```
SELECT COUNT(DISTINCT playId)
FROM tracking_1
WHERE gameId = 2022090800
    AND playId IN (SELECT playId FROM plays WHERE defensiveTeam = 'BUF')



