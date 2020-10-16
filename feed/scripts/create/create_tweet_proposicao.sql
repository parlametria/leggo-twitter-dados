DROP TABLE IF EXISTS tweet_proposicao;

CREATE TABLE IF NOT EXISTS "tweet_proposicao" (    
    "id_tweet" VARCHAR(32),
    "sigla" VARCHAR(40),
    "id_proposicao_leggo" VARCHAR(40),
    "relator_proposicao" BOOLEAN,
    PRIMARY KEY("id_proposicao_leggo", "id_tweet"),
    FOREIGN KEY ("id_proposicao_leggo") REFERENCES proposicao ("id_proposicao_leggo") ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY ("id_tweet") REFERENCES tweet ("id_tweet") ON DELETE CASCADE ON UPDATE CASCADE
);
