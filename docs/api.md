## Queries em utilização:

### 1: DML: goalscores table:
```sql
CREATE TABLE public.goalscorers (
    id integer not null,
    "date" date not null,
    home_team varchar(50),
    away_team varchar(50), 
    team varchar(50),
    scorer varchar,
    minute numeric,
    own_goal boolean,
    penalty boolean);
```

### 2: DML: results table:
```sql
CREATE TABLE public.results(
    id integer not null,
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

### 3: DML: shootouts table:
```sql
CREATE TABLE public.shootouts (
    id integer not null,
    "date" date not null,
    home_team varchar(50),
    away_team varchar(50), 
    winner varchar(50));
```

### 3: DML: shootout_results view:
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

### 4: DML: results_index view:
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

### 5: DML: melhor_campeonato view:
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

### 6: DML: goals_distribuition view:
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

### 7: DML: goals_cumulative view:
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

### 3: DML: best_matches view:
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