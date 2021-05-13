import click

from services.database.ddl import create_tables, drop_tables
from services.database.tweet import insert_tweet, delete_tweet
from services.database.log_update_tweets import (insert_log_update_tweets,
                                                 delete_log_update_tweets,
                                                 select_log_update_tweets)
from services.database.upsert_tweets import upsert_tweets_username
from services.processor import process_tweets_by_username
from models.tweet import Tweet
from models.log_update_tweets import Log_update_tweets


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

    date_time_str = '2021-05-11T14:34:11Z'
    # insert_log_update_tweets('gileadekelvin', date_time_str)
    # insert_tweet('1', 'gileadekelvin', text='sorria')
    # insert_tweet('2', 'gileadekelvin', text='o tempo cuida')
    # delete_tweet('2')
    # delete_log_update_tweets('gileadekelvin')

    objects = []
    l = dict(username='MarceloFreixo', updated=date_time_str)
    u = dict(id_tweet='1', username='MarceloFreixo', text='tweet1')
    u2 = dict(id_tweet='2', username='MarceloFreixo', text='tweet')
    objects.append(u)
    objects.append(u2)
    upsert_tweets_username(l, objects)

    process_tweets_by_username('MarceloFreixo')


cli.add_command(create_schema)
cli.add_command(drop_schema)
cli.add_command(teste)

if __name__ == '__main__':
    cli()
