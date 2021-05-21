-- TWEET RAW INFO
BEGIN;

CREATE TEMP TABLE temp_tweet_raw_info AS SELECT * FROM tweet_raw_info LIMIT 0;

\copy temp_tweet_raw_info FROM '/data/bd/tweet_raw_info.csv' WITH NULL AS 'NA' DELIMITER ',' CSV HEADER;

INSERT INTO tweet_raw_info
SELECT *
FROM temp_tweet_raw_info
ON CONFLICT (id)
DO
  UPDATE
  SET 
    total_tweets = EXCLUDED.total_tweets,
    total_parlamentares = EXCLUDED.total_parlamentares,
    total_influenciadores = EXCLUDED.total_influenciadores;

DROP TABLE temp_tweet_raw_info;

COMMIT;
