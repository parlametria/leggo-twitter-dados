import subprocess
import os
import click

host = os.environ['POSTGRES_HOST']
user = os.environ['POSTGRES_USER']
db = os.environ['POSTGRES_DB']
password = os.environ['POSTGRES_PASSWORD']
os.environ['PGPASSWORD'] = password

def execute_migration(file):
    subprocess.run(['psql', '-h', host, '-U', user, '-d', db, '-f', file])

@click.group()
def cli():
    pass

@click.command()
def create_tables():
    """Cria as tabelas no banco de dados"""
    execute_migration('/code/scripts/create/create_parlamentar.sql')
    execute_migration('/code/scripts/create/create_tweet.sql')
    execute_migration('/code/scripts/create/create_proposicao.sql')
    execute_migration('/code/scripts/create/create_tweet_proposicao.sql')
    execute_migration('/code/scripts/create/create_tema.sql')
    execute_migration('/code/scripts/create/create_tema_proposicao.sql')
    execute_migration('/code/scripts/create/create_agenda.sql')
    execute_migration('/code/scripts/create/create_agenda_proposicao.sql')
    execute_migration('/code/scripts/create/create_tweet_raw_info.sql')

@click.command()
def import_data():
    """Importa os dados dos csvs para as tabelas no banco de dados"""
    execute_migration('/code/scripts/import/import_dados.sql')

@click.command()
def update_data():
    """Atualiza os dados dos csvs para as tabelas no banco de dados"""
    execute_migration('/code/scripts/update/update_parlamentar.sql')
    execute_migration('/code/scripts/update/update_tweet.sql')
    execute_migration('/code/scripts/update/update_proposicao.sql')
    execute_migration('/code/scripts/update/update_tweet_proposicao.sql')
    execute_migration('/code/scripts/update/update_tema.sql')
    execute_migration('/code/scripts/update/update_tema_proposicao.sql')
    execute_migration('/code/scripts/update/update_agenda.sql')
    execute_migration('/code/scripts/update/update_agenda_proposicao.sql')
    execute_migration('/code/scripts/update/update_tweet_raw_info.sql')

@click.command()
@click.option('-d', '--drop')
def drop_tables(drop):
    """Atenção: Dropa as tabelas no banco de dados"""

    print(drop)
    if (drop == 'true'):
        entrada = "Y"
    else:
        print("Tem certeza?")
        entrada = input("Y/n ")

    if (entrada == "Y"):
        execute_migration('/code/scripts/drop/drop_tabelas.sql')
    else:
        print("Operação não realizada!")

@click.command()
def create_table_tweets_processados():
    """Cria tabela de tweets processados"""
    execute_migration('/code/scripts/create/create_tweet_processado.sql')

@click.command()
def import_data_tweets_processados():
    """Importa dados para a tabela de tweets processados"""
    execute_migration('/code/scripts/import/import_tweet_processado.sql')

@click.command()
def update_data_tweets_processados():
    """Atualiza os dados da tabela de tweets processados"""
    execute_migration('/code/scripts/update/update_tweet_processado.sql')

@click.command()
def drop_table_tweets_processados():
    """Dropa tabela de tweets processados"""
    execute_migration('/code/scripts/drop/drop_tweet_processado.sql')


@click.command()
def shell():
    """Acessa terminal do banco de dados"""
    subprocess.run(['psql', '-h', host, '-U', user, '-d', db])

@click.command()
def do_migrations():
    """Atualiza as tabelas para o Banco de dados"""
    execute_migration('/code/scripts/migrations/0001_tweet_proposicao.sql')
    execute_migration('/code/scripts/migrations/0002_tema.sql')
    execute_migration('/code/scripts/migrations/0003_tweet.sql')
    execute_migration('/code/scripts/migrations/0004_tweet.sql')
    execute_migration('/code/scripts/migrations/0005_proposicao.sql')
    execute_migration('/code/scripts/migrations/0006_tweet_raw_info.sql')

cli.add_command(shell)
cli.add_command(create_tables)
cli.add_command(import_data)
cli.add_command(update_data)
cli.add_command(drop_tables)
cli.add_command(do_migrations)
cli.add_command(create_table_tweets_processados)
cli.add_command(import_data_tweets_processados)
cli.add_command(update_data_tweets_processados)
cli.add_command(drop_table_tweets_processados)


if __name__ == '__main__':
    cli()
