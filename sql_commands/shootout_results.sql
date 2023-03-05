with matches as (
		   select r.home_team as team,
    	   to_char(r."date"::date, 'YYYY') as year,
           r.away_team as oponent,
           r.tournament,
           r.home_score as gols,
           case
               when r.home_score > r.away_score then 'vitoria'
               when r.home_score < r.away_score then 'derrota'
               else 'empate'
           end as "result",
           s.winner as res_penalti
    from results r
    	left join shootouts s on s.home_team = r.home_team and s."date" = r."date" and s.away_team = r.away_team
    union all
    select r.away_team as team,
    	   to_char(r."date"::date, 'YYYY') as ano,
           r.home_team as oponent,
           r.tournament,
           r.away_score as goals,
           case
               when r.away_score > r.home_score then 'vitoria'
               when r.away_score < r.home_score then 'derrota'
               else 'empate'
           end as "result",
           s.winner as res_penalti
    from results r
        left join shootouts s on s.home_team = r.home_team and s."date" = r."date" and s.away_team = r.away_team),
taxas as (
	select m.team,
		   count(*) filter(where result = 'vitoria' and res_penalti is not null)::numeric as vitorias_penalti,
		   count(*) filter(where result = 'derrotas' and res_penalti is not null)::numeric as derrotas_penalti,
		   count(*) filter(where result = 'vitoria')::numeric as vitorias_geral,
		   count(*) filter(where result = 'vitoria')::numeric as derrotas_geral,
		   count(*) filter(where result = 'vitoria')::numeric as empates_geral,
		   trunc(count(*) filter(where result = 'vitoria')::numeric
		         / count(*)::numeric,2) as tx_vitoria_geral,
		   case when count(*) filter(where res_penalti is not null) > 0
		        then trunc(count(*) filter(where result = 'vitoria'
		        						   and res_penalti is not null)::numeric
		        		   / count(*) filter(where res_penalti is not null)::numeric,2)
		   else null end as tx_vitoria_penalti
	from matches m
	group by m.team
	having (count(*) filter(where res_penalti is not null) > 0))
select *,
		tx_vitoria_geral - tx_vitoria_penalti as diferença,
		case when tx_vitoria_geral - tx_vitoria_penalti > 0 then 'melhor'
			 when tx_vitoria_geral - tx_vitoria_penalti < 0 then 'pior'
			 else 'neutro'
		end as impacto
from taxas

