## Módulo Feed

Este módulo é responsável por gerenciar o acesso e as modificações realizadas no Banco de Dados do repositório. Seu objetivo é provê uma Interface de linha de comando (CLI) para execução de migrations que alteram ou atualizam o banco de dados e seu conteúdo.

O script manage.py contém os comandos da CLI.
A pasta scripts contém o código das migrations a serem executadas no banco de dados.

A CLI é construída usando [Click](https://click.palletsprojects.com/en/7.x/).

A CLI acessa qualquer Banco de Dados Postgres (Versão 12.x) desde que suas credenciais estejam exportadas no ambiente de execução. 

As variáveis necessárias são: POSTGRES_HOST, POSTGRES_USER, POSTGRES_DB e POSTGRES_PASSWORD.
