b := $(shell tput bold)
s := $(shell tput sgr0)
.DEFAULT_GOAL : help
help:
	@echo "\nLeggo Twitter Dados"
	@echo "Este arquivo ajuda no processamento dos dados usados no módulo Leggo Twitter\n"
	@echo "COMO USAR:\n\t'make <comando>'\n"
	@echo "COMANDOS:"
	@echo "\t$(b)help$(s) \t\t\tMostra esta mensagem de ajuda"
	@echo "\t$(b)bd-container-shell$(s)\tAbre o shell do BD Postgres local. É preciso que o container com o BD esteja executando."
	@echo "\t$(b)feed-db-shell$(s)\t\tAbre o shell do BD configurado no arquivo .env na raiz do repositório"
	@echo "\t$(b)feed-create-tables$(s)\tCria as tabelas para o Banco de dados"
	@echo "\t$(b)feed-import-data$(s)\tImporta dados para as tabelas para o Banco de dados"
	@echo "\t$(b)feed-update-data$(s)\tAtualiza dados para as tabelas para o Banco de dados"
	@echo "\t$(b)feed-drop-tables$(s)\tAtenção: Dropa as Tabelas para o Banco de dados"
	@echo "\t$(b)r-shell$(s)\t\t\tAbre uma instância bash dentro do container do r-leggo-twitter"
	@echo "\t$(b)r-export-data url="https://api.leggo.org.br"$(s)\t\tExecuta o processamento de dados (fetchers) para Proposições, parlamentares e tweets"
	@echo "\t$(b)r-export-data-db-format$(s)\tExecuta o processamentos dos dados para o formato do BD"
	@echo "\t$(b)feed-do-migrations$(s)\tAtualiza as tabelas para o Banco de dados"
	@echo "\t$(b)r-export-tweets-to-process$(s)\tRecupera os tweets do banco de dados que ainda não foram processados e salva em csv"
	@echo "\t$(b)feed-create-table-tweets-processados$(s)\tCria tabela de tweets processados"
	@echo "\t$(b)feed-drop-table-tweets-processados$(s)\tDropa tabela de tweets processados"
	@echo "\t$(b)feed-import-data-tweets-processados$(s)\tImporta dados de tweets processados a partir do csv"
	@echo "\t$(b)eed-update-data-tweets-processados$(s)\tAtualiza dados da tabela de tweets processados"
.PHONY: help
bd-container-shell:
	docker exec -it postgres-leggo-twitter psql -d leggotwitter -U postgres
.PHONY: bd-container-shell
feed-db-shell:
	docker-compose run --no-deps --rm feed python manage.py shell
.PHONY: feed-db-shell
feed-create-tables:
	docker-compose run --no-deps --rm feed python manage.py create-tables
.PHONY: feed-create-tables
feed-import-data:
	docker-compose run --no-deps --rm feed python manage.py import-data
.PHONY: feed-create-tables
feed-update-data:
	docker-compose run --no-deps --rm feed python manage.py update-data
.PHONY: feed-create-tables
feed-drop-tables:
	docker-compose run --no-deps --rm feed python manage.py drop-tables
.PHONY: feed-drop-tables
r-shell:
	docker exec -it r-leggo-twitter bash
.PHONY: r-shell
r-export-data:
	if [ -z "$(url)" ]; then echo "Insira uma url válida para API do Parlametria"; \
	else echo "\nUsando a API: "$(url); docker exec -it r-leggo-twitter bash -c "Rscript /leggo-twitter-dados/code/export_data.R -u $(url)"; fi
.PHONY: r-export-data
r-export-data-db-format:
	docker exec -it r-leggo-twitter bash -c "Rscript /leggo-twitter-dados/code/processor/export_data_to_db_format.R"
.PHONY: r-export-data-db-format
feed-do-migrations:
	docker-compose run --no-deps --rm feed python manage.py do-migrations
.PHONY: feed-do-migrations
r-export-tweets-to-process:
	docker exec -it r-leggo-twitter bash -c "Rscript /leggo-twitter-dados/code/tweets/export_tweets_to_process.R"
.PHONY: r-export-tweets-to-process
feed-create-table-tweets-processados:
	docker-compose run --no-deps --rm feed python manage.py create-table-tweets-processados
.PHONY: feed-create-table-tweets-processados
feed-drop-table-tweets-processados:
	docker-compose run --no-deps --rm feed python manage.py drop-table-tweets-processados
.PHONY: feed-drop-table-tweets-processados
feed-import-data-tweets-processados:
	docker-compose run --no-deps --rm feed python manage.py import-data-tweets-processados
.PHONY: feed-import-data-tweets-processados
feed-update-data-tweets-processados:
	docker-compose run --no-deps --rm feed python manage.py update-data-tweets-processados
.PHONY: feed-update-data-tweets-processados
