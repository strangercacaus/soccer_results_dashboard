-- Primeira CTE: Retorna uma lista com o nome de todos os países sem duplicatas
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