-- TWEET PROPOSIÇÃO
BEGIN;

ALTER TABLE tema
ALTER COLUMN "nome" TYPE CHARACTER varying(80),
ALTER COLUMN "slug" TYPE CHARACTER varying(80);

COMMIT;
