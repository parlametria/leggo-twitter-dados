from datetime import datetime
import pytz
import subprocess
import json
import re

import pandas as pd
from sqlalchemy.orm.exc import NoResultFound

from services.database.log_update_tweets import select_log_update_tweets
from services.database.upsert_tweets import upsert_tweets_username
from models.log_update_tweets import Log_update_tweets

TZ = pytz.timezone('America/Recife')
SINCE_DEFAULT = '2019-02-01 00:00:00'


def process_by_username(datapath):
    """
    Faz processamento para cada linha do df gerado
    ----------
    datapath : str
        Caminho para o csv
    """

    df = pd.read_csv(datapath)
    for row in df.iterrows():        
        print(row['username'])


def process_tweets_by_username(username, until_date=None):
    """
    Consulta log do usuário para checar ultima atualização
    Cria intervalo de datas de captura dos tweets
    Consulta os tweets via crawler do usuário para o intervalo de datas
    Salva os tweets e atualiza o log para o usuário
    ----------
    username : str
        username do perfil no Twitter
    until_date : datetime
        Data final do intervalo de captura
    """
    try:
        log_user = select_log_update_tweets(user=username)
    except NoResultFound as e:
        print(e)
        log_user = Log_update_tweets(username=username, updated=None)

    if log_user.updated is None:
        since_date = datetime.strptime(SINCE_DEFAULT, '%Y-%m-%d %H:%M:%S')
    else:
        since_date = log_user.updated

    if until_date is None:
        until_date = datetime.now(tz=TZ)

    if (until_date > since_date):
        try:
            log_user = dict(username=log_user.username, updated=until_date)
            tweets = get_tweets_by_username(username, since_date, until_date)
            upsert_tweets_username(log_user, tweets)
        except Exception as e:
            print(e)
            return(False)
    return(True)


def get_tweets_by_username(username, since_date, until_date):
    tweets = []
    query = "from:"+username+" since:" + \
        since_date.strftime('%Y-%m-%d')+" until:" + \
        until_date.strftime('%Y-%m-%d')
    try:
        print(query)
        result = subprocess.run(["snscrape", "--jsonl", "twitter-search", query],
                                universal_newlines=True, stdout=subprocess.PIPE,
                                stderr=subprocess.PIPE)
        for r in result.stdout.split('\n'):
            try:
                res = json.loads(r)
                id_tweet = res['id']
                text = re.sub('\n', ' ', res['content'])
                text = text.replace('\"', '“')
                date = res['date']
                url = res['url']
                reply_count = int(res['replyCount'])
                retweet_count = int(res['retweetCount'])
                like_count = int(res['likeCount'])
                quote_count = int(res['quoteCount'])
                tweet = dict(id_tweet=id_tweet, username=username, text=text,
                             date=date, url=url,
                             reply_count=reply_count, retweet_count=retweet_count,
                             like_count=like_count, quote_count=quote_count)
                # print(tweet)
                tweets.append(tweet)
            except Exception as e:
                # print(e)
                pass
    except Exception as e:
        # print(e)
        raise Exception("Não foi possível baixar os dados dos tweets")

    return tweets
