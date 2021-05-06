## Leggo Twitter Dados

<br>

Este é módulo é responsável pelo processamento dos dados que envolvem o twitter, proposições e parlamentares da plataforma [Leggo](https://leggo.parlametria.org).

## Docker

Todos os serviços utilizados pelo Leggo Twitter
 utilizam docker para configuração do ambiente e execução do script.

Instale o [docker](https://docs.docker.com/install/) e o [docker-compose](https://docs.docker.com/compose/install/). Tenha certeza que você também tem o [Make](https://www.gnu.org/software/make/) instalado.

### Serviços

Os serviços providos pelo Leggo twitter incluem:

- **postgres**: Serviço com o Banco de dados usado pelos outros módulos do repositório
- **feed**: Serviço para acessar e modificar o Banco de dados. Este serviço é uma CLI que possui comandos úteis para acesso e gerenciamento do Banco de dados usando o módulo Feed que contém as migrations executadas no BD. Para mais instruções sobre esse serviço acesse o `make --help`.

Os serviços podem ser levantados via docker:

```
docker-compose up
```

### Configuração

#### **Configuração do Banco de dados local**
É possível setar as variáveis de ambiente usadas para a criação do banco de dados local.

a) Crie uma cópia do arquivo .env.sample no diretório raiz desse repositório e renomeie para .env (deve também estar no diretório raiz desse repositório)

b) Preencha as variáveis contidas no .env.sample também para o .env. Altere os valores conforme sua necessidade. Atente que se você está usando o banco local, o valor da variável POSTGRES_HOST deve ser postgres, que é o nome do serviço que será levantado pelo docker-compose.

#### **Importe os dados**

Alguns arquivos grandes são necessários e estão fora desse repositório. É necessário baixá-los antes da dos passos seguinte. São eles:

* [Tweets dos parlamentares](https://drive.google.com/file/d/1ahsbsFBwBED7ez9NViC5De4pbmbusbIP/view?usp=sharing): salvar em `data/tweets`

Se ainda não criou as tabelas do BD:

```
make feed-create-tables
```

Se você nunca criou as tabelas do banco de dados:

```
make feed-create-tables
```

E se também nunca aplicou as migrations:

```
make feed-do-migrations
```

Para atualizar e importar os dados execute:

```
make feed-update-data
```

### Como processar os dados

Nesta seção apresentaremos dois comandos úteis para o processamento dos dados usados pelo Banco de Dados do repositório.

1. A primeira etapa do processamento envolve capturar, processar e salvar os dados de proposições, parlamentares e tweets. Para isto é possível executar o comando:

```
make r-export-data url=https://api.leggo.org.br
```

Todos os dados serão salvos na pasta `data/` conforme o módulo ao qual pertence.

2. A segunda etapa do processamento trata de preparar os dados para o formato do BD do leggo-twitter. Neste caso o comando executado é:

```
make r-export-data-db-format
```

Os dados já prontos para serem importados par ao BD estarão presentes em `data/bd`

### Ajuda

Acesse o Makefile para obter ajuda sobre os comandos que podem ser executados no repositório

```
make help
```

## Configuração dos ambientes de desenvolvimento, validação e produção

Com o objetivo de automatizar os comandos de processar, atualizar e resetar os dados e o banco de dados do Twitter em diferentes ambientes, foram criados comandos específicos para orquestrar o serviço do twitter-dados.

Esses comandos fazem uso da arquitetura docker deste repositório que considera no ambiente de desenvolvimento os arquivos docker-compose.yml e docker-compose.override.yml. No ambiente de validação os arquivos docker-compose.yml e staging.yml e no de produção docker-compose.yml e prod.yml.

### Passo 1
Para usar os comando orquestrados em vários ambientes é necessário que sejam criados arquivos de environment: `.env`, `.env.staging` e `.env.prod`. Esses arquivos devem estar baseados no `.env.sample` com seus respectivos valores.

### Passo 2

Clonar o [leggo-geral](https://github.com/parlametria/leggo-geral) e configurar as variáveis de ambiente com base no README do leggo-geral.

### Passo 3
Usar os comandos do leggo-geral para processar os dados do leggo-twitter:
```
./update_leggo_data.sh -process-leggo-twitter <env>
```

<env> pode ser `development` que usará o código mais atual com base no volume montado entre o diretório code e o container do r-twitter-service.

<env> pode ser `production` que fará o build da imagem do r-twitter-service com base na versão atual do código.

### Passo 4
Se você quiser também é possível atualizar os bancos de dados de diferentes ambientes:

```
./update_leggo_data.sh -update-db-twitter <env>
```

<env> pode ser `development`, `staging`, `production`.

Neste comando as migrations são aplicadas e o módulo de upsert é usado para atualizar os dados nas tabelas do bd.

### Passo 4
Se você quiser também é possível resetar e popular novamente o banco de dados do zero:

```
./update_leggo_data.sh -reset-db-twitter <env>
```

<env> pode ser `development`, `staging`, `production`.

Neste comando as tabelas são dropadas, são criadas novamente e os dados são inseridos também.
