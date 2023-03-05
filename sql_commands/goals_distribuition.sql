SELECT distinct teams.team, minutes.minute, COALESCE(counts.count, 0) as count
FROM (SELECT DISTINCT team FROM goalscorers) AS teams
CROSS JOIN (
  SELECT generate_series(1, max_minute::integer) AS minute, team
  FROM (
    SELECT team, max(minute) as max_minute
    FROM goalscorers
    GROUP BY team
  ) AS max_minutes
) AS minutes
LEFT JOIN (
  SELECT team, minute, count(*) as count
  FROM goalscorers
  GROUP BY team, minute
) AS counts ON teams.team = counts.team AND minutes.minute = counts.minute
ORDER BY teams.team, minutes.minute;