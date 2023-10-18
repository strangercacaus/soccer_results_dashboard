import os
import pandas as pd
from dotenv import load_dotenv
from sqlalchemy import create_engine

load_dotenv()

db_host = os.getenv('db_host')
db_name = os.getenv('db_name')
db_pass = os.getenv('db_pass')
db_user = os.getenv('db_user')

engine = create_engine(f"postgresql+psycopg2://{db_user}:{db_pass}@{db_host}:5432/{db_name}", echo=False)

for file in os.listdir('sql_commands'):
    if 'dml' in file and 'project' not in file:
        with open(f'sql_commands/{file}', 'r') as query:
            sql_script = query.read()
        with engine.connect() as connection:
           result = connection.execute(sql_script)


df_results = pd.read_csv('https://raw.githubusercontent.com/martj42/international_results/master/results.csv')
df_results.to_csv('raw_data/results.csv')
df_results.to_sql(name= 'results',con= engine, schema='public', if_exists='replace')


df_goalscorers =  pd.read_csv('https://raw.githubusercontent.com/martj42/international_results/master/goalscorers.csv')
df_goalscorers.to_csv('raw_data/goalscorers.csv')
df_goalscorers.to_sql(name= 'goalscorers',con= engine, schema='public', if_exists='replace')

df_shootouts =  pd.read_csv('https://raw.githubusercontent.com/martj42/international_results/master/shootouts.csv')
df_shootouts.to_csv('raw_data/shootouts.csv')
df_shootouts.to_sql(name= 'shootouts',con= engine, schema='public', if_exists='replace')


for file in os.listdir('sql_commands'):
    if 'dml' not in file and 'project' not in file:
        with open(f'sql_commands/{file}', 'r') as query:
            sql_script = query.read()
        with engine.connect() as connection:
            result = connection.execute(sql_script)