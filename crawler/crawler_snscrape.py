from snscrape.modules import twitter # pip3 install git+https://github.com/JustAnotherArchivist/snscrape.git
import json
import snscrape
import pandas as pd
import os
import subprocess
import time
import re
import unicodedata
import argparse

def unicode_filter(string):
    string = string.replace(u' \u200f','')
    string = string.replace(u'\u200f','')
    
    return string

"""
Twitter json Object structure example:
{
    "url": "https://twitter.com/opropriolavo/status/1212296533695225858",
    "date": "2020-01-01T08:56:31+00:00",
    "content": "Fazer tro\u00e7a da religi\u00e3o alheia \u00e9 coisa decente? Segundo o Fabio Porchat, sim. Mas e se for com a \
        religi\u00e3o que hoje em dia mais fornece v\u00edtimas \u00e0 sanha genocida de seus inimigos? A\u00ed j\u00e1 n\u00e3o \u00e9 \
        tro\u00e7a, \u00e9 genoc\u00eddio... https://t.co/nle4mEE6px", "renderedContent": "Fazer tro\u00e7a da religi\u00e3o alheia\
        \u00e9 coisa decente? Segundo o Fabio Porchat, sim. Mas e se for com a religi\u00e3o que hoje em dia mais fornece v\u00edtimas \
        \u00e0 sanha genocida de seus inimigos? A\u00ed j\u00e1 n\u00e3o \u00e9 tro\u00e7a, \u00e9 genoc\u00eddio... \
        facebook.com/olavo.decarval\u2026",
    "id": 1212296533695225858,
    "username": "opropriolavo", 
    "user": {
        "username": "opropriolavo", 
        "displayname": "Olavo de Carvalho", 
        "id": 2892290499, 
        "description": "Public Figure\n- Escritor\n- Fil\u00f3sofo\n- Autor de 2 Best-Sellers\n- Professor do Curso Online de Filosofia \
            (COF)", "rawDescription": "Public Figure\n- Escritor\n- Fil\u00f3sofo\n- Autor de 2 Best-Sellers\n- Professor do Curso Online \
            de Filosofia (COF)", 
        "descriptionUrls": [], 
        "verified": false, 
        "created": "2014-11-25T18:32:00+00:00", 
        "followersCount": 491766, 
        "friendsCount": 132, 
        "statusesCount": 5120, 
        "favouritesCount": 1758, 
        "listedCount": 792, 
        "mediaCount": 909, 
        "location": "", 
        "protected": false, 
        "linkUrl": "http://olavodecarvalho.org", 
        "linkTcourl": "https://t.co/mc80RtwxlT", 
        "profileImageUrl": "https://pbs.twimg.com/profile_images/1102366016359878656/Krw1ApwQ_normal.png", 
        "profileBannerUrl": "https://pbs.twimg.com/profile_banners/2892290499/1592918080"
    }, 
    "outlinks": ["https://www.facebook.com/olavo.decarvalho/posts/10157771054097192"], 
    "outlinksss": "https://www.facebook.com/olavo.decarvalho/posts/10157771054097192", 
    "tcooutlinks": ["https://t.co/nle4mEE6px"], 
    "tcooutlinksss": "https://t.co/nle4mEE6px", 
    "replyCount": 69,
    "retweetCount": 765, 
    "likeCount": 4402, 
    "quoteCount": 3, 
    "conversationId": 1212296533695225858, 
    "lang": "pt", 
    "source": "<a href=\"http://www.facebook.com/twitter\" rel=\"nofollow\">Facebook</a>", 
    "media": null, 
    "retweetedTweet": null, 
    "quotedTweet": null, 
    "mentionedUsers": null
}
"""

df = pd.read_csv('../data/parlamentares/perfil_parlamentar.csv')
df = df[df['tem twitter?']=='sim'].reset_index()
df = df.drop(columns=['index','tem twitter?','facebook (não conferido)','nome_civil','fazendo'])
df = df[pd.notna(df['twitter'])].reset_index()
df['twitter'] = df['twitter'].apply(unicode_filter)

parser = argparse.ArgumentParser()
parser.add_argument("--since", default='2019-01-01', type=str, help='starting date for the collection')
parser.add_argument("--until", default='2020-07-01', type=str, help='limit date for the collection')
args = parser.parse_args()
since = args.since
until = args.until

with open("tweets_parlamentares_"+since+"_to_"+until+".csv","w") as f:
    f.write("id,id_parlamentar,casa,nome_eleitoral,partido,uf,username,created_at,text,favorite_count,reply_count,retweet_count,interactions,status_url\n")
    for id,row in df.iterrows():
        user = row.twitter
        id_parlamentar = row.id_parlamentar
        casa = row.casa
        nome_eleitoral = row.nome_eleitoral
        partido = row.partido
        UF = row.UF
        query = "from:"+user+" since:"+since+" until:"+until
        try:
            print(query)
            cp = subprocess.run(["snscrape", "--jsonl", "twitter-search", query], universal_newlines=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        except:
            print("crawler error")
            time.sleep(300)
            cp = subprocess.run(["snscrape", "--jsonl", "twitter-search", query], universal_newlines=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        for r in cp.stdout.split('\n'):
            #print(r)
            try:
                res = json.loads(r)
                text = re.sub('\n', ' ', res['content'])
                interactions = int(res['replyCount'])+int(res["retweetCount"])
                #print(type(res["replyCount"]))
                f.write(str(res['id'])+','+str(id_parlamentar)+","+casa+","+nome_eleitoral+","+partido+","+UF+","+user+","+res['date'][0:10]+",\""+text+"\","+str(res["replyCount"])+","+str(res["retweetCount"])+","+str(interactions)+","+res["url"]+"\n")
            except:
                pass


    