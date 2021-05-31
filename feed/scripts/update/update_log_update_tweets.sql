-- LOG_UPDATE_TWEETS
BEGIN;

CREATE TEMP TABLE temp_log_update_tweets AS SELECT * FROM log_update_tweets LIMIT 0;

\copy temp_log_update_tweets FROM '/data/bd/tweets/tweets.csv' WITH NULL AS 'NA' DELIMITER ',' CSV HEADER;

INSERT INTO log_update_tweets
SELECT *
FROM temp_log_update_tweets
ON CONFLICT (username)
DO
  UPDATE
  SET 
    updated = EXCLUDED.updated;

DROP TABLE temp_log_update_tweets;

COMMIT;
