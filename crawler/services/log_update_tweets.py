from sqlalchemy import delete

from config.base import Session
from models.log_update_tweets import Log_update_tweets


def insert_log_update_tweets(username, updated=None):
    """
    Insere um username e a data de atualização no banco de dados
    Caso já exista então atualiza
    Parâmetros
    ----------
    username : str
        Username no twitter
    updated : datetime
        Data da última atualização dos tweets
    """
    session = Session()

    new_update_log = Log_update_tweets(username=username, updated=updated)

    session.merge(new_update_log)

    # Realiza commit e encerra sessão
    session.commit()
    session.close()


def delete_log_update_tweets(user):
    """
    Deleta um Username no banco de dados
    ----------
    user : str
        Username a ser deletado
    """
    session = Session()

    session.execute(delete(Log_update_tweets).where(
        Log_update_tweets.username == user))

    # Realiza commit e encerra sessão
    session.commit()
    session.close()
