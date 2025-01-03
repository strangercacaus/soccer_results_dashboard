# Configuração

### Configuração do ambiente

--------

 #### 1. Faça o download e a instalação do Docker Desktop [![Docker Desktop](https://img.shields.io/badge/Docker_Desktop-blue?style=for-the-badge&logo=docker&logoColor=white)](https://www.docker.com/products/docker-desktop)
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
*Output Exemplo:*
```bash
REPOSITORY                    TAG       IMAGE ID       CREATED        SIZE
metabase/metabase             latest    2b600465cfbe   2 weeks ago    484MB
postgres                      latest    96f08c06113e   6 weeks ago    438MB
```
--------


#### 4. Crie  um container com as imagens utilizando o Docker-Compose

```bash
docker-compose up -d
```
*É possível especificar o serviço desejado contido no docker-compose.yml após o comando up, neste caso vamos subir um container com ambos os serviços*

#### 5. Exibir os containers ativos

```bash
docker ps
```
*Output:*
```bash
CONTAINER ID   IMAGE               COMMAND                  CREATED        STATUS          PORTS                    NAMES
a24fdf0e24ba   metabase/metabase   "/app/run_metabase.sh"   14 hours ago   Up 6 seconds    0.0.0.0:3000->3000/tcp   desafio-resultados-do-futebol-eng-de-dados-bi-1
4c609ec470be   postgres            "docker-entrypoint.s…"   14 hours ago   Up 42 minutes   0.0.0.0:5432->5432/tcp   pg_container
```
#### 6. Parar um container

```shell
docker stop <container_id>
```

#### 7. Criar um ambiente virtual `venv`.
```bash
python3 -m venv env
```
*Certifique-se de estar localizado na pasta raiz do projeto no momento da criação do ambiente virtual*

#### 8. Ative o ambiente virtual.

```bash
source env/bin/activate
```
** Assim que o ambiente virtual for ativado, o terminal anternará o valor exibido entre parênteses de `base` para `env`, como no exemplo:
```
(base) 192:Desafio-Resultados-do-Futebol-Eng.-de-Dados user$ source env/bin/activate
(env) (base) 192:Desafio-Resultados-do-Futebol-Eng.-de-Dados user$
```

#### 9. Instale os pacotes listados no arquivo `requirements.txt`.
```bash
pip instal -r requirements.txt
```

#### 10.  Execute o Script `src/main.py`

Com os containers ativos, já é possível utilizar o script main.py, que irá criar as tabelas descritas nos comandos SQL, obter 3 arquivos CSV do Dataset localizado no Github e inseri-los nas tabelas do Banco de Dados.

``` bash
python3 src/main.py
```


Os acessos para o banco de dados são configurados no arquivo docker-compose e são os seguintes:

#### 11. Acesso ao Banco de Dados

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

#### 12. Accessar o Metabase:

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

*ATENÇÃO:*

Caso o Metabase solicite a criação de um novo usuário e a configuração manual da conexão com o PostgreSQL, utilize a sigla 'db' no lugar do HOST.

Este detalhe é necessário pois o Metabase e PostgreSQL estão no mesmo conteiner, o HOST neste caso é identificado pelo nome do serviço definido no arquivo dockerfile.yml