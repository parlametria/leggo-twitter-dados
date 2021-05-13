from datetime import datetime
import click

from services.database.ddl import create_tables, drop_tables
from services.processor import process_tweets_by_username


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

    date_time_str = '2019-02-02 00:00:00'
    # insert_log_update_tweets('gileadekelvin', date_time_str)
    # insert_tweet('1', 'gileadekelvin', text='sorria')
    # insert_tweet('2', 'gileadekelvin', text='o tempo cuida')
    # delete_tweet('2')
    # delete_log_update_tweets('gileadekelvin')

    # objects = []
    # l = dict(username='MarceloFreixo', updated=date_time_str)
    # u = dict(id_tweet='1', username='MarceloFreixo', text='tweet1')
    # u2 = dict(id_tweet='2', username='MarceloFreixo', text='tweet')
    # objects.append(u)
    # objects.append(u2)
    # upsert_tweets_username(l, objects)

    process_tweets_by_username('felipeneto', datetime.strptime(date_time_str, '%Y-%m-%d %H:%M:%S'))


cli.add_command(create_schema)
cli.add_command(drop_schema)
cli.add_command(teste)

if __name__ == '__main__':
    cli()
