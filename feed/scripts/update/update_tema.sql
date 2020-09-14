-- TEMA
BEGIN;

CREATE TEMP TABLE temp_tema AS SELECT * FROM tema LIMIT 0;

\copy temp_tema FROM '/data/bd/temas/temas.csv' WITH NULL AS 'NA' DELIMITER ',' CSV HEADER;

INSERT INTO tema
SELECT *
FROM temp_tema
ON CONFLICT (id)
DO
  UPDATE
  SET 
    nome = EXCLUDED.nome,
    slug = EXCLUDED.slug;

DROP TABLE temp_tema;

COMMIT;
