# Comandos SQL do Projeto:
-------------------------
## Criação das Tabelas:
-------------------------
### Tabela de Goleadores (goalscorers)
```sql
CREATE TABLE public.goalscorers (
    id serial4,
    "date" date not null,
    home_team varchar(50),
    away_team varchar(50), 
    team varchar(50),
    scorer varchar,
    minute numeric,
    own_goal boolean,
    penalty boolean);
```

-------------------------


### Tabela de resultados das partidas (results):
```sql
CREATE TABLE public.results(
    id serial4,
    "date" date not null,
    home_team varchar(50),
    away_team varchar(50), 
    home_score integer,
    away_score integer,
    tournament varchar,
    city varchar,
    country varchar(50),
    neutral boolean);
```

-------------------------

### Tabela de resultados de pênaltis (shootouts):
```sql
CREATE TABLE public.shootouts (
    id serial4,
    "date" date not null,
    home_team varchar(50),
    away_team varchar(50), 
    winner varchar(50),
	first_shooter varchar(50));
```

-------------------------

## Criação de viewss:

-------------------------

### Índice de Resultados (results_index).
*Retorna um índice com diversas estatíticas sobre cada seleção*
```sql
create or replace view results_index
as-- Primeira CTE: Retorna uma lista com o nome de todos os países sem duplicatas
with paises as (
select distinct *
from
	(select
		r.home_team as clube
	from results r  where r.tournament != 'Friendly'
	union all
	select
		r.away_team as clube
	from results r  where r.tournament != 'Friendly') innertable
order by 1 asc),
-- Segunda CTE: Retorna a soma de todos os goals realizados e sofridos tanto na posição de away team quanto home team, através do UNION ALL
	saldogols as (
select
	clube,
	sum(gols_realizados) as gols_realizados,
	sum(gols_sofridos) as gols_sofridos
from
	(select
		r4.home_team as clube,
		r4.away_team as adversario,
		r4.home_score as gols_realizados,
		r4.away_score as gols_sofridos
	from
		results r4  where r4.tournament != 'Friendly'
union all
	select
		r3.away_team as clube,
		r3.home_team as adversario,
		r3.away_score as gols_realizados,
		r3.home_score as gols_sofridos
	from
		results r3 where r3.tournament != 'Friendly') inner_table
group by clube)
select
	p.clube,
-- Subselect para realizar a contagem total de jogos em que o time apareceu como home ou away
	(select count(*)
	 from results r1
	 where (r1.home_team = p.clube
		or r1.away_team = p.clube) and r1.tournament != 'Friendly') as qtd_jogos,
-- Subselect para retornar a menor data em que ocorre um jogo com o clube na condição de home ou away
	(select min(r2."date"::date)
	 from results r2
	 where (r2.home_team = p.clube
		or r2.away_team = p.clube)) as primeiro_jogo,
	s.gols_realizados,
	s.gols_sofridos,
	s.gols_realizados - s.gols_sofridos as saldo_gols,
-- Subselect que checa se o clube p.clube teve pontuação maior do que o adversário na posição de home_team ou de away_team
	(select sum(case when r5.home_team = p.clube
					 and r5.home_score > r5.away_score
					 or r5.away_team  = p.clube
					 and r5.away_team > r5.home_team  then 1 else 0 end) from results r5 where r5.tournament != 'Friendly') as vitorias,
-- Subselect que checa se o clube p.clube teve pontuação menor do que o adversário na posição de home_team ou de away_team
	(select sum(case when r6.home_team = p.clube
					 and r6.home_score < r6.away_score
					 or r6.away_team  = p.clube
					 and r6.away_team < r6.home_team  then 1 else 0 end) from results r6 where r6.tournament != 'Friendly') as derrotas,
-- Subselect que checa se o clube p.clube é ou o home_team ou o away_team e depois checa se as pontuações são iguais
	(select sum(case when (r7.home_team = p.clube or r7.away_team = p.clube)
					 and r7.home_score = r7.away_score then 1 else 0 end) from results r7 where r7.tournament != 'Friendly') as empates,
-- Subselect que reúne todos os grupos adversários away e home num subselect, aplica um distinct e depois um count
	(select count(*) from (select distinct * from (select r8.away_team as team from results r8 where p.clube = r8.home_team
				  union all
				  select r9.home_team as team from results r9 where p.clube = r9.away_team) inner_table3)inner_table4)as qtd_adversarios,
-- Subselect que usa a coluna 'vitórias para ranquear todos os nomes da lista
	RANK() OVER (ORDER by (select sum(case when r5.home_team = p.clube
					 and r5.home_score > r5.away_score
					 or r5.away_team  = p.clube
					 and r5.away_team > r5.home_team  then 1 else 0 end) from results r5 where r5.tournament != 'Friendly')  desc) as ranking
from
	paises p
join saldogols s on p.clube = s.clube
order by 7 desc
```
*Output:*
```
clube                           |qtd_jogos|primeiro_jogo|gols_realizados|gols_sofridos|saldo_gols|vitorias|derrotas|empates|qtd_adversarios|ranking
--------------------------------+---------+-------------+---------------+-------------+----------+--------+--------+-------+---------------+-------
Uruguay                         |      607|   1902-07-20|            987|          725|       262|     483|      54|    143|             85|      1
South Korea                     |      604|   1949-01-02|           1149|          486|       663|     428|      98|    158|            123|      2
Scotland                        |      584|   1872-11-30|           1025|          688|       337|     398|     122|    128|             78|      3
Sweden                          |      510|   1908-07-12|           1012|          585|       427|     397|      64|    103|             99|      4
Thailand                        |      556|   1954-11-01|            829|          873|       -44|     396|      99|    135|             80|      5
```

--------------

### Estatíticas de jogos com pênaltis (shootout_results).

*Retorna estatísticas de vitória de cada seleção em jogos com e sem pênaltis e a diferença da taxa de vitória.*
```sql
create or replace view shootout_results
as
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
```
*Output:*
```
team                    |vitorias_penalti|derrotas_penalti|vitorias_geral|derrotas_geral|empates_geral|tx_vitoria_geral|tx_vitoria_penalti|diferença|impacto|
------------------------+----------------+----------------+--------------+--------------+-------------+----------------+------------------+---------+-------+
Abkhazia                |               0|               0|            12|            12|           12|            0.42|              0.00|     0.42|melhor |
Åland Islands           |               0|               0|            21|            21|           21|            0.45|              0.00|     0.45|melhor |
Algeria                 |               0|               0|           243|           243|          243|            0.43|              0.00|     0.43|melhor |
Andorra                 |               0|               0|            12|            12|           12|            0.05|              0.00|     0.05|melhor |
Angola                  |               0|               0|           131|           131|          131|            0.33|              0.00|     0.33|melhor |
Antigua and Barbuda     |               0|               0|            71|            71|           71|            0.32|              0.00|     0.32|melhor |
Argentina               |               1|               0|           563|           563|          563|            0.54|              0.04|     0.50|melhor |
```

-------------------------



### Estatisticas de melhor campeonato (best_championship).
*Retorna estatísticas de desempenho de cada time por campeonato*
```sql
create or replace view best_championship
as with times_and_camps as(
select 
	distinct 
	home_team as team,
	r.tournament
		from 
	results r 
),
times_wins_goals as 
(select 
	team,
	tournament,

	(
		select 
		SUM(
			case when r2.home_score > r2.away_score then 1 else 0 end
		) as  v1
		
		from results r2
		where 
			r2.home_team = c.team and  r2.tournament = c.tournament
	),
	(
		select 
		SUM(
			case when r2.home_score > r2.away_score then home_score else 0 end
		) as  v1_gols
		
		from results r2
		where 
			r2.home_team = c.team and  r2.tournament = c.tournament
	)
	
	
	,
	(
		select 
		SUM(
			case when r2.home_score < r2.away_score then 1 else 0 end
		) as  v2
		
		from results r2
		where 
			r2.away_team  = c.team and  r2.tournament = c.tournament
	),
		(
		select 
		SUM(
			case when r2.home_score < r2.away_score then away_score else 0 end
		) as  v2_gols
		
		from results r2
		where 
			r2.away_team  = c.team and  r2.tournament = c.tournament
	)
	
	
	from
 times_and_camps c 
 order by team asc
 ), team_rank as (select 
 	team,
 	tournament,
 	sum(
 		coalesce(v1, 0)
 		+
 		coalesce(v2, 0)
 		) qtd_vitorias,
 		
 	sum(
 		coalesce(v1_gols, 0 )
 		+
 		coalesce(v2_gols,0 )
 	) qtd_gols,
 	row_number() over (partition by team order by (sum(coalesce(v1, 0)	+coalesce(v2, 0)) ) desc ) rn  
 from times_wins_goals
 group by 1, 2 
 ) select * from team_rank where rn = 1
``` 
*Output:*
```
team                    |tournament                          |qtd_vitorias|qtd_gols|rn|
------------------------+------------------------------------+------------+--------+--+
Abkhazia                |CONIFA World Football Cup           |           9|      29| 1|
Afghanistan             |SAFF Cup                            |          11|      37| 1|
Åland Islands           |Island Games                        |          21|      51| 1|
Albania                 |Friendly                            |          41|      96| 1|
Alderney                |Island Games                        |           2|       4| 1|
Algeria                 |Friendly                            |          91|     207| 1|
```
------------
### Estatísticas de distribuição de gols (goals_distribuition):
*Retorna a quantidade de gols marcados por minuto de partida por país*
```sql
create or replace view goals_distribuition
as
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
```
*Output*:
```
team       |minute|count
-----------+------+-----
Afghanistan|     1|    0
Afghanistan|     2|    0
Afghanistan|     3|    0
Afghanistan|     4|    0
Afghanistan|     5|    0
Afghanistan|     6|    0
```

--------

### Gols cumulativos por ano por país (goals_cumulative).
*Retorna o acumulado de gols realizados por cada país por ano desde o inico da série histórica*
```sql
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
from gols_ano
```
*Output*:
```
year|team          |gols|acumulado|
----+--------------+----+---------+
2012|Abkhazia      |   1|        1|
2014|Abkhazia      |   6|        7|
2016|Abkhazia      |  15|       22|
2017|Abkhazia      |   5|       27|
2018|Abkhazia      |  15|       42|
2019|Abkhazia      |   6|       48|
```
-------------------

### Melhor matchup de cada time (best_matches).
*Retorna o adversário que cada time teve melhor desempenho contra*
```sql
create or replace view best_matches
as
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
       irt."rank"
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
               case when "rank" = max("rank") then 'pior'
                    when "rank" = 1 then 'melhor'
                    else null end as class
		from ranking r
		where total > 3
		group by 1,2,3,4,5,6,7,8
		order by "rank" desc) irt
where (case when "rank" = "max" then 'pior'
when "rank" = 1 then 'melhor'
else null end ) is not null
order by "time" asc
```
*Output*:
```
time                    |pior_contra             |vitorias|derrotas|empates|total|tx_vitoria|rank|
------------------------+------------------------+--------+--------+-------+-----+----------+----+
Afghanistan             |Sri Lanka               |       6|       1|      1|    8|      0.75|   1|
Åland Islands           |Jersey                  |       0|       6|      0|    6|      0.00|  17|
Åland Islands           |Greenland               |       4|       1|      0|    5|      0.80|   1|
Albania                 |Malta                   |       5|       1|      2|    8|      0.62|   1|
Albania                 |Netherlands             |       0|       4|      0|    4|      0.00|  68|
Algeria                 |Senegal                 |      15|       4|      6|   25|      0.60|   1|
```

--------------

## Observações:
- Na sua maior parte, as views ignoram partidas amistosas, verifique se isso ocorre ao interpretar os resultados.