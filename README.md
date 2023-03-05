# Desafio SQL How Bootcamps - Resultados Internacionais de Futebol desde 1872

Este projeto foi desenvolvido como parte de um desafio de engenharia e análise de dados no bootcamp data engineering ministrado na How Bootcamps em 2023.

O projeto contido neste repositório contempla a configuração de um banco de dados PostgreSQL e ferramenta de business intelligence Metabase em um ambiente containerizado utilizando o Docker Desktop.

Uma vez que os arquivos DockerFile e Docker-Compose foram criados, as seguintes etapas são executadas para subir o ambiente Postgresql e Metabase

## 1- Construindo a imagem Web_Apache
> docker build -t web_apache .

## 2 -Listando imagens disponíveis
docker image ls

## 3 -Executar um container 
> docker run -d -p 80:80 web_apache

## 4- Exibir containers ativos
docker ps

## 5 -Parar um container
docker stop <container_id>

## 6- Subir um banco de dados com o compose
> docker-compose up <service_name> (Sobe todos os serviços se não for espeficado)

Com os ambientes rodando, já é possível utilizar o script main.py, responsável por obter 3 diferentes arquivos CSV de um endereço online e persisti-los no banco de dados no formato de tabelas.

Os acessos para o banco de dados são configurados no arquivo docker-compose e são os seguintes:

### Host:
0.0.0.0 ou localhost
### Porta:
5432
### Database:
test_db
### User:
root
### Password:
root

Com as tabelas criadas, uma série de perguntas e queries personalizadas para os dados obtidos já estarão disponíveis no metabase, acessado através do localhost::3000

Os dados de acesso são os seguintes:

### Login:
admin@provider.com

### Senha:
root

No final, os dados coletados e analisados estarão disponíveis em
http://localhost:3000/dashboard/1-resultados-internacionais-de-futebol-desde-1872?text=Brazil