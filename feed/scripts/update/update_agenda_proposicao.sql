-- AGENDA PROPOSIÇÃO
BEGIN;

CREATE TEMP TABLE temp_agenda_proposicao AS SELECT * FROM agenda_proposicao LIMIT 0;

\copy temp_agenda_proposicao FROM '/data/bd/agendas/agendas_proposicoes.csv' WITH NULL AS 'NA' DELIMITER ',' CSV HEADER;

INSERT INTO agenda_proposicao
SELECT *
FROM temp_agenda_proposicao
ON CONFLICT (id_proposicao_leggo, id_agenda)
DO NOTHING;

DROP TABLE temp_agenda_proposicao;

COMMIT;
