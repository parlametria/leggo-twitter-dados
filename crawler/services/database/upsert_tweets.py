from sqlalchemy.dialects.postgresql import insert

from config.base import Session
from models.tweet import Tweet
from models.log_update_tweets import Log_update_tweets


def upsert_tweets_username(username, tweets):
    """
    Insere um username na tabela de log_update_tweets
    Insere um array de objetos de tweets no banco de dados
    Caso já exista então atualiza
    Parâmetros
    ----------
    username : dict
        Dicionário com o username para ser inserido/atualizado.
        exemplo dict(username='john', updated='2019-02-01T14:34:11Z')
    tweets : list
        list de dicionários com os tweets para serem inseridos/atualizados.
        exemplo: [dict(id_tweet='1', username='john', text='tweet')]
    """
    session = Session()

    insert_username = insert(Log_update_tweets).values(username)
    update_columns_username = {
        col.name: col for col in insert_username.excluded if col.name not in ('username')}

    do_update_username = insert_username.on_conflict_do_update(
        index_elements=['username'],
        set_=update_columns_username
    )

    session.execute(do_update_username)

    insert_tweet = insert(Tweet).values(tweets)
    update_columns_tweet = {
        col.name: col for col in insert_tweet.excluded if col.name not in ('id_tweet')}

    do_update_stmt = insert_tweet.on_conflict_do_update(
        index_elements=['id_tweet'],
        set_=update_columns_tweet
    )

    session.execute(do_update_stmt)

    # Realiza commit e encerra sessão
    session.commit()
    session.close()
