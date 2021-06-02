import os

from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

postgres_uri = os.environ['POSTGRES_URI']

"""
Configura conexão com banco de dados
"""

engine = create_engine(postgres_uri)

Session = sessionmaker(bind=engine)

Base = declarative_base()
