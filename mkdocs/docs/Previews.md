# Previews

### Provisionamento de Banco de Dados com Docker

Utilizando o Docker, é criado um container contendo a imagem do postgres e metabase, vinculados como serviços.


<figure markdown>
  [![Nome da Imagem](https://github.com/strangercacaus/soccer_results_dashboard/blob/main/previews/Docker_UI.png?raw=true)](https://github.com/strangercacaus/soccer_results_dashboard/blob/main/previews/Docker_UI.png?raw=true){width="900"}
</figure>
<figure markdown>
  [![Nome da Imagem](https://github.com/strangercacaus/soccer_results_dashboard/blob/main/previews/PostgreSQL%20Schema.png?raw=true)](https://github.com/strangercacaus/soccer_results_dashboard/blob/main/previews/PostgreSQL%20Schema.png?raw=true){width="900"}
</figure>

### Extração e Carregamento de Dados

O projeto conta com um script Python que realiza a criação de tabelas numa instância do PostgreSQL, além do download e inserção de 3 arquivos CSV armazenados no Github.

<figure markdown>
  [![Nome da Imagem](https://github.com/strangercacaus/soccer_results_dashboard/blob/main/previews/Python%20Main.png?raw=true)](https://github.com/strangercacaus/soccer_results_dashboard/blob/main/previews/Python%20Main.png?raw=true){width="900"}
</figure>

### Modelagem e Cálculo de Dados

Os dados carregados são modelados utilizando views de banco de dados e perguntas no formato nativo e em SQL no Metabase.

<figure markdown>
  [![Nome da Imagem](https://github.com/strangercacaus/soccer_results_dashboard/blob/main/previews/PostgreSQL%20Views.png?raw=true)](https://github.com/strangercacaus/soccer_results_dashboard/blob/main/previews/PostgreSQL%20Views.png?raw=true){width="900"}
</figure>

<figure markdown>
  [![Nome da Imagem](https://github.com/strangercacaus/soccer_results_dashboard/blob/main/previews/Metabase%20Questions%20SQL.png?raw=true)](https://github.com/strangercacaus/soccer_results_dashboard/blob/main/previews/Metabase%20Questions%20SQL.png?raw=true){width="900"}
</figure>

### Criação de Dashboard

Os resultados das perguntas são organizados em um dashboard filtrável no Metabase

<figure markdown>
  [![Nome da Imagem](https://github.com/strangercacaus/soccer_results_dashboard/blob/main/previews/Metabase%20Dashboard.png?raw=true)](https://github.com/strangercacaus/soccer_results_dashboard/blob/main/previews/Metabase%20Dashboard.png?raw=true){width="900"}
</figure>

### Página de Documentação

Uma página de documentação online foi gerada para o projeto, utilizando o pacote mkdocs para o Python

<figure markdown>
  [![Nome da Imagem](https://github.com/strangercacaus/soccer_results_dashboard/blob/main/previews/MKDocs%20Homepage.png?raw=true)](https://github.com/strangercacaus/soccer_results_dashboard/blob/main/previews/MKDocs%20Homepage.png?raw=true){width="900"}
</figure>
