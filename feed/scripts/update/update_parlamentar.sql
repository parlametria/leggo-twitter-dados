-- PARLAMENTAR
BEGIN;

CREATE TEMP TABLE temp_parlamentar AS SELECT * FROM parlamentar LIMIT 0;

\copy temp_parlamentar FROM '/data/bd/parlamentares/parlamentares.csv' WITH NULL AS 'NA' DELIMITER ',' CSV HEADER;

INSERT INTO parlamentar
SELECT *
FROM temp_parlamentar
ON CONFLICT (id_parlamentar_parlametria)
DO
  UPDATE
  SET 
    id_parlamentar = EXCLUDED.id_parlamentar,
    casa = EXCLUDED.casa;

DROP TABLE temp_parlamentar;

COMMIT;
