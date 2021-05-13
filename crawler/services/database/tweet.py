from sqlalchemy import delete

from config.base import Session
from models.tweet import Tweet

def insert_tweet(id_tweet, username, text=None, date=None,
                 url=None, reply_count=None, retweet_count=None,
                 like_count=None, quote_count=None):
    """
    Insere um novo tweet no banco de dados
    Caso já exista então atualiza
    Parâmetros
    ----------
    id_tweet : str
        Id do tweet (deve ser único)
    username : str
        Username no autor do tweet
    text : str
        Texto do tweet
    username : str
        Username no autor do tweet
    date : datetime
        Data do tweet
    url : str
        URL para o tweet
    reply_count : int
        Contagem de replies
    retweet_count : int
        Contagem de retweets
    like_count : int
        Contagem de likes
    quote_count : int
        Contagem de citações
    """
    session = Session()

    new_tweet = Tweet(id_tweet=id_tweet, username=username, text=text, date=date,
                      url=url, reply_count=reply_count, retweet_count=retweet_count,
                      like_count=like_count, quote_count=quote_count)

    session.merge(new_tweet)

    # Realiza commit e encerra sessão
    session.commit()
    session.close()


def delete_tweet(id):
    """
    Deleta um tweet no banco de dados
    ----------
    id : str
        Id do tweet
    """
    session = Session()

    session.execute(delete(Tweet).where(Tweet.id_tweet == id))

    # Realiza commit e encerra sessão
    session.commit()
    session.close()
