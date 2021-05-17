from config.base import engine, Base
from models.tweet import Tweet
from models.log_update_tweets import Log_update_tweets


def create_tables():
    """
    Cria as tabelas no banco de dados
    """
    Base.metadata.create_all(engine)


def drop_tables():
    """
    Dropa todas as tabelas no banco de dados
    """
    print("Tem certeza?")
    entrada = input("Y/n ")

    if (entrada == "Y"):
        Tweet.__table__.drop(engine)
        Log_update_tweets.__table__.drop(engine)
    else:
        print("Operação não realizada")
