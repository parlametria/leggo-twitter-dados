import click

from services.ddl import create_tables, drop_tables
from services.tweet import insert_tweet, delete_tweet
from services.log_update_tweets import insert_log_update_tweets, delete_log_update_tweets
from services.upsert_tweets import upsert_tweets_username
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

    date_time_str = '2020-02-01T14:34:11Z'
    # insert_log_update_tweets('gileadekelvin', date_time_str)
    # insert_tweet('1', 'gileadekelvin', text='sorria')
    # insert_tweet('2', 'gileadekelvin', text='o tempo cuida')
    # delete_tweet('2')
    # delete_log_update_tweets('gileadekelvin')

    objects = []
    l = dict(username='john', updated=date_time_str)
    u = dict(id_tweet='1', username='john', text='tweet1')
    u2 = dict(id_tweet='2', username='john', text='tweet')
    objects.append(u)
    objects.append(u2)
    upsert_tweets_username(l, objects)


cli.add_command(create_schema)
cli.add_command(drop_schema)
cli.add_command(teste)

if __name__ == '__main__':
    cli()
