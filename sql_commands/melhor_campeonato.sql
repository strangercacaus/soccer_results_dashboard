with times_and_camps as(
select 
	distinct 
	home_team as team,
	tournament
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