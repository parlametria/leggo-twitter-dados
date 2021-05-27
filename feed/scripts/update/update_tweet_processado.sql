-- TWEET_PROCESSADO
BEGIN;

CREATE TEMP TABLE temp_tweet_processado AS SELECT * FROM tweet_processado LIMIT 0;

\copy temp_tweet_processado FROM '/data/tweets/tweets_processados.csv' WITH NULL AS 'NA' DELIMITER ',' CSV HEADER;

INSERT INTO tweet_processado
SELECT *
FROM temp_tweet_processado
ON CONFLICT (id_tweet)
DO NOTHING;

DROP TABLE temp_tweet_processado;

COMMIT;
