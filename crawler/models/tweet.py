from sqlalchemy import Column, String, Text, DateTime, Integer, ForeignKey
from sqlalchemy.orm import relationship

from models.log_update_tweets import Log_update_tweets
from config.base import Base


class Tweet(Base):
    __tablename__ = 'tweet_raw'

    id_tweet = Column(String(32), primary_key=True)
    username = Column(String(32), ForeignKey(
        "log_update_tweets.username", onupdate="CASCADE", ondelete="CASCADE"))
    text = Column(Text())
    date = Column(DateTime())
    url = Column(String())
    reply_count = Column(Integer())
    retweet_count = Column(Integer())
    like_count = Column(Integer())
    quote_count = Column(Integer())

    log_update_tweets = relationship(
        "Log_update_tweets", back_populates="tweets")

    def __repr__(self):
        return f"Tweet(id={self.id_tweet!r}, username={self.username!r})"
