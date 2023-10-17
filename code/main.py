import pandas as pd
import psycopg2
from sqlalchemy import create_engine

db_host = '0.0.0.0'
db_name = 'test_db'
db_pass = 'root'
db_user = 'root'

engine = create_engine(f"postgresql+psycopg2://{db_user}:{db_pass}@{db_host}:5432/{db_name}", echo=False)

df_results = pd.read_csv('https://raw.githubusercontent.com/martj42/international_results/master/results.csv')
df_results.to_csv('D01_Desafio_SQL/raw_data/results.csv')
df_results.to_sql(name= 'results',con= engine, schema='public', if_exists='replace')


df_goalscorers =  pd.read_csv('https://raw.githubusercontent.com/martj42/international_results/master/goalscorers.csv')
df_goalscorers.to_csv('D01_Desafio_SQL/raw_data/goalscorers.csv')
df_goalscorers.to_sql(name= 'goalscorers',con= engine, schema='public', if_exists='replace')

df_shootouts =  pd.read_csv('https://raw.githubusercontent.com/martj42/international_results/master/shootouts.csv')
df_shootouts.to_csv('D01_Desafio_SQL/raw_data/shootouts.csv')
df_shootouts.to_sql(name= 'shootouts',con= engine, schema='public', if_exists='replace')



