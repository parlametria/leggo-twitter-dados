from sqlalchemy import delete

from config.base import Session
from models.tweet import Tweet


def insert_tweet(id_tweet, username, text=None, date=None,
                 url=None, replyCount=None, retweetCount=None,
                 likeCount=None, quoteCount=None):
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
    replyCount : int
        Contagem de replies
    retweetCount : int
        Contagem de retweets
    likeCount : int
        Contagem de likes
    quoteCount : int
        Contagem de citações
    """
    session = Session()

    new_tweet = Tweet(id_tweet=id_tweet, username=username, text=text, date=date,
                      url=url, replyCount=replyCount, retweetCount=retweetCount,
                      likeCount=likeCount, quoteCount=quoteCount)

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
