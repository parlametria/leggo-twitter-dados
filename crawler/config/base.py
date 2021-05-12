from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

"""
Configura conexão com banco de dados
"""

engine = create_engine(
    'postgresql://postgres:secret@postgres:5432/leggotwitter')

Session = sessionmaker(bind=engine)

Base = declarative_base()
