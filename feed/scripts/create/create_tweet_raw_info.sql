DROP TABLE IF EXISTS tweet_raw_info;

CREATE TABLE IF NOT EXISTS "tweet_raw_info" (
    "id" VARCHAR(32),
    "total_tweets" INT,
    "total_parlamentares" INT,
    "total_influenciadores" INT,
    PRIMARY KEY("id")
)