from sqlalchemy import Column, String, DateTime
from sqlalchemy.orm import relationship

from config.base import Base


class Log_update_tweets(Base):
    __tablename__ = 'log_update_tweets'

    username = Column(String(32), primary_key=True)
    updated = Column(DateTime())

    tweets = relationship("Tweet", back_populates="log_update_tweets",
                          cascade="all, delete",
                          passive_deletes=True)

    def __repr__(self):
        return f"log(username={self.username!r}, updated={self.updated!r}"
