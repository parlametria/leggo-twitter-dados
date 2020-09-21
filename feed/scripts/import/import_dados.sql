\copy parlamentar FROM '/data/bd/parlamentares/parlamentares.csv' WITH NULL AS 'NA' DELIMITER ',' CSV HEADER;
\copy tweet FROM '/data/bd/tweets/tweets.csv' WITH NULL AS 'NA' DELIMITER ',' CSV HEADER;
\copy proposicao FROM '/data/bd/proposicoes/proposicoes.csv' WITH NULL AS 'NA' DELIMITER ',' CSV HEADER;
\copy agenda FROM '/data/bd/agendas/agendas.csv' WITH NULL AS 'NA' DELIMITER ',' CSV HEADER;
\copy tema FROM '/data/bd/temas/temas.csv' WITH NULL AS 'NA' DELIMITER ',' CSV HEADER;
\copy agenda_proposicao FROM '/data/bd/agendas/agendas_proposicoes.csv' WITH NULL AS 'NA' DELIMITER ',' CSV HEADER;
\copy tema_proposicao FROM '/data/bd/temas/temas_proposicoes.csv' WITH NULL AS 'NA' DELIMITER ',' CSV HEADER;
\copy tweet_proposicao FROM '/data/bd/tweets/tweets_proposicoes.csv' WITH NULL AS 'NA' DELIMITER ',' CSV HEADER;