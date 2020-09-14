b := $(shell tput bold)
s := $(shell tput sgr0)
.DEFAULT_GOAL : help
help:
	@echo "\nLeggo Twitter Dados"
	@echo "Este arquivo ajuda no processamento dos dados usados no módulo Leggo Twitter\n"
	@echo "COMO USAR:\n\t'make <comando>'\n"
	@echo "COMANDOS:"
	@echo "\t$(b)help$(s) \t\t\t\t\tMostra esta mensagem de ajuda"
	@echo "\t$(b)bd-container-shell$(s) \t\t\tAbre o shell do BD Postgres local. É preciso que o container com o BD esteja executando."
	@echo "\t$(b)feed-db-shell$(s) \t\t\tAbre o shell do BD configurado no arquivo .env na raiz do repositório"
	@echo "\t$(b)feed-create-tables$(s) \t\t\tCria as tabelas para o Banco de dados"
	@echo "\t$(b)feed-import-data$(s) \t\t\tImporta dados para as tabelas para o Banco de dados"
	@echo "\t$(b)feed-update-data$(s) \t\t\tAtualiza dados para as tabelas para o Banco de dados"
	@echo "\t$(b)feed-drop-tables$(s) \t\t\t Atenção: Dropa as Tabelas para o Banco de dados"
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