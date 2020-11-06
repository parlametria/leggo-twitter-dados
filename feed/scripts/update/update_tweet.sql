-- TWEET
BEGIN;

CREATE TEMP TABLE temp_tweet AS SELECT * FROM tweet LIMIT 0;

\copy temp_tweet FROM '/data/bd/tweets/tweets.csv' WITH NULL AS 'NA' DELIMITER ',' CSV HEADER;

INSERT INTO tweet
SELECT *
FROM temp_tweet
ON CONFLICT (id_tweet)
DO
  UPDATE
  SET 
    id_parlamentar_parlametria = EXCLUDED.id_parlamentar_parlametria,
    username = EXCLUDED.username,
    created_at = EXCLUDED.created_at,
    text = EXCLUDED.text,
    interactions = EXCLUDED.interactions,
    url = EXCLUDED.url;

DROP TABLE temp_tweet;

COMMIT;
