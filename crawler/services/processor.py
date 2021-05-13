from datetime import datetime
import pytz
import subprocess
import json
import re

from sqlalchemy.orm.exc import NoResultFound

from services.database.log_update_tweets import select_log_update_tweets
from models.log_update_tweets import Log_update_tweets

TZ = pytz.timezone('America/Recife')
SINCE_DEFAULT = '2019-01-31 00:00:00'


def process_tweets_by_username(username, until_date=None):
    try:
        log_user = select_log_update_tweets(user=username)
    except NoResultFound as e:
        print(e)
        log_user = Log_update_tweets(username=username, updated=None)

    if log_user.updated is None:
        since_date = SINCE_DEFAULT
    else:
        since_date = log_user.updated

    if until_date is None:
        until_date = datetime.now(tz=TZ)

    tweets = get_tweets_by_username(username, since_date, until_date)

    print(log_user.updated)
    print(since_date)
    print(until_date)
    print(tweets)

    # captura username no BD
    # cria intervalo de captura dos tweets

    # consulta os tweets via crawler do username para o intervalo
    # salva os tweets e atualiza o log para o username


def get_tweets_by_username(username, since_date, until_date):
    query = "from:"+username+" since:" + \
        since_date.strftime('%Y-%m-%d')+" until:" + \
        until_date.strftime('%Y-%m-%d')
    try:
        print(query)
        tweets = subprocess.run(["snscrape", "--jsonl", "twitter-search", query],
                                universal_newlines=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)

        for r in tweets.stdout.split('\n'):
            res = json.loads(r)
            text = re.sub('\n', ' ', res['content'])
            print(text)
    except:
        raise Exception("Não foi possível baixar os dados dos tweets")

    return tweets
