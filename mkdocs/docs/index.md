#Boas Vindas

## Introdução

Este é um projeto de Business Intelligence que teve inicio durante o Bootcamp de Data Engineering da How Bootcamps em 2023.
Ao longo do tempo incluí melhorias de estrutura de projeto e documentação.

## Objetivo
Este projeto possui 2 objetivos principais:

- Explorar o conceito de Conteinerização para gestão de dependências e ambientes virtuais.

- Criar uma estrutura de BI do zero, implementando um banco de dados e uma ferramenta de BI.

## Tecnologias Utilizadas

![Python](https://img.shields.io/badge/python-blue?style=for-the-badge&logo=python&logoColor=yellow)
>
>Para a criação de tabelas e views de maneira programática foi utilizado Python, assim como para a ingestão de dados e inserção no banco.
>As bibliotecas utilizadas na rotina foram `sqlalchemy`, `requests` e `pandas`

![Postgres](https://img.shields.io/badge/postgres-%233A6796.svg?style=for-the-badge&logo=postgresql&logoColor=white)
>
> O banco de dados escolhido para o projeto foi o PostgreSQL em razão de ser Open-Source e amplamente adotado.

![Metabase](https://img.shields.io/badge/Metabase%20-%20%23509EE3?style=for-the-badge&logo=metabase&logoColor=white)
>
> Também Open-Source e compatível com Docker, o Metabase foi a ferramenta de BI escolhida para a exploração dos dados do projeto.


![Docker](https://img.shields.io/badge/docker-1E63EE.svg?style=for-the-badge&logo=docker&logoColor=white)
>
> O Docker foi utilizado para a virtualização do ambiente de execução.

![mkdocs](https://img.shields.io/badge/MkDocs-blue?style=for-the-badge&logo=mkdocs&logoColor=white)
>
> O mkdocs foi utilizado para a criação desta documentação

## Layout do projeto

```
soccer_results_dashboard
│   
├── .bi_volume/ - Diretório de armazenamento dos dados do Metabase.
│
├── mkdocs/ - Arquivos de documentação utilizados com o mkdocs
│   │
│   └── mkdocs.yml - O arquivo de configuração da página de 
│   
├── documentação no mkdocs
│
├── sql_files/ - Comandos DML para criação de tabelas e views.
│
├── src/
│   │
│   └── main.py - Script de ingestão de dados
│
├── previews/ - Prints do projeto
│
├── .env - Arquivo com credenciais de acesso ao banco de dados.
│
├── requirements.txt - Dependências do projeto
│
├── .gitignore - Arquivos ignorados pelo git
│
├── docker-compose.yml - Arquivo de configuração do ambiente do Docker
│
└── README.md - O arquivo que você está lendo agora.
```