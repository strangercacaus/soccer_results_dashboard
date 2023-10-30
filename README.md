# Desafio SQL How Bootcamps - Resultados Internacionais de Futebol desde 1872

Este projeto foi desenvolvido como parte de um desafio de engenharia e análise de dados no bootcamp data engineering ministrado na How Bootcamps em 2023.

O projeto contido neste repositório contempla a configuração de um banco de dados PostgreSQL e ferramenta de business intelligence Metabase em um ambiente containerizado utilizando o Docker Desktop.

Uma vez que os arquivos DockerFile e Docker-Compose foram criados, as seguintes etapas são executadas para subir o ambiente Postgresql e Metabase

## 1- Realizar o download do Docker Desktop:

[![Docker Desktop](https://img.shields.io/badge/Docker_Desktop-blue?style=for-the-badge&logo=docker&logoColor=white)](https://www.docker.com/products/docker-desktop)

## 2- Realize o pull das imagens:
```bash
docker pull metabase/metabase
docker pull postgres
```
*O download das imagens também pode ser feito através do aplicativo do Docker desktop*

## 2- Certifique-se se as imagens baixadas foram identificadas pelo docker
```shell
docker image ls
```
*Output:*
```bash
REPOSITORY                    TAG       IMAGE ID       CREATED        SIZE
metabase/metabase             latest    2b600465cfbe   2 weeks ago    484MB
postgres                      latest    96f08c06113e   6 weeks ago    438MB
```

## 3- Suba um container com as imagens utilizando o Docker-Compose

```bash
docker-compose up
```
*É possível especificar o serviço desejado contido no docker-compose.yml após o comando up, neste caso vamos subir um container com ambos os serviços*

## 4- Exiba os containers ativos
```shell
docker ps
```
*Output (Truncado para visualização):*
```bash
CONTAINER ID   IMAGE               COMMAND                  CREATED          ...
a24fdf0e24ba   metabase/metabase   "/app/run_metabase.sh"   27 seconds ago   ...
4c609ec470be   postgres            "docker-entrypoint.s…"   27 seconds ago   ...
```
## 6- Caso deseje parar um container

```shell
docker stop <container_id>
```

## 7- Execute main.py

Com os ambientes rodando, já é possível utilizar o script main.py, responsável por obter 3 diferentes arquivos CSV de um endereço online e persisti-los no banco de dados no formato de tabelas.

Os acessos para o banco de dados são configurados no arquivo docker-compose e são os seguintes:

## 8- Para acessar o Banco de dados

`Host:`
```
0.0.0.0 ou localhost
```
`Porta:`
```
5432
```
`Database:`
```
test_db
```
`User:`
```
root
```
`Senha:`
```
root
```

## 9 Para acessar o Metabase:

Com as tabelas criadas, uma série de perguntas e queries personalizadas para os dados obtidos já estarão disponíveis no metabase.

`URL:`
```
localhost::3000
```

### Credenciais:

`E-mail:`
```
admin@provider.com
```
`Senha:`
```
since2008
```

No final, os dados coletados e analisados estarão disponíveis em
```
http://localhost:3000/dashboard/1-resultados-internacionais-de-futebol-desde-1872?text=Brazil
```