\copy tweet_raw TO PROGRAM 'gzip > /data/export/tweets/tweet_raw.csv.gz' DELIMITER ',' CSV HEADER;