import ssl
import os
import pandas as pd
import logging
from dotenv import load_dotenv
from sqlalchemy import create_engine, text
from sqlalchemy.exc import SQLAlchemyError

# Instanciando um logger

logger = logging.getLogger(__name__)
logging.basicConfig(level=logging.INFO)


# Carrega as Variáveis de Ambiente

load_dotenv()

db_host = os.getenv("db_host")
db_name = os.getenv("db_name")
db_pass = os.getenv("db_pass")
db_user = os.getenv("db_user")

# Cria a engine de conexão psycopg2

engine = create_engine(
    f"postgresql+psycopg2://{db_user}:{db_pass}@{db_host}:5432/{db_name}", echo=False
)

# Obtém todas as tabelas existentes no banco

with engine.connect() as conn:

    query = text(
        "select table_name from information_schema.tables where table_schema = 'public'"
    )

    logger.info(f"CONNEXECUTE - {query}")

    table_list = conn.execute(query).fetchall()

    table_list = [item for sublist in table_list for item in sublist]

    logger.info(f"RESULT: {table_list or 'No tables'}")


# Loop de Criação das Tabelas: Roda todas as Queries de DML, apaga as tabelas existentes caso já existam no banco e Cria as Views

for file in os.listdir("sql_files"):

    table_name = file.split("_")[0].split(".")[0]

    if "dml" in file:

        logger.info(f"{__name__} DDLCREATE: {table_name}")

        with engine.connect() as conn:

            if table_name in table_list:

                query = text(f"drop table if exists public.{table_name} cascade;")

                try:

                    logger.info(f"CONNEXECUTE - {query}")

                    conn.execute(query)

                    conn.commit()

                except (SQLAlchemyError, Exception) as e:

                    logger.error(f"An error occurred: {e}")

        with engine.connect() as conn:

            with open(f"sql_files/{file}", "r") as querystring:

                query = text(querystring.read())

                try:

                    logger.info(f"CONNEXECUTE - {query}")

                    conn.execute(query)
                    
                    conn.commit()

                except (SQLAlchemyError, Exception) as e:

                    logger.error(f"An error occurred: {e}")

# Ignorando possíveis erros de ssl ao baixar conteúdo do github

ssl._create_default_https_context = ssl._create_unverified_context

# Baixa os datasets de um endereço na web e realiza o insert no banco de dados usando o pandas.to_sql

df_results = pd.read_csv(
    "https://raw.githubusercontent.com/martj42/international_results/master/results.csv"
)

logger.info(f"CSVDOWN - {df_results.shape[0]}")

created = df_results.to_sql(
    name="results", con=engine, schema="public", if_exists="append", index=False
)

logger.info(f"CREATED - {created}")

df_goalscorers = pd.read_csv(
    "https://raw.githubusercontent.com/martj42/international_results/master/goalscorers.csv"
)

logger.info(f"CSVDOWN - {df_goalscorers.shape[0]}")

created = df_goalscorers.to_sql(
    name="goalscorers", con=engine, schema="public", if_exists="append", index=False
)

logger.info(f"CREATED - {created}")

df_shootouts = pd.read_csv(
    "https://raw.githubusercontent.com/martj42/international_results/master/shootouts.csv"
)

logger.info(f"CSVDOWN - {df_shootouts.shape[0]}")

created = df_shootouts.to_sql(
    name="shootouts", con=engine, schema="public", if_exists="append", index=False
)

logger.info(f"CREATED - {created}")

for file in os.listdir("sql_files"):

    if "dml" not in file:

        print("Criando " + file)

        with engine.connect() as conn:

            with open(f"sql_files/{file}", "r") as querystring:

                query = text(querystring.read())

                try:

                    conn.execute(query)

                    logger.info(f"CONNEXECUTE - {query}")

                    conn.commit()

                except (SQLAlchemyError, Exception) as e:

                    print(f"An error occurred: {e}")

print("Fim de main.py")
