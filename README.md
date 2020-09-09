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

Os serviços podem ser levantados via docker:

```
docker-compose up
```

### Configuração

#### Configuração do Banco de dados local
É possível setar as variáveis de ambiente usadas para a criação do banco de dados local.

a) Crie uma cópia do arquivo .env.sample no diretório raiz desse repositório e renomeie para .env (deve também estar no diretório raiz desse repositório)

b) Preencha as variáveis contidas no .env.sample também para o .env. Altere os valores conforme sua necessidade. Atente que se você está usando o banco local, o valor da variável POSTGRES_HOST deve ser postgres, que é o nome do serviço que será levantado pelo docker-compose.


### Ajuda

Acesse o Makefile para obter ajuda sobre os comandos que podem ser executados no repositório

```
make help
```
