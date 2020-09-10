import subprocess
import os
import click

host = os.environ['POSTGRES_HOST']
user = os.environ['POSTGRES_USER']
db = os.environ['POSTGRES_DB']
password = os.environ['POSTGRES_PASSWORD']
os.environ['PGPASSWORD'] = password

@click.group()
def cli():
    pass

@click.command()
def shell():
    """Acessa terminal do banco de dados"""
    subprocess.run(['psql', '-h', host, '-U', user, '-d', db])

cli.add_command(shell)

if __name__ == '__main__':
    cli()
