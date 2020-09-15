-- AGENDA
BEGIN;

CREATE TEMP TABLE temp_agenda AS SELECT * FROM agenda LIMIT 0;

\copy temp_agenda FROM '/data/bd/agendas/agendas.csv' WITH NULL AS 'NA' DELIMITER ',' CSV HEADER;

INSERT INTO agenda
SELECT *
FROM temp_agenda
ON CONFLICT (id)
DO
  UPDATE
  SET 
    nome = EXCLUDED.nome,
    slug = EXCLUDED.slug;

DROP TABLE temp_agenda;

COMMIT;
