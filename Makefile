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
	@echo "\t$(b)bd-container-shell$(s) \t\t\tAbre o shell do BD Postgres local. É preciso que o container com o BD esteja executando."
.PHONY: help
bd-container-shell:
	docker exec -it postgres-leggo-twitter psql -d leggotwitter -U postgres
.PHONY: bd-container-shell
feed-db-shell:
	docker-compose run --no-deps --rm feed python manage.py shell
.PHONY: feed-db-shell
