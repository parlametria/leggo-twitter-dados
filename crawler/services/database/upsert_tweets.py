from sqlalchemy.dialects.postgresql import insert

from config.log import logger
from config.base import Session
from models.tweet import Tweet
from models.log_update_tweets import Log_update_tweets


def upsert_tweets_username(log_user, tweets):
    """
    Insere um log_user na tabela de log_update_tweets
    Insere um array de objetos de tweets no banco de dados
    Caso já exista então atualiza
    Parâmetros
    ----------
    log_user : dict
        Dicionário com o username para ser inserido/atualizado.
        exemplo dict(username='john', updated='2019-02-01T14:34:11Z')
    tweets : list
        list de dicionários com os tweets para serem inseridos/atualizados.
        exemplo: [dict(id_tweet='1', username='john', text='tweet')]
    """
    session = Session()

    insert_log_user = insert(Log_update_tweets).values(log_user)
    update_columns_username = {
        col.name: col for col in insert_log_user.excluded if col.name not in ('username')}

    do_update_username = insert_log_user.on_conflict_do_update(
        index_elements=['username'],
        set_=update_columns_username
    )

    session.execute(do_update_username)

    if (len(tweets) > 0):
        insert_tweet = insert(Tweet).values(tweets)
        update_columns_tweet = {
            col.name: col for col in insert_tweet.excluded if col.name not in ('id_tweet')}

        do_update_stmt = insert_tweet.on_conflict_do_update(
            index_elements=['id_tweet'],
            set_=update_columns_tweet
        )

        session.execute(do_update_stmt)
    else:
        logger.info("Nenhum novo tweet foi capturado para " +
                    log_user['username'])

    # Realiza commit e encerra sessão
    session.commit()
    session.close()
