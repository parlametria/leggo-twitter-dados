-- TWEET_RAW
BEGIN;

CREATE TEMP TABLE temp_tweet_raw AS SELECT * FROM tweet_raw LIMIT 0;

\copy temp_tweet_raw FROM '/data/bd/tweets/tweets.csv' WITH NULL AS 'NA' DELIMITER ',' CSV HEADER;

INSERT INTO tweet_raw
SELECT *
FROM temp_tweet_raw
ON CONFLICT (id_tweet)
DO
  UPDATE
  SET 
    username = EXCLUDED.username,
    text = EXCLUDED.text,
    date = EXCLUDED.date,
    url = EXCLUDED.url,
    reply_count = EXCLUDED.reply_count,
    retweet_count = EXCLUDED.retweet_count,
    like_count = EXCLUDED.like_count,
    quote_count = EXCLUDED.quote_count;

DROP TABLE temp_tweet_raw;

COMMIT;
