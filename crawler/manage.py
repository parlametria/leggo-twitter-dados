import click

from services.ddl import create_tables, drop_tables
from services.tweet import insert_tweet, delete_tweet
from services.log_update_tweets import insert_log_update_tweets, delete_log_update_tweets


@click.group()
def cli():
    pass


@click.command()
def create_schema():
    print("Criando tabelas do banco de dados...")
    create_tables()


@click.command()
def drop_schema():
    print("Dropando tabelas do banco de dados...")
    drop_tables()


@click.command()
def teste():
    # TODO: remover este comando após a fase de desenvolvimento

    date_time_str = '2019-02-01T14:34:11Z'
    insert_log_update_tweets('gileadekelvin', date_time_str)
    insert_tweet('1', 'gileadekelvin', text='sorria')
    insert_tweet('2', 'gileadekelvin', text='o tempo cuidar')
    # delete_tweet('2')
    # delete_log_update_tweets('gileadekelvin')


cli.add_command(create_schema)
cli.add_command(drop_schema)
cli.add_command(teste)

if __name__ == '__main__':
    cli()
