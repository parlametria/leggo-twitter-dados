-- TEMA PROPOSIÇÃO
BEGIN;

CREATE TEMP TABLE temp_tema_proposicao AS SELECT * FROM tema_proposicao LIMIT 0;

\copy temp_tema_proposicao FROM '/data/bd/temas/temas_proposicoes.csv' WITH NULL AS 'NA' DELIMITER ',' CSV HEADER;

INSERT INTO tema_proposicao
SELECT *
FROM temp_tema_proposicao
ON CONFLICT (id_proposicao_leggo, id_tema)
DO NOTHING;

DROP TABLE temp_tema_proposicao;

COMMIT;
