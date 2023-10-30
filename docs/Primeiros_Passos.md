# Primeiros Passos
-----------

### Realizar a configuração do ambiente

--------
#### 1. Realizar o download do Docker Desktop: [![Docker Desktop](https://img.shields.io/badge/Docker_Desktop-blue?style=for-the-badge&logo=docker&logoColor=white)](https://www.docker.com/products/docker-desktop)
--------
#### 2. Realize o pull das imagens:
```shell
docker pull metabase/metabase
docker pull postgres
```
*O download das imagens também pode ser feito através do aplicativo do Docker desktop*

--------
#### 3. Certifique-se de que as imagens baixadas foram identificadas pelo docker
```shell
docker image ls
```
*Output:*
```bash
REPOSITORY                    TAG       IMAGE ID       CREATED        SIZE
metabase/metabase             latest    2b600465cfbe   2 weeks ago    484MB
postgres                      latest    96f08c06113e   6 weeks ago    438MB
```
--------
#### 4. Crie  um container com as imagens utilizando o Docker-Compose

```bash
docker-compose up
```
*É possível especificar o serviço desejado contido no docker-compose.yml após o comando up, neste caso vamos subir um container com ambos os serviços*

#### 5. Exiba os containers ativos
```shell
docker ps
```
*Output:*
```bash
CONTAINER ID   IMAGE               COMMAND                  CREATED        STATUS          PORTS                    NAMES
a24fdf0e24ba   metabase/metabase   "/app/run_metabase.sh"   14 hours ago   Up 6 seconds    0.0.0.0:3000->3000/tcp   desafio-resultados-do-futebol-eng-de-dados-bi-1
4c609ec470be   postgres            "docker-entrypoint.s…"   14 hours ago   Up 42 minutes   0.0.0.0:5432->5432/tcp   pg_container
```
#### 6. Caso deseje parar um container

```shell
docker stop <container_id>
```

#### 7.  Execute o Script `src/main.py`

Com os containers ativos, já é possível utilizar o script main.py, que irá criar as tabelas descritas nos comandos SQL, obter 3 arquivos CSV do Dataset localizado no Kaggle e inseri-los nas tabelas do Banco de Dados.

Os acessos para o banco de dados são configurados no arquivo docker-compose e são os seguintes:

#### 8. Acesso ao Banco de Dados

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

#### 9. Accesso ao Metabase:

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