import click
from datetime import datetime
import pytz

from config.log import logger
from services.database.ddl import create_tables, drop_tables
from services.processor import process_tweets_list


@click.group()
def cli():
    pass


@click.command()
def create_schema():
    logger.info("Criando tabelas do banco de dados...")
    create_tables()


@click.command()
def drop_schema():
    logger.info("Dropando tabelas do banco de dados...")
    drop_tables()


@click.command()
@click.option('-l', '--lista_usernames')
@click.option('-d', '--until_date')
def process_tweets(lista_usernames, until_date=None):
    if (until_date is not None):
        until_date = datetime.strptime(until_date + ' 00:00:00', '%Y-%m-%d %H:%M:%S')
        until_date = pytz.timezone('America/Recife').localize(until_date)
    process_tweets_list(lista_usernames, until_date)


cli.add_command(create_schema)
cli.add_command(drop_schema)
cli.add_command(process_tweets)

if __name__ == '__main__':
    cli()
