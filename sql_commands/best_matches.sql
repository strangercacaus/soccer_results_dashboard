with matches as (
    select home_team as team,
           away_team as oponent,
           case
               when home_score > away_score then 'win'
               when home_score < away_score then 'loss'
               else 'tie'
           end as "result"
    from results r
    union all
    select away_team as team,
           home_team as oponent,
           case
               when away_score > home_score then 'win'
               when away_score < home_score then 'loss'
               else 'tie'
           end as "result"
    from results r
),
team_opponent_stats as (
    select team,
           oponent,
           count("result") filter (where "result" = 'win') as wins,
           count("result") filter (where "result" = 'loss') as losses,
           count("result") filter (where "result" = 'tie') as ties,
           count("result") as total,
           trunc((count("result") filter (where "result" = 'win')::numeric
                  / count("result")::numeric), 2) as win_rate,
           ((count("result") filter (where "result" = 'win')::numeric
             / count("result")::numeric)
            * count("result")) as score
    from matches m
    group by team, oponent
),
ranking as (
select *,
           row_number() over (partition by team order by score desc) as rank
from team_opponent_stats)
select irt."time",
	   irt.pior_contra,
	   irt.vitorias,
	   irt.derrotas,
	   irt.empates,
	   irt.total,
	   irt.tx_vitoria,
       irt.
from(
		select team as "time",
		       oponent as pior_contra,
		       wins as vitorias,
		       losses as derrotas,
		       ties as empates,
		       total,
		       win_rate tx_vitoria,
		       "rank",
		       (select max("rank") from ranking r2 where r2.team = r.team) as max,
               case when "rank" = "max" then 'pior'
                    when "rank" = 1 then 'melhor'
                    else null end as class
		from ranking r
		where total > 3
		order by "rank" desc) irt
where (case when "rank" = "max" then 'pior'
when "rank" = 1 then 'melhor'
else null end ) is not null
order by "time" asc
