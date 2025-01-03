create or replace view goals_cummulative
as with matches as (
    select r.home_team as team,
    	   to_char("date"::date, 'YYYY') as year,
           r.away_team as oponent,
           r.tournament,
           r.home_score as gols,
           case
               when home_score > away_score then 'vitoria'
               when home_score < away_score then 'derrota'
               else 'empate'
           end as "result"
    from results r
    union all
    select r.away_team as team,
    	   to_char("date"::date, 'YYYY') as ano,
           r.home_team as oponent,
           r.tournament,
           r.away_score as goals,
           case
               when away_score > home_score then 'vitoria'
               when away_score < home_score then 'derrota'
               else 'empate'
           end as "result"
    from results r
),
gols_ano as(
		select team,
			   year,
			   sum(gols) as gols from matches
		group by 1,2
		order by team)
select
  "year",
  team,
  gols,
  sum(gols) over (partition by team order by "year" asc rows between unbounded preceding and current row) acumulado
from gols_ano;