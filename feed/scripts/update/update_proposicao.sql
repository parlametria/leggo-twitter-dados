-- PROPOSIÇÃO
BEGIN;

CREATE TEMP TABLE temp_proposicao AS SELECT * FROM proposicao LIMIT 0;

\copy temp_proposicao FROM '/data/bd/proposicoes/proposicoes.csv' WITH NULL AS 'NA' DELIMITER ',' CSV HEADER;

INSERT INTO proposicao
SELECT *
FROM temp_proposicao
ON CONFLICT (id_proposicao_leggo)
DO
  UPDATE
  SET 
    casa = EXCLUDED.casa,
    casa_origem = EXCLUDED.casa_origem,
    sigla = EXCLUDED.sigla,
    destaque = EXCLUDED.destaque;

DROP TABLE temp_proposicao;

COMMIT;
