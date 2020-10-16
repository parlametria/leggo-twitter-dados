-- TWEET PROPOSIÇÃO
BEGIN;

CREATE TEMP TABLE temp_tweet_proposicao AS SELECT * FROM tweet_proposicao LIMIT 0;

\copy temp_tweet_proposicao FROM '/data/bd/tweets/tweets_proposicoes.csv' WITH NULL AS 'NA' DELIMITER ',' CSV HEADER;

INSERT INTO tweet_proposicao
SELECT *
FROM temp_tweet_proposicao
ON CONFLICT (id_tweet, id_proposicao_leggo)
DO
  UPDATE
  SET 
    sigla = EXCLUDED.sigla;
    relator_proposicao = EXCLUDED.relator_proposicao;

DROP TABLE temp_tweet_proposicao;

COMMIT;
