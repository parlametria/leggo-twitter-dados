-- TEMA
BEGIN;

ALTER TABLE tema
ALTER COLUMN "nome" TYPE CHARACTER varying(300),
ALTER COLUMN "slug" TYPE CHARACTER varying(300);

COMMIT;