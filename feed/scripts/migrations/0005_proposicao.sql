-- PROPOSIÇÃO
BEGIN;

ALTER TABLE proposicao
ADD COLUMN IF NOT EXISTS "destaque" BOOLEAN;

COMMIT;