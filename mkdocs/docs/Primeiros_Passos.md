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

#### 7: Carregando os dados de exemplo do Metabase salvo
Caso você deseje carregar o dashboard criado na preview dewste repositório, realize a etapa seguinte antes de criar os conteiners:
```bash
cd volumes
unzip .bi_volume.zip
```
*Este comando irá descompactar o arquivo .bi_volume.zip para uma pasta de mesmo nome (.bi_volume)
Esta pasta está configurada como volume vinculado ao caminho '/metabase.db' no arquivo docker-compose.yml*

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

#### 7. Crie um ambiente virtual `venv`.
```bash
python3 -m venv env
```
*Certifique-se de estar localizado na pasta raiz do projeto no momento da criação do ambiente virtual*

#### 8. Ative o ambiente virtual.

```bash
source env/bin/activate
```
** Assim que o ambiente virtual for ativado, o terminal anternará o valor exibido entre parênteses de `base` para `env`:
```
(base) 192:Desafio-Resultados-do-Futebol-Eng.-de-Dados user$ source env/bin/activate
(env) (base) 192:Desafio-Resultados-do-Futebol-Eng.-de-Dados user$
```

#### 9. Instale os pacotes listados no arquivo `requirements.txt`.
```bash
pip instal -r requirements.txt
```

#### 10.  Execute o Script `src/main.py`

Com os containers ativos, já é possível utilizar o script main.py, que irá criar as tabelas descritas nos comandos SQL, obter 3 arquivos CSV do Dataset localizado no Kaggle e inseri-los nas tabelas do Banco de Dados.

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

#### 12. Accesso ao Metabase:

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
Caso o Metabase solicite a criação de um novo usuário e a configuração manual da conexão ao PostgreSQL utilize a sigla 'db' no lugar do HOST.
Este detalhe é necessário pois como Metabase e PostgreSQL estão no mesmo conteiner, o HOST de cada um é identificado pelo nome do serviç definido no arquivo dockerfile.yml